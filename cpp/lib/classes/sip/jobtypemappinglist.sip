


%MappedType MappedJobTypeMappingList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtypemappinglist.h"
#include "jobtypemappingtable.h"
#define MappedJobTypeMappingList JobTypeMappingList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobTypeMappingSchema::instance() );
%End
};

class JobTypeMappingList : RecordList
{
%TypeHeaderCode
#include <jobtypemappinglist.h>
#include "jobtype.h"
#include "mapping.h"

%End
public:
	JobTypeMappingList();
	JobTypeMappingList( const RecordList &, Table * t = 0 );
	JobTypeMappingList( const JobTypeMappingList & );
	JobTypeMappingList( const Record &, Table * t = 0 );
	
	~JobTypeMappingList();

//	void insert( JobTypeMappingIter, const JobTypeMapping & );

//	JobTypeMappingIter at( uint );

//	JobTypeMappingIter find( const Record & );

//	JobTypeMappingIter remove( const JobTypeMappingIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobTypeMappingIter begin();

	//JobTypeMappingIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobTypeMappingList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobTypeMappingList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobTypeMappingList sorted( const QString & c, bool a = true ) const;

	MappedJobTypeMappingList unique() const;
	MappedJobTypeMappingList reversed() const;
	MappedJobTypeMappingList reloaded() const;

	MappedJobTypeList jobTypes() const;
	MappedJobTypeMappingList & setJobTypes( const JobType & );
	MappedMappingList mappings() const;
	MappedJobTypeMappingList & setMappings( const Mapping & );


};


