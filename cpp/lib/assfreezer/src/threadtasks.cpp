
/* $Author$
 * $LastChangedDate: 2010-01-28 11:47:32 +1100 (Thu, 28 Jan 2010) $
 * $Rev: 9262 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/threadtasks.cpp $
 */

#include <qsqlquery.h>
#include <qsqlerror.h>

#include "database.h"

#include "hostservice.h"
#include "user.h"
#include "jobstatus.h"

#include "threadtasks.h"

#define CHECK_CANCEL if( mCancel ) return;

static bool staticJobListDataRetrieved = false;

StaticJobListDataTask::StaticJobListDataTask( QObject * rec )
: ThreadTask( STATIC_JOB_LIST_DATA, rec )
, mHasData( false )
{}

void StaticJobListDataTask::run()
{
	if( !staticJobListDataRetrieved ) {
		mJobTypes = JobType::select();
		CHECK_CANCEL
		mProjects = Project::select( "WHERE keyelement in (SELECT fkeyproject FROM Job group by fkeyproject)" );
		CHECK_CANCEL
		// Ensure host table is preloaded
		Host::select();
		mHasData = staticJobListDataRetrieved = true;
	}
}

StaticHostListDataTask::StaticHostListDataTask( QObject * rec )
: ThreadTask( STATIC_HOST_LIST_DATA, rec )
{}

void StaticHostListDataTask::run()
{
	mServices = Service::select();
}

JobListTask::JobListTask( QObject * rec, const JobFilter & jf, const JobList & jobList, ProjectList projects, bool fetchJobServices, bool needDeps )
: ThreadTask( JOB_LIST, rec )
, mJobFilter( jf )
, mJobList( jobList )
, mProjects( projects )
, mFetchJobServices( fetchJobServices )
, mFetchJobDeps( needDeps )
{}

