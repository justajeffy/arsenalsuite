
%MappedType MappedJob
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joblist.h"
#include "jobtable.h"
#define MappedJob Job
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Job(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobSchema::instance() );
%End
};

class Job : Record
{
%TypeHeaderCode
#include <job.h>
#include "element.h"
#include "host.h"
#include "jobtype.h"
#include "project.h"
#include "user.h"
#include "jobstat.h"
#include "job.h"
#include "joberror.h"
#include "jobhistory.h"
#include "joboutput.h"
#include "jobservice.h"
#include "jobstatus.h"
#include "jobtask.h"

%End
public:
	Job();

	Job( uint key );

	Job( const Job & other );

	Job( const Record & r );

	Job( RecordImp * imp, bool checkType = true );
	
	MappedJob copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedJob & setElement( const Element & );
	MappedHost host() const;
	MappedJob & setHost( const Host & );
	MappedJobType jobType() const;
	MappedJob & setJobType( const JobType & );
	MappedProject project() const;
	MappedJob & setProject( const Project & );
	MappedUser user() const;
	MappedJob & setUser( const User & );
	QString hostList() const;
	MappedJob & setHostList( const QString & );
	QString name() const;
	MappedJob & setName( const QString & );
	QString jobTime() const;
	MappedJob & setJobTime( const QString & );
	QString outputPath() const;
	MappedJob & setOutputPath( const QString & );
	QString status() const;
	MappedJob & setStatus( const QString & );
	uint submitted() const;
	MappedJob & setSubmitted( const uint & );
	uint started() const;
	MappedJob & setStarted( const uint & );
	uint ended() const;
	MappedJob & setEnded( const uint & );
	uint deleteOnComplete() const;
	MappedJob & setDeleteOnComplete( const uint & );
	uint priority() const;
	MappedJob & setPriority( const uint & );
	QString packetType() const;
	MappedJob & setPacketType( const QString & );
	uint packetSize() const;
	MappedJob & setPacketSize( const uint & );
	/**
	  * @brief  Represents all the users to notify regarding job errors, and how to notify them
	  * Format of the string is (USERNAME:[je]+),...
	  * USERNAME must be a valid name stored in the usr table.
	  * j - Sends notifications as jabbers
	  * e - Sends notifications as emails
	  * 
	  * Examples
	  * 'newellm:j,abe:e,diego:je'  Sends jabber to newellm, email to abe, and both to diego.
	  **/
	QString notifyOnError() const;
	MappedJob & setNotifyOnError( const QString & );
	/**
	  * @brief Represents all the users to notify regarding successful job completion, and how to notify them.
	  * See notifyOnError documentation for formatting details.
	  **/
	QString notifyOnComplete() const;
	MappedJob & setNotifyOnComplete( const QString & );
	uint maxTaskTime() const;
	MappedJob & setMaxTaskTime( const uint & );
	uint cleaned() const;
	MappedJob & setCleaned( const uint & );
	uint fileSize() const;
	MappedJob & setFileSize( const uint & );
	QString btInfoHash() const;
	MappedJob & setBtInfoHash( const QString & );
	QString fileName() const;
	MappedJob & setFileName( const QString & );
	QString fileMd5sum() const;
	MappedJob & setFileMd5sum( const QString & );
	MappedJobStat jobStat() const;
	MappedJob & setJobStat( const JobStat & );
	QString userName() const;
	MappedJob & setUserName( const QString & );
	QString domain() const;
	MappedJob & setDomain( const QString & );
	QString password() const;
	MappedJob & setPassword( const QString & );
	QString stats() const;
	MappedJob & setStats( const QString & );
	float currentMapServerWeight() const;
	MappedJob & setCurrentMapServerWeight( const float & );
	bool prioritizeOuterTasks() const;
	MappedJob & setPrioritizeOuterTasks( const bool & );
	bool outerTasksAssigned() const;
	MappedJob & setOuterTasksAssigned( const bool & );
	/**
	  * Maximum amount of time to load the job before a task is started.  If a task hasn't started by the time this expires, the job will report an error and the host will be reset.
	  **/
	int maxLoadTime() const;
	MappedJob & setMaxLoadTime( const int & );
	/**
	  * Maximum amount of memory a job is allowed to use (in bytes). If it exceeds this the task will raise an error.
	  **/
	uint maxMemory() const;
	MappedJob & setMaxMemory( const uint & );
	MappedJob jobParent() const;
	MappedJob & setJobParent( const Job & );
	QDateTime submittedts() const;
	MappedJob & setSubmittedts( const QDateTime & );
	QDateTime startedts() const;
	MappedJob & setStartedts( const QDateTime & );
	QDateTime endedts() const;
	MappedJob & setEndedts( const QDateTime & );
	int maxHosts() const;
	MappedJob & setMaxHosts( const int & );
	uint personalPriority() const;
	MappedJob & setPersonalPriority( const uint & );
	bool loggingEnabled() const;
	MappedJob & setLoggingEnabled( const bool & );
	QString environment() const;
	MappedJob & setEnvironment( const QString & );
	bool uploadedFile() const;
	MappedJob & setUploadedFile( const bool & );
	bool checkFileMd5() const;
	MappedJob & setCheckFileMd5( const bool & );
	bool runasSubmitter() const;
	MappedJob & setRunasSubmitter( const bool & );
	int frameNth() const;
	MappedJob & setFrameNth( const int & );
	/**
	  * 0 - No Copy
	  * 1 - Copy to missing in-between frames
	  * 2 - Copy to all in-between frames
	  * 3 - Frame Fill Mode, renders in-between frames only
	  **/
	int frameNthMode() const;
	MappedJob & setFrameNthMode( const int & );
	bool exclusiveAssignment() const;
	MappedJob & setExclusiveAssignment( const bool & );
	bool hasTaskProgress() const;
	MappedJob & setHasTaskProgress( const bool & );
	/**
	  * In kilobytes.
	  **/
	uint minMemory() const;
	MappedJob & setMinMemory( const uint & );
	QString shotName() const;
	MappedJob & setShotName( const QString & );
	QString sceneName() const;
	MappedJob & setSceneName( const QString & );
	uint assignmentSlots() const;
	MappedJob & setAssignmentSlots( const uint & );
	MappedJobErrorList jobErrors() const;
	MappedJobHistoryList jobHistories() const;
	MappedJobOutputList jobOutputs() const;
	MappedJobServiceList jobServices() const;
	MappedJobStatus jobStatus() const;
	MappedJobTaskList jobTasks() const;


	static MappedJobList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJob reload( bool lockForUpdate = false );

	static MappedJob recordByElement( const Element &fkeyElement );





	static bool updateJobStatuses( JobList jobs, const QString & jobStatus, bool resetTasks );

	void changeFrameRange( QList<int>, JobOutput output = JobOutput(), bool changeCancelledToNew = true );

	void changePreassignedTaskList( HostList hosts, bool changeCancelledToNew = true );

	void addHistory( const QString & message );


	static Table * table();
	//static JobSchema * schema();
};


