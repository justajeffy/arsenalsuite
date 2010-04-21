


%MappedType MappedJobDepList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobdeplist.h"
#include "jobdeptable.h"
#define MappedJobDepList JobDepList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobDepSchema::instance() );
%End
};

class JobDepList : RecordList
{
%TypeHeaderCode
#include <jobdeplist.h>
#include "job.h"
#include "job.h"

%End
public:
	JobDepList();
	JobDepList( const RecordList &, Table * t = 0 );
	JobDepList( const JobDepList & );
	JobDepList( const Record &, Table * t = 0 );
	
	~JobDepList();

//	void insert( JobDepIter, const JobDep & );

//	JobDepIter at( uint );

//	JobDepIter find( const Record & );

//	JobDepIter remove( const JobDepIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobDepIter begin();

	//JobDepIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobDepList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobDepList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobDepList sorted( const QString & c, bool a = true ) const;

	MappedJobDepList unique() const;
	MappedJobDepList reversed() const;
	MappedJobDepList reloaded() const;

	MappedJobList jobs() const;
	MappedJobDepList & setJobs( const Job & );
	MappedJobList deps() const;
	MappedJobDepList & setDeps( const Job & );
	QList<uint> depTypes() const;
	MappedJobDepList & setDepTypes( const uint & );


};


