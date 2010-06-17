


%MappedType MappedJobStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobstatuslist.h"
#include "jobstatustable.h"
#define MappedJobStatusList JobStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobStatusSchema::instance() );
%End
};

class JobStatusList : RecordList
{
%TypeHeaderCode
#include <jobstatuslist.h>
#include "job.h"

%End
public:
	JobStatusList();
	JobStatusList( const RecordList &, Table * t = 0 );
	JobStatusList( const JobStatusList & );
	JobStatusList( const Record &, Table * t = 0 );
	
	~JobStatusList();

//	void insert( JobStatusIter, const JobStatus & );

//	JobStatusIter at( uint );

//	JobStatusIter find( const Record & );

//	JobStatusIter remove( const JobStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobStatusIter begin();

	//JobStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobStatusList sorted( const QString & c, bool a = true ) const;

	MappedJobStatusList unique() const;
	MappedJobStatusList reversed() const;
	MappedJobStatusList reloaded() const;

	QList<uint> hostsOnJobs() const;
	MappedJobStatusList & setHostsOnJobs( const uint & );
	MappedJobList jobs() const;
	MappedJobStatusList & setJobs( const Job & );
	QList<uint> tasksUnassigned() const;
	MappedJobStatusList & setTasksUnassigned( const uint & );
	QList<uint> tasksCounts() const;
	MappedJobStatusList & setTasksCounts( const uint & );
	QList<uint> tasksDones() const;
	MappedJobStatusList & setTasksDones( const uint & );
	QList<uint> tasksCancelled() const;
	MappedJobStatusList & setTasksCancelled( const uint & );
	QList<uint> tasksSuspended() const;
	MappedJobStatusList & setTasksSuspended( const uint & );
	QList<uint> tasksAssigned() const;
	MappedJobStatusList & setTasksAssigned( const uint & );
	QList<uint> tasksBusies() const;
	MappedJobStatusList & setTasksBusies( const uint & );
	QList<uint> tasksAverageTimes() const;
	MappedJobStatusList & setTasksAverageTimes( const uint & );
	QList<float> healths() const;
	MappedJobStatusList & setHealths( const float & );
	QList<QDateTime> jobLastUpdated() const;
	MappedJobStatusList & setJobLastUpdated( const QDateTime & );
	QList<uint> errorCounts() const;
	MappedJobStatusList & setErrorCounts( const uint & );
	QList<uint> lastNotifiedErrorCounts() const;
	MappedJobStatusList & setLastNotifiedErrorCounts( const uint & );
	QList<uint> averageMemories() const;
	MappedJobStatusList & setAverageMemories( const uint & );


};


