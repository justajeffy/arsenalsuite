
/* $Author$
 * $LastChangedDate: 2010-01-28 11:47:32 +1100 (Thu, 28 Jan 2010) $
 * $Rev: 9262 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/threadtasks.cpp $
 */

#include <qsqlquery.h>
#include <qsqlerror.h>

#include "database.h"


#include "employee.h"
#include "group.h"
#include "hostservice.h"
#include "permission.h"
#include "usergroup.h"
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
        // Cache information needed for permission checks
        // Permission checks will happen when building menus
        Employee::select();
        Group::select();
        Permission::select();
        UserGroup::recordsByUser( User::currentUser() );
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
, mFetchUserServices( true )
, mFetchProjectSlots( true )
{}

void JobListTask::run()
{
	User::select(); // Make sure usr is loaded
	CHECK_CANCEL

    bool projectFilterShowingNone = (!mJobFilter.allProjectsShown && mJobFilter.visibleProjects.isEmpty() && !mJobFilter.showNonProjectJobs);

	if( mJobList.size() ) {
		mReturn = mJobList.reloaded();
	} else

	// If we have a project list, and all projects are hidden, then there will be no items, so just clear the list
    if( !(projectFilterShowingNone || mJobFilter.typesToShow.isEmpty() || mJobFilter.statusToShow.isEmpty()) )
	{
		QStringList filters;
		
		//LOG_5( "Statuses to show: "	+ mJobFilter.statusToShow.join(",") );
		//LOG_5( "Hidden Projects: " + mJobFilter.hiddenProjects.join(",") );
		//LOG_5( "Non-Project Jobs: " + QString(mJobFilter.showNonProjectJobs ? "true" : "false") );
		//LOG_5( "User List: " + mJobFilter.userList.join(",") );

		if( mJobFilter.statusToShow.size() > 0 && mJobFilter.statusToShow.size() != 8 )
			filters << "status IN ('" + mJobFilter.statusToShow.join("','") + "')";

		if( mJobFilter.userList.size() > 0 )
			filters << " (fkeyUsr IN (" + mJobFilter.userList.join(",") + ") or fkeywrangler IN(" + mJobFilter.userList.join(",") + ") )";

        if( !mJobFilter.allProjectsShown || !mJobFilter.showNonProjectJobs ) {
            QString where = "(";
            if( mJobFilter.visibleProjects.size() )
                where += " fkeyproject IN (" + mJobFilter.visibleProjects.keyString() + ")";
            if( mJobFilter.showNonProjectJobs ) {
                if( mJobFilter.visibleProjects.size() )
                    where += " OR";
                where += " fkeyproject is null";
            }
            where += ")";
            if( where != "()" )
                filters << where;
        }

		if( mJobFilter.elementList.size() > 0 )
			filters << " fkeyelement IN (" + mJobFilter.elementList.keyString() + ")";

		if( !mJobFilter.mExtraFilters.isEmpty() )
			filters << mJobFilter.mExtraFilters;

		QString where = filters.isEmpty() ? "TRUE" : filters.join( " AND " );
        QString limitWhere;
        if( mJobFilter.mDaysLimit > 0 )
            limitWhere += QString(" AND submittedts > now()-'%1 days'::interval").arg(QString::number(mJobFilter.mDaysLimit));
        if( mJobFilter.mLimit > 0 )
            limitWhere += " ORDER BY keyJob DESC LIMIT " + QString::number(mJobFilter.mLimit);

		bool supportsMultiSelect = Database::current()->connection()->capabilities() & Connection::Cap_MultiTableSelect;
		TableList tables;

		CHECK_CANCEL
		foreach( JobType jt, mJobFilter.typesToShow ) {
			if( !jt.isRecord() ) {
				LOG_5( "JobType filter was not a valid record: " + jt.name() );
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
				mReturn += tbl->selectOnly( where+limitWhere );
			CHECK_CANCEL
		}
		if( supportsMultiSelect )
			mReturn = Database::current()->tableByName( "job" )->selectMulti( tables, where, VarList(), "WHERE TRUE"+limitWhere);
		CHECK_CANCEL
	}

	JobList jobsNeedingRefresh;
    if( mFetchJobDeps && mReturn.size() ) {
        JobList jobsNeedingDeps = mReturn;
		Index * idx = JobDep::table()->indexFromField( "fkeyJob" );
        idx->cacheIncoming(true);
        mJobDeps = JobDep::table()->selectFrom( "jobdep_recursive('" + jobsNeedingDeps.keyString() + "') AS JobDep" );
        idx->cacheIncoming(false);
        QMap<uint,JobDepList> depsByJob = mJobDeps.groupedBy<uint,JobDepList>("fkeyJob");
        foreach( Job j, jobsNeedingDeps )
            if( !depsByJob.contains(j.key()) )
                idx->setEmptyEntry( QList<QVariant>() << j.getValue( "keyjob" ) );
        mDependentJobs = mJobDeps.deps();
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

		CHECK_CANCEL
        if( mFetchUserServices ) {
            QSqlQuery q = Database::current()->exec( "SELECT * FROM user_service_current" );
            while( q.next() ) {
                QString key = q.value( 0 ).toString();
                int value = q.value( 1 ).toInt();
                mUserServiceCurrent[key] = value;
            }
            QSqlQuery q2 = Database::current()->exec( "SELECT * FROM user_service_limits" );
            while( q2.next() ) {
                QString key = q2.value( 0 ).toString();
                int value = q2.value( 1 ).toInt();
                mUserServiceLimits[key] = value;
            }
        }

		CHECK_CANCEL
        if( mFetchProjectSlots ) {
            QSqlQuery q = Database::current()->exec( "SELECT * FROM project_slots_current" );
            while( q.next() ) {
                QString key = q.value( 0 ).toString();
                int projectSlots = q.value( 1 ).toInt();
                int reserve = q.value( 2 ).toInt();
                int limit = q.value( 3 ).toInt();
                mProjectSlots[key] = QString("%1:%2:%3").arg(projectSlots).arg(reserve).arg(limit);
            }
        }
    }
	//jobsNeedingRefresh.clear();
	//allJobs.clear();
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
		mReturn = Host::select(
			"WHERE keyhost IN ( SELECT hostservice.fkeyhost FROM HostService WHERE fkeyservice IN (" + mServiceFilter + ") ) AND online=1" );
        if( mReturn.size() ) {
            CHECK_CANCEL
            mHostStatuses = HostStatus::select( "fkeyhost in (" + mReturn.keyString() + ")" );
            //CHECK_CANCEL
            //mHostAssignments = JobAssignment::select( "WHERE fkeyhost IN (" + mReturn.keyString() +") AND fkeyjobassignmentstatus IN (SELECT keyjobassignmentstatus FROM jobassignmentstatus WHERE status IN ('ready','copy','busy'))" );
            CHECK_CANCEL
            mHostJobs = mHostAssignments.jobs();
        }
	}
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

ErrorListTask::ErrorListTask( QObject * rec, const Job & job, bool showCleared )
: ThreadTask( ERROR_LIST, rec )
, mJob( job )
, mShowCleared( showCleared )
{}
	
void ErrorListTask::run()
{
//	mReturn = JobHistory::recordsByJob( mJob );
    QString sql = "fkeyjob=?";
    if(!mShowCleared)
        sql += " AND cleared=false";
	mReturn = JobError::select( sql, VarList() << mJob.key() );
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

