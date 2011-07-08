


%MappedType MappedJobTaskList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtasklist.h"
#include "jobtasktable.h"
#define MappedJobTaskList JobTaskList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobTaskSchema::instance() );
%End
};

class JobTaskList : RecordList
{
%TypeHeaderCode
#include <jobtasklist.h>
#include "host.h"
#include "job.h"
#include "joboutput.h"
#include "jobtaskassignment.h"

%End
public:
	JobTaskList();
	JobTaskList( const RecordList &, Table * t = 0 );
	JobTaskList( const JobTaskList & );
	JobTaskList( const Record &, Table * t = 0 );
	
	~JobTaskList();

//	void insert( JobTaskIter, const JobTask & );

//	JobTaskIter at( uint );

//	JobTaskIter find( const Record & );

//	JobTaskIter remove( const JobTaskIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobTaskIter begin();

	//JobTaskIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobTaskList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobTaskList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobTaskList sorted( const QString & c, bool a = true ) const;

	MappedJobTaskList unique() const;
	MappedJobTaskList reversed() const;
	MappedJobTaskList reloaded() const;

	MappedHostList hosts() const;
	MappedJobTaskList & setHosts( const Host & );
	MappedJobList jobs() const;
	MappedJobTaskList & setJobs( const Job & );
	QStringList statuses() const;
	MappedJobTaskList & setStatuses( const QString & );
	QList<int> frameNumbers() const;
	MappedJobTaskList & setFrameNumbers( const int & );
	QStringList labels() const;
	MappedJobTaskList & setLabels( const QString & );
	MappedJobOutputList jobOutputs() const;
	MappedJobTaskList & setJobOutputs( const JobOutput & );
	MappedJobTaskAssignmentList jobTaskAssignments() const;
	MappedJobTaskList & setJobTaskAssignments( const JobTaskAssignment & );
	QList<uint> progresses() const;
	MappedJobTaskList & setProgresses( const uint & );


};


