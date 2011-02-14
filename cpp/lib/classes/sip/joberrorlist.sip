


%MappedType MappedJobErrorList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorlist.h"
#include "joberrortable.h"
#define MappedJobErrorList JobErrorList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobErrorSchema::instance() );
%End
};

class JobErrorList : RecordList
{
%TypeHeaderCode
#include <joberrorlist.h>
#include "host.h"
#include "job.h"
#include "jobassignment.h"

%End
public:
	JobErrorList();
	JobErrorList( const RecordList &, Table * t = 0 );
	JobErrorList( const JobErrorList & );
	JobErrorList( const Record &, Table * t = 0 );
	
	~JobErrorList();

//	void insert( JobErrorIter, const JobError & );

//	JobErrorIter at( uint );

//	JobErrorIter find( const Record & );

//	JobErrorIter remove( const JobErrorIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobErrorIter begin();

	//JobErrorIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobErrorList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobErrorList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobErrorList sorted( const QString & c, bool a = true ) const;

	MappedJobErrorList unique() const;
	MappedJobErrorList reversed() const;
	MappedJobErrorList reloaded() const;

	MappedHostList hosts() const;
	MappedJobErrorList & setHosts( const Host & );
	MappedJobList jobs() const;
	MappedJobErrorList & setJobs( const Job & );
	QStringList frameses() const;
	MappedJobErrorList & setFrameses( const QString & );
	QStringList messages() const;
	MappedJobErrorList & setMessages( const QString & );
	QList<uint> errorTimes() const;
	MappedJobErrorList & setErrorTimes( const uint & );
	QList<uint> counts() const;
	MappedJobErrorList & setCounts( const uint & );
	QList<bool> cleared() const;
	MappedJobErrorList & setCleared( const bool & );
	QList<QDateTime> lastOccurrences() const;
	MappedJobErrorList & setLastOccurrences( const QDateTime & );
	QList<bool> timeouts() const;
	MappedJobErrorList & setTimeouts( const bool & );
	MappedJobAssignmentList jobAssignments();


};


