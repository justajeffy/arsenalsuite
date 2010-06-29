


%MappedType MappedJobMax8List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax8list.h"
#include "jobmax8table.h"
#define MappedJobMax8List JobMax8List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax8Schema::instance() );
%End
};

class JobMax8List : JobMaxList
{
%TypeHeaderCode
#include <jobmax8list.h>

%End
public:
	JobMax8List();
	JobMax8List( const RecordList &, Table * t = 0 );
	JobMax8List( const JobMax8List & );
	JobMax8List( const Record &, Table * t = 0 );
	
	~JobMax8List();

//	void insert( JobMax8Iter, const JobMax8 & );

//	JobMax8Iter at( uint );

//	JobMax8Iter find( const Record & );

//	JobMax8Iter remove( const JobMax8Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax8Iter begin();

	//JobMax8Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax8List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax8List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax8List sorted( const QString & c, bool a = true ) const;

	MappedJobMax8List unique() const;
	MappedJobMax8List reversed() const;
	MappedJobMax8List reloaded() const;



};


