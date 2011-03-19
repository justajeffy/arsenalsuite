
/* $Author$
 * $LastChangedDate: 2009-11-27 13:20:11 +1100 (Fri, 27 Nov 2009) $
 * $Rev: 9100 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/include/threadtasks.h $
 */

#include <qevent.h>

#include "freezercore.h"

#include "host.h"
#include "hoststatus.h"
#include "job.h"
#include "jobassignment.h"
#include "joberror.h"
#include "jobhistory.h"
#include "jobtask.h"
#include "jobtaskassignment.h"
#include "jobtype.h"
#include "jobdep.h"
#include "jobservice.h"
#include "project.h"
#include "service.h"

#include "afcommon.h"

enum {
	JOB_LIST = QEvent::User+1,
	HOST_LIST,
	FRAME_LIST,
	PARTIAL_FRAME_LIST,
	ERROR_LIST,
	COUNTER,
	STATIC_JOB_LIST_DATA,
	STATIC_HOST_LIST_DATA,
	HOST_ERROR_LIST,
	JOB_HISTORY_LIST,
    UPDATE_JOB_LIST,
    UPDATE_HOST_LIST
};

class JobListTask : public ThreadTask
{
public:
	JobListTask( QObject * rec, const JobFilter & jf, const JobList & jobList, ProjectList, bool fetchJobServices = false, bool needDeps = false );
	void run();

	JobList mReturn;
	JobDepList mJobDeps;
	JobFilter mJobFilter;
	JobList mJobList, mJobsNeedingDeps, mDependentJobs;
	ProjectList mProjects;
	bool mFetchJobServices, mFetchJobDeps, mFetchUserServices, mFetchProjectSlots;
	JobServiceList mJobServices;
    QMap<QString, int> mUserServiceCurrent;
    QMap<QString, int> mUserServiceLimits;
    QMap<QString, QString> mProjectSlots;
};

class UpdateJobListTask : public ThreadTask
{
public:
	UpdateJobListTask( QObject * rec, const JobList & jobList, const QString & status );
	void run();

	JobList mReturn;
    QString mStatus;
};

class HostListTask : public ThreadTask
{
public:
	HostListTask( QObject * rec, const QString & serviceFilter, bool loadHostServices );
	
	void run();
	
	QString mServiceFilter;
	HostList mReturn;
	HostStatusList mHostStatuses;
	JobAssignmentList mHostAssignments;
	JobList mHostJobs;
	bool mLoadHostServices;
};

class UpdateHostListTask : public ThreadTask
{
public:
	UpdateHostListTask( QObject * rec, const HostList & jobList, const QString & status );
	void run();

	HostList mReturn;
    QString mStatus;
};

class FrameListTask : public ThreadTask
{
public:
	FrameListTask( QObject * rec, const Job & );
	void run();
	Job mJob;
	JobTaskList mReturn;
	JobTaskAssignmentList mTaskAssignments;
	QDateTime mCurTime;
};

class PartialFrameListTask : public ThreadTask
{
public:
	PartialFrameListTask( QObject * rec, const JobTaskList & );
	void run();
	JobTaskList mJtl;
	JobTaskList mReturn;
	QDateTime mCurTime;
};

class ErrorListTask : public ThreadTask
{
public:
	ErrorListTask( QObject * rec, const Job & );
	void run();
	Job mJob;
	JobErrorList mReturn;
};

class HostErrorListTask : public ThreadTask
{
public:
	HostErrorListTask( QObject * rec, const Host &, int limit );
	void run();
	Host mHost;
	int mLimit;
	JobErrorList mReturn;
	JobList mJobs;
	JobServiceList mJobServices;
};

class StaticJobListDataTask : public ThreadTask
{
public:
	StaticJobListDataTask( QObject * rec );
	void run();
	JobTypeList mJobTypes;
	ProjectList mProjects;
	bool mHasData;
};

class StaticHostListDataTask : public ThreadTask
{
public:
	StaticHostListDataTask( QObject * rec );
	void run();
	ServiceList mServices;
};

class Sleeper : public QThread
{
public:
    static void sleep(unsigned long secs) {
        QThread::sleep(secs);
    }
    static void msleep(unsigned long msecs) {
        QThread::msleep(msecs);
    }
    static void usleep(unsigned long usecs) {
        QThread::usleep(usecs);
    }
}; 

class FREEZER_EXPORT CounterTask : public ThreadTask
{
public:
	CounterTask( QObject * rec );
	
	void run();
	CounterState mReturn;
	Service mManagerService;
};

class JobHistoryListTask : public ThreadTask
{
public:
	JobHistoryListTask( QObject * rec, JobList jobs );
	void run();
	JobList mJobs;
	JobHistoryList mReturn;
};