void JobListTask::run()
{
	User::select(); // Make sure usr is loaded
	CHECK_CANCEL

	if( mJobList.size() ) {
		mReturn = mJobList.reloaded();
	} else
	
	
	// If we have a project list, and all projects are hidden, then there will be no items, so just clear the list
	if( (mJobFilter.hiddenProjects.size() < (int)mProjects.size() || mJobFilter.showNonProjectJobs)
			&& !mJobFilter.typeToShow.isEmpty()
			&& !mJobFilter.statusToShow.isEmpty()
		)
	{
		QStringList filters;
		
		//LOG_5( "Statuses to show: "	+ mJobFilter.statusToShow.join(",") );
		//LOG_5( "Hidden Projects: " + mJobFilter.hiddenProjects.join(",") );
		//LOG_5( "Non-Project Jobs: " + QString(mJobFilter.showNonProjectJobs ? "true" : "false") );
		//LOG_5( "User List: " + mJobFilter.userList.join(",") );

		if( mJobFilter.statusToShow.size() > 0 && mJobFilter.statusToShow.size() != 9 )
			filters << "status IN ('" + mJobFilter.statusToShow.join("','") + "')";

		if( mJobFilter.userList.size() > 0 )
			filters << " fkeyUsr IN (" + mJobFilter.userList.join(",") + ")";

		if( mJobFilter.hiddenProjects.size() > 0 || !mJobFilter.showNonProjectJobs ) {
			QStringList projectKeys;
			foreach( Project p, mProjects ) {
				QString pkey(QString::number( p.key() ));
				if( !mJobFilter.hiddenProjects.contains( pkey ) )
					projectKeys.append( pkey );
			}
			if( mJobFilter.showNonProjectJobs )
				projectKeys.append( "0" );
			if( projectKeys.size() || mJobFilter.showNonProjectJobs ) {
				QString where = "(";
				if( projectKeys.size() )
					where += " fkeyproject IN (" + projectKeys.join(",") + ")";
				if( mJobFilter.showNonProjectJobs )
					where += " OR fkeyproject is null";
				where += ")";
				filters << where;
			}
		}
		if( mJobFilter.elementList.size() > 0 )
			filters << " fkeyelement IN (" + mJobFilter.elementList.keyString() + ")";

		if( !mJobFilter.mExtraFilters.isEmpty() )
			filters << mJobFilter.mExtraFilters;

		QString where = filters.isEmpty() ? "TRUE" : filters.join( " AND " );
		where += " ORDER BY keyJob DESC LIMIT " + QString::number(mJobFilter.mLimit);

		bool supportsMultiSelect = Database::current()->connection()->capabilities() & Connection::Cap_MultiTableSelect;
		TableList tables;

		CHECK_CANCEL
		foreach( QString type, mJobFilter.typeToShow ) {
			JobType jt( type.toUInt() );
			if( !jt.isRecord() ) {
				LOG_5( "JobType filter was not a valid record: " + type );
				continue;
			}
			Table * tbl = Database::current()->tableByName( "job" + jt.name() );
			if( !tbl ) {
				LOG_5( "Couldn't find table for jobtype: " + jt.name() );
				continue;
			}
			if( supportsMultiSelect )
				tables += tbl;
			else
				mReturn += tbl->selectOnly( where );
			CHECK_CANCEL
		}
		if( supportsMultiSelect )
			mReturn = Database::current()->tableByName( "job" )->selectMulti( tables, where, VarList(), "WHERE TRUE ORDER BY keyJob DESC LIMIT " + QString::number(mJobFilter.mLimit) );
		CHECK_CANCEL
	}

	JobList jobsNeedingRefresh;
	if( mFetchJobDeps ) {
		JobList jobsNeedingDeps = mReturn.unique();
		Index * idx = JobDep::table()->indexFromField( "fkeyJob" );
		while( !jobsNeedingDeps.isEmpty() ) {
			idx->cacheIncoming(true);
			JobDepList jobDeps = JobDep::select( "fkeyJob IN (" + jobsNeedingDeps.keyString() + ")" );
			idx->cacheIncoming(false);
			QMap<uint,JobDepList> depsByJob = jobDeps.groupedBy<uint,JobDepList>("fkeyJob");
			foreach( Job j, jobsNeedingDeps )
				if( !depsByJob.contains(j.key()) )
					idx->setEmptyEntry( QList<QVariant>() << j.getValue( "keyjob" ) );
			CHECK_CANCEL
			JobList dependentJobs = jobDeps.deps();
			jobsNeedingDeps = dependentJobs - mReturn - mDependentJobs;
			mJobDeps += jobDeps;
			mDependentJobs += dependentJobs;
		}
		jobsNeedingRefresh = (mDependentJobs - mReturn);
		if( jobsNeedingRefresh.size() )
			Job::select("keyjob in (" + jobsNeedingRefresh.keyString() + ")");
		CHECK_CANCEL
	}

	JobList allJobs = mReturn + jobsNeedingRefresh;
	if( allJobs.size() ) {
		JobStatus::select( "fkeyjob in (" + allJobs.keyString() + ")" );
		CHECK_CANCEL

		if( mFetchJobServices )
			mJobServices = JobService::select( "fkeyjob in (" + allJobs.keyString() + ")" );
	}
}

HostListTask::HostListTask( QObject * rec, const QString & serviceFilter, bool loadHostServices )
: ThreadTask( HOST_LIST, rec )
, mServiceFilter( serviceFilter )
, mLoadHostServices( loadHostServices )
{
}

void HostListTask::run()
{
	if( !mServiceFilter.isEmpty() ) {
		QTime t;
		t.start();
		mReturn = Host::select(
			"WHERE keyhost IN ( SELECT hostservice.fkeyhost FROM HostService WHERE fkeyservice IN (" + mServiceFilter + ") ) AND online=1" );
		LOG_5( "Selecting hosts took " + QString::number( t.elapsed() ) + " ms " );
		CHECK_CANCEL
		t.start();
		mHostStatuses = HostStatus::select( "fkeyhost in (" + mReturn.keyString() + ")" );
		LOG_5( "Selecting host statuses took " + QString::number( t.elapsed() ) + " ms " );
		CHECK_CANCEL
		t.start();
		mHostAssignments = JobAssignment::select( "WHERE fkeyhost IN (" + mReturn.keyString() +") AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus FROM jobassignmentstatus WHERE status IN ('ready','copy','busy'))" );
		LOG_5( "Selecting job assignments took " + QString::number( t.elapsed() ) + " ms " );
		CHECK_CANCEL
		t.start();
		mHostJobs = mHostAssignments.jobs();
		LOG_5( "Selecting jobs took " + QString::number( t.elapsed() ) + " ms " );
	}
	CHECK_CANCEL
	if( mLoadHostServices )
		HostService::select();
}

FrameListTask::FrameListTask( QObject * rec, const Job & job )
: ThreadTask( FRAME_LIST, rec )
, mJob( job )
{}

