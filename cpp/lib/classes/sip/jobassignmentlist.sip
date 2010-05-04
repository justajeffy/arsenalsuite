


%MappedType MappedJobAssignmentList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobassignmentlist.h"
#include "jobassignmenttable.h"
#define MappedJobAssignmentList JobAssignmentList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAssignmentSchema::instance() );
%End
};

class JobAssignmentList : RecordList
{
%TypeHeaderCode
#include <jobassignmentlist.h>
#include "job.h"
#include "jobassignmentstatus.h"
#include "host.h"
#include "joberror.h"
#include "jobtaskassignment.h"

%End
public:
	JobAssignmentList();
	JobAssignmentList( const RecordList &, Table * t = 0 );
	JobAssignmentList( const JobAssignmentList & );
	JobAssignmentList( const Record &, Table * t = 0 );
	
	~JobAssignmentList();

//	void insert( JobAssignmentIter, const JobAssignment & );

//	JobAssignmentIter at( uint );

//	JobAssignmentIter find( const Record & );

//	JobAssignmentIter remove( const JobAssignmentIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAssignmentIter begin();

	//JobAssignmentIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAssignmentList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAssignmentList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAssignmentList sorted( const QString & c, bool a = true ) const;

	MappedJobAssignmentList unique() const;
	MappedJobAssignmentList reversed() const;
	MappedJobAssignmentList reloaded() const;

	MappedJobList jobs() const;
	MappedJobAssignmentList & setJobs( const Job & );
	MappedJobAssignmentStatusList jobAssignmentStatuses() const;
	MappedJobAssignmentList & setJobAssignmentStatuses( const JobAssignmentStatus & );
	MappedHostList hosts() const;
	MappedJobAssignmentList & setHosts( const Host & );
	QStringList stdOuts() const;
	MappedJobAssignmentList & setStdOuts( const QString & );
	QStringList stdErrs() const;
	MappedJobAssignmentList & setStdErrs( const QString & );
	QStringList commands() const;
	MappedJobAssignmentList & setCommands( const QString & );
	QList<uint> maxMemories() const;
	MappedJobAssignmentList & setMaxMemories( const uint & );
	QList<QDateTime> started() const;
	MappedJobAssignmentList & setStarted( const QDateTime & );
	QList<QDateTime> ended() const;
	MappedJobAssignmentList & setEnded( const QDateTime & );
	MappedJobErrorList jobErrors() const;
	MappedJobAssignmentList & setJobErrors( const JobError & );
	QList<float> realtimes() const;
	MappedJobAssignmentList & setRealtimes( const float & );
	QList<float> usertimes() const;
	MappedJobAssignmentList & setUsertimes( const float & );
	QList<float> systimes() const;
	MappedJobAssignmentList & setSystimes( const float & );
	QList<uint> iowaits() const;
	MappedJobAssignmentList & setIowaits( const uint & );
	QList<uint> bytesRead() const;
	MappedJobAssignmentList & setBytesRead( const uint & );
	QList<uint> bytesWrite() const;
	MappedJobAssignmentList & setBytesWrite( const uint & );
	QList<float> efficiencies() const;
	MappedJobAssignmentList & setEfficiencies( const float & );
	QList<uint> opsRead() const;
	MappedJobAssignmentList & setOpsRead( const uint & );
	QList<uint> opsWrite() const;
	MappedJobAssignmentList & setOpsWrite( const uint & );
	MappedJobTaskAssignmentList jobTaskAssignments();


};


