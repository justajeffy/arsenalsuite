
#include "database.h"

#include "host.h"
#include "jobhistory.h"
#include "jobhistorytype.h"
#include "jobtask.h"
#include "jobtable.h"
#include "user.h"
#include "group.h"
#include "usergroup.h"

bool Job::updateJobStatuses( JobList jobs, const QString & jobStatus, bool resetTasks )
{
	if( jobs.isEmpty() )
		return false;

	Database::current()->beginTransaction();

    if( resetTasks ) {
        /*** Let triggers handle this now!
        foreach( Job j, jobs ) {
            JobTaskList jtl = j.jobTasks().filter("status", "cancelled",  keepMatches false);
            jtl.setStatuses("new");
            jtl.setColumnLiteral("fkeyjoboutput","NULL");
            if( j.packetType() != "preassigned" )
                jtl.setHosts(Host());
            jtl.commit();
        }
        ***/
    }

	if( !jobStatus.isEmpty() ){
		foreach( Job j, jobs )
			if( j.status() != jobStatus )
				j.addHistory( "Status change from" + j.status() + " to " + jobStatus );

		// Update each of the Job records
        jobs.setStatuses(jobStatus);
        jobs.commit();
	}

	Database::current()->commitTransaction();
	return true;
}

void Job::changeFrameRange( QList<int> frames, JobOutput output, bool changeCancelledToNew )
{
	// Gather existing tasks for this output
	QString sql( "fkeyjob=?" );
	VarList args;
	args << key();
	if( output.isRecord() ) {
		sql += " AND fkeyjoboutput=?";
		args << output.key();
	}

	JobTaskList tasks = JobTask::select( sql, args );

	// Create tasks that are missing
	JobTaskList allTasks;
	QMap<int,JobTaskList> tasksByFrame = tasks.groupedBy<int,JobTaskList>( "frameNumber" );
	foreach( int frame, frames ) {
		if( tasksByFrame.contains( frame ) ) {
			foreach( JobTask task, tasksByFrame[frame] ) {
				if( changeCancelledToNew && task.status() == "cancelled" )
					task.setStatus( "new" );
				allTasks += task;
			}
		} else {
			JobTask jt;
			jt.setStatus( "new" );
			jt.setJob( *this );
			jt.setFrameNumber( frame );
			jt.setJobOutput( output );
			allTasks += jt;
		}
	}
	
	// Gather tasks that need to be canceled
	JobTaskList canceled;
	for( QMap<int,JobTaskList>::iterator it = tasksByFrame.begin(); it != tasksByFrame.end(); ++it ) {
		foreach( JobTask jt, it.value() )
			if( !allTasks.contains( jt ) )
				canceled += jt;
	}
	canceled.setHosts( Host() );
	canceled.setStatuses( "cancelled" );
	
	// Commit changes
	Database::current()->beginTransaction();
	allTasks.commit();
	canceled.commit();
	Database::current()->exec( "SELECT update_job_task_counts(?);", VarList() << key() );
	Database::current()->commitTransaction();

	addHistory( "Job Frame List Changed" );
}

void Job::changePreassignedTaskList( HostList hosts, bool changeCancelledToNew )
{
	JobTaskList tasks = jobTasks(), toCancel, toCommit;
	HostList current = tasks.hosts();
	HostList hostsToAdd = hosts - current, hostsToCancel = current - hosts;
	HostList hostsToUncancel = current - hostsToCancel;

	int maxTaskNumber = 0;
	foreach( JobTask task, tasks ) {
		maxTaskNumber = qMax(task.frameNumber(),maxTaskNumber);
		if( hostsToCancel.contains( task.host() ) )
			toCancel += task;
		if( changeCancelledToNew && hostsToUncancel.contains( task.host() ) && task.status() == "cancelled" ) {
			task.setStatus( "new" );
			toCommit += task;
		}
	}

	toCancel.setStatuses( "cancelled" );

	foreach( Host host, hostsToAdd ) {
		JobTask jt;
		jt.setJob(*this);
		jt.setStatus( "new" );
		jt.setHost( host );
		jt.setFrameNumber( ++maxTaskNumber );
		toCommit += jt;
	}

	Database::current()->beginTransaction();
	toCommit.commit();
	toCancel.commit();
	Database::current()->exec( "SELECT update_job_task_counts(?);", VarList() << key() );
	Database::current()->commitTransaction();

	addHistory( "Job Frame List Changed" );
}


void Job::addHistory( const QString & message )
{
    if( message.isEmpty() )
        return;
	JobHistory jh;
	jh.setJob( *this );
	jh.setMessage( message );
	jh.setUser( User::currentUser() );
	jh.setHost( Host::currentHost() );
	jh.setColumnLiteral( "created", "NOW()" );
	jh.commit();
}

void JobSchema::preUpdate( const Record & updated, const Record & old )
{
    Job newJob(updated);
    Job oldJob(old);
    // if the priority is being lowered, check to make sure they're allowed to do so
    if( newJob.priority() < oldJob.priority() ) {
        if( !User::currentUser().userGroups().groups().contains( Group::recordByName("RenderOps") ) ) {
            newJob.setPriority(oldJob.priority());
        }
    }
    TableSchema::preUpdate(updated,old);
}

void JobSchema::postUpdate( const Record & updated, const Record & old )
{
    Job(updated).addHistory(updated.changeString());
}