void FrameListTask::run()
{
	mReturn = JobTask::recordsByJob( mJob );
	QStringList taskAssignmentKeys;
	foreach( JobTask task, mReturn ) {
		int jtak = task.getValue("fkeyjobtaskassignment").toInt();
		if( jtak != 0 )
			taskAssignmentKeys += QString::number(jtak);
	}
	if( taskAssignmentKeys.size() )
		mTaskAssignments = JobTaskAssignment::select( "keyjobtaskassignment IN (" + taskAssignmentKeys.join(",") + ")" );
	CHECK_CANCEL
	QSqlQuery q = Database::current()->exec( "SELECT now();" );
	if( q.next() )
		mCurTime = q.value( 0 ).toDateTime();
}

PartialFrameListTask::PartialFrameListTask( QObject * rec, const JobTaskList & jtl )
: ThreadTask( PARTIAL_FRAME_LIST, rec )
, mJtl( jtl )
{}

void PartialFrameListTask::run()
{
	if( mJtl.size() == 0 )
		return;
	QString sel = "keyjobtask IN (" + mJtl.keyString() + ")";
	mReturn = JobTask::select( sel );
	CHECK_CANCEL
	QSqlQuery q = Database::current()->exec( "SELECT now();" );
	if( q.next() )
		mCurTime = q.value( 0 ).toDateTime();
}

ErrorListTask::ErrorListTask( QObject * rec, const Job & job )
: ThreadTask( ERROR_LIST, rec )
, mJob( job )
{}
	
void ErrorListTask::run()
{
//	mReturn = JobHistory::recordsByJob( mJob );
	mReturn = JobError::select( "fkeyJob=? AND cleared=false", VarList() << mJob.key() );
	LOG_5( "Error select finished" );
}

HostErrorListTask::HostErrorListTask( QObject * rec, const Host & host, int limit )
: ThreadTask( HOST_ERROR_LIST, rec )
, mHost( host )
, mLimit( limit )
{}

void HostErrorListTask::run()
{
	mReturn = JobError::select( "fkeyhost=? ORDER BY keyjoberror desc LIMIT ?", VarList() << mHost.key() << mLimit );
	mJobs = mReturn.jobs();
	mJobServices = mJobs.jobServices();
}

CounterTask::CounterTask( QObject * rec )
: ThreadTask( COUNTER, rec )
{}

void CounterTask::run()
{
	QSqlQuery query = Database::current()->exec("SELECT hostsTotal, hostsActive, hostsReady, jobsTotal, jobsActive, jobsDone FROM getcounterstate();");
	if( query.next() ) {
		mReturn.hostsTotal = query.value(0).toInt();
		mReturn.hostsActive = query.value(1).toInt();
		mReturn.hostsReady = query.value(2).toInt();
		mReturn.jobsTotal = query.value(3).toInt();
		mReturn.jobsActive = query.value(4).toInt();
		mReturn.jobsDone = query.value(5).toInt();
	}
	CHECK_CANCEL
	mManagerService = Service::recordByName( "AB_manager" );
	LOG_5( "Returning CounterTask results" );
}


JobHistoryListTask::JobHistoryListTask( QObject * rec, JobList jobs )
: ThreadTask( JOB_HISTORY_LIST, rec )
, mJobs( jobs )
{
}

void JobHistoryListTask::run()
{
	mReturn = mJobs.jobHistories();
}

UpdateJobListTask::UpdateJobListTask( QObject * rec, const JobList & jobs, const QString & status )
: ThreadTask( UPDATE_JOB_LIST, rec )
, mReturn( jobs )
, mStatus( status )
{
}

void UpdateJobListTask::run()
{
    Job::updateJobStatuses( mReturn, mStatus, false );
    //mReturn.setStatuses(mStatus);
    //mReturn.commit();
}

UpdateHostListTask::UpdateHostListTask( QObject * rec, const HostList & hosts, const QString & status )
: ThreadTask( UPDATE_JOB_LIST, rec )
, mReturn( hosts )
, mStatus( status )
{
}

void UpdateHostListTask::run()
{
    Database::current()->beginTransaction();

    HostStatusList hsl = mReturn.hostStatuses();
    hsl.setSlaveStatuses(mStatus);
    hsl.commit();

    QStringList returnTasksSql;
    foreach( Host h, mReturn )
        returnTasksSql += "return_slave_tasks_3(" + QString::number( h.key() ) + ")";
    Database::current()->exec("SELECT " + returnTasksSql.join(",") + ";");

    Database::current()->commitTransaction();
}

