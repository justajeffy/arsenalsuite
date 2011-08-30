


%MappedType MappedJobMax9List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax9list.h"
#include "jobmax9table.h"
#define MappedJobMax9List JobMax9List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax9Schema::instance() );
%End
};

class JobMax9List : JobMaxList
{
%TypeHeaderCode
#include <jobmax9list.h>

%End
public:
	JobMax9List();
	JobMax9List( const RecordList &, Table * t = 0 );
	JobMax9List( const JobMax9List & );
	JobMax9List( const Record &, Table * t = 0 );
	
	~JobMax9List();

//	void insert( JobMax9Iter, const JobMax9 & );

//	JobMax9Iter at( uint );

//	JobMax9Iter find( const Record & );

//	JobMax9Iter remove( const JobMax9Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax9Iter begin();

	//JobMax9Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax9List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax9List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax9List sorted( const QString & c, bool a = true ) const;

	MappedJobMax9List unique() const;
	MappedJobMax9List reversed() const;
	MappedJobMax9List reloaded() const;



};


