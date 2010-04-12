


%MappedType MappedJobList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joblist.h"
#include "jobtable.h"
#define MappedJobList JobList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobSchema::instance() );
%End
};

class JobList : RecordList
{
%TypeHeaderCode
#include <joblist.h>
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
	JobList();
	JobList( const RecordList &, Table * t = 0 );
	JobList( const JobList & );
	JobList( const Record &, Table * t = 0 );
	
	~JobList();

//	void insert( JobIter, const Job & );

//	JobIter at( uint );

//	JobIter find( const Record & );

//	JobIter remove( const JobIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobIter begin();

	//JobIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobList sorted( const QString & c, bool a = true ) const;

	MappedJobList unique() const;
	MappedJobList reversed() const;
	MappedJobList reloaded() const;

	MappedElementList elements() const;
	MappedJobList & setElements( const Element & );
	MappedHostList hosts() const;
	MappedJobList & setHosts( const Host & );
	MappedJobTypeList jobTypes() const;
	MappedJobList & setJobTypes( const JobType & );
	MappedProjectList projects() const;
	MappedJobList & setProjects( const Project & );
	MappedUserList users() const;
	MappedJobList & setUsers( const User & );
	QStringList hostLists() const;
	MappedJobList & setHostLists( const QString & );
	QStringList names() const;
	MappedJobList & setNames( const QString & );
	QStringList jobTimes() const;
	MappedJobList & setJobTimes( const QString & );
	QStringList outputPaths() const;
	MappedJobList & setOutputPaths( const QString & );
	QStringList statuses() const;
	MappedJobList & setStatuses( const QString & );
	QList<uint> submitted() const;
	MappedJobList & setSubmitted( const uint & );
	QList<uint> started() const;
	MappedJobList & setStarted( const uint & );
	QList<uint> ended() const;
	MappedJobList & setEnded( const uint & );
	QList<uint> deleteOnCompletes() const;
	MappedJobList & setDeleteOnCompletes( const uint & );
	QList<uint> priorities() const;
	MappedJobList & setPriorities( const uint & );
	QStringList packetTypes() const;
	MappedJobList & setPacketTypes( const QString & );
	QList<uint> packetSizes() const;
	MappedJobList & setPacketSizes( const uint & );
	QStringList notifyOnErrors() const;
	MappedJobList & setNotifyOnErrors( const QString & );
	QStringList notifyOnCompletes() const;
	MappedJobList & setNotifyOnCompletes( const QString & );
	QList<uint> maxTaskTimes() const;
	MappedJobList & setMaxTaskTimes( const uint & );
	QList<uint> cleaned() const;
	MappedJobList & setCleaned( const uint & );
	QList<uint> fileSizes() const;
	MappedJobList & setFileSizes( const uint & );
	QStringList btInfoHashs() const;
	MappedJobList & setBtInfoHashs( const QString & );
	QStringList fileNames() const;
	MappedJobList & setFileNames( const QString & );
	QStringList fileMd5sums() const;
	MappedJobList & setFileMd5sums( const QString & );
	MappedJobStatList jobStats() const;
	MappedJobList & setJobStats( const JobStat & );
	QStringList userNames() const;
	MappedJobList & setUserNames( const QString & );
	QStringList domains() const;
	MappedJobList & setDomains( const QString & );
	QStringList passwords() const;
	MappedJobList & setPasswords( const QString & );
	QStringList statses() const;
	MappedJobList & setStatses( const QString & );
	QList<float> currentMapServerWeights() const;
	MappedJobList & setCurrentMapServerWeights( const float & );
	QList<bool> prioritizeOuterTaskses() const;
	MappedJobList & setPrioritizeOuterTaskses( const bool & );
	QList<bool> outerTasksAssigned() const;
	MappedJobList & setOuterTasksAssigned( const bool & );
	QList<int> maxLoadTimes() const;
	MappedJobList & setMaxLoadTimes( const int & );
	QList<uint> maxMemories() const;
	MappedJobList & setMaxMemories( const uint & );
	MappedJobList jobParents() const;
	MappedJobList & setJobParents( const Job & );
	QList<QDateTime> submittedtses() const;
	MappedJobList & setSubmittedtses( const QDateTime & );
	QList<QDateTime> startedtses() const;
	MappedJobList & setStartedtses( const QDateTime & );
	QList<QDateTime> endedtses() const;
	MappedJobList & setEndedtses( const QDateTime & );
	QList<int> maxHosts() const;
	MappedJobList & setMaxHosts( const int & );
	QList<uint> personalPriorities() const;
	MappedJobList & setPersonalPriorities( const uint & );
	QList<bool> loggingEnabled() const;
	MappedJobList & setLoggingEnabled( const bool & );
	QStringList environments() const;
	MappedJobList & setEnvironments( const QString & );
	QList<bool> uploadedFiles() const;
	MappedJobList & setUploadedFiles( const bool & );
	QList<bool> checkFileMd5s() const;
	MappedJobList & setCheckFileMd5s( const bool & );
	QList<bool> runasSubmitter() const;
	MappedJobList & setRunasSubmitter( const bool & );
	QList<int> frameNths() const;
	MappedJobList & setFrameNths( const int & );
	QList<int> frameNthModes() const;
	MappedJobList & setFrameNthModes( const int & );
	QList<bool> exclusiveAssignments() const;
	MappedJobList & setExclusiveAssignments( const bool & );
	QList<bool> hasTaskProgresses() const;
	MappedJobList & setHasTaskProgresses( const bool & );
	QList<uint> minMemories() const;
	MappedJobList & setMinMemories( const uint & );
	QStringList shotNames() const;
	MappedJobList & setShotNames( const QString & );
	QStringList sceneNames() const;
	MappedJobList & setSceneNames( const QString & );
	QList<uint> assignmentSlotses() const;
	MappedJobList & setAssignmentSlotses( const uint & );
	MappedJobErrorList jobErrors();
	MappedJobHistoryList jobHistories();
	MappedJobOutputList jobOutputs();
	MappedJobServiceList jobServices();
	MappedJobStatusList jobStatuses();
	MappedJobTaskList jobTasks();


};


