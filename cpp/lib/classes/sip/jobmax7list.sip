


%MappedType MappedJobMax7List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax7list.h"
#include "jobmax7table.h"
#define MappedJobMax7List JobMax7List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax7Schema::instance() );
%End
};

class JobMax7List : JobMaxList
{
%TypeHeaderCode
#include <jobmax7list.h>

%End
public:
	JobMax7List();
	JobMax7List( const RecordList &, Table * t = 0 );
	JobMax7List( const JobMax7List & );
	JobMax7List( const Record &, Table * t = 0 );
	
	~JobMax7List();

//	void insert( JobMax7Iter, const JobMax7 & );

//	JobMax7Iter at( uint );

//	JobMax7Iter find( const Record & );

//	JobMax7Iter remove( const JobMax7Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax7Iter begin();

	//JobMax7Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax7List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax7List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax7List sorted( const QString & c, bool a = true ) const;

	MappedJobMax7List unique() const;
	MappedJobMax7List reversed() const;
	MappedJobMax7List reloaded() const;



};


