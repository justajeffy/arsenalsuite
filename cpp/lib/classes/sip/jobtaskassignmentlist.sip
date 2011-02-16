


%MappedType MappedJobTaskAssignmentList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtaskassignmentlist.h"
#include "jobtaskassignmenttable.h"
#define MappedJobTaskAssignmentList JobTaskAssignmentList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobTaskAssignmentSchema::instance() );
%End
};

class JobTaskAssignmentList : RecordList
{
%TypeHeaderCode
#include <jobtaskassignmentlist.h>
#include "jobassignment.h"
#include "jobassignmentstatus.h"
#include "jobtask.h"
#include "joberror.h"

%End
public:
	JobTaskAssignmentList();
	JobTaskAssignmentList( const RecordList &, Table * t = 0 );
	JobTaskAssignmentList( const JobTaskAssignmentList & );
	JobTaskAssignmentList( const Record &, Table * t = 0 );
	
	~JobTaskAssignmentList();

//	void insert( JobTaskAssignmentIter, const JobTaskAssignment & );

//	JobTaskAssignmentIter at( uint );

//	JobTaskAssignmentIter find( const Record & );

//	JobTaskAssignmentIter remove( const JobTaskAssignmentIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobTaskAssignmentIter begin();

	//JobTaskAssignmentIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobTaskAssignmentList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobTaskAssignmentList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobTaskAssignmentList sorted( const QString & c, bool a = true ) const;

	MappedJobTaskAssignmentList unique() const;
	MappedJobTaskAssignmentList reversed() const;
	MappedJobTaskAssignmentList reloaded() const;

	MappedJobAssignmentList jobAssignments() const;
	MappedJobTaskAssignmentList & setJobAssignments( const JobAssignment & );
	QList<uint> memories() const;
	MappedJobTaskAssignmentList & setMemories( const uint & );
	QList<QDateTime> started() const;
	MappedJobTaskAssignmentList & setStarted( const QDateTime & );
	QList<QDateTime> ended() const;
	MappedJobTaskAssignmentList & setEnded( const QDateTime & );
	MappedJobAssignmentStatusList jobAssignmentStatuses() const;
	MappedJobTaskAssignmentList & setJobAssignmentStatuses( const JobAssignmentStatus & );
	MappedJobTaskList jobTasks() const;
	MappedJobTaskAssignmentList & setJobTasks( const JobTask & );
	MappedJobErrorList jobErrors() const;
	MappedJobTaskAssignmentList & setJobErrors( const JobError & );


};


