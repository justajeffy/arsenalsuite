


%MappedType MappedJobServiceList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobservicelist.h"
#include "jobservicetable.h"
#define MappedJobServiceList JobServiceList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobServiceSchema::instance() );
%End
};

class JobServiceList : RecordList
{
%TypeHeaderCode
#include <jobservicelist.h>
#include "job.h"
#include "service.h"

%End
public:
	JobServiceList();
	JobServiceList( const RecordList &, Table * t = 0 );
	JobServiceList( const JobServiceList & );
	JobServiceList( const Record &, Table * t = 0 );
	
	~JobServiceList();

//	void insert( JobServiceIter, const JobService & );

//	JobServiceIter at( uint );

//	JobServiceIter find( const Record & );

//	JobServiceIter remove( const JobServiceIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobServiceIter begin();

	//JobServiceIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobServiceList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobServiceList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobServiceList sorted( const QString & c, bool a = true ) const;

	MappedJobServiceList unique() const;
	MappedJobServiceList reversed() const;
	MappedJobServiceList reloaded() const;

	MappedJobList jobs() const;
	MappedJobServiceList & setJobs( const Job & );
	MappedServiceList services() const;
	MappedJobServiceList & setServices( const Service & );


};


