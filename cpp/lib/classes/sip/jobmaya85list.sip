


%MappedType MappedJobMaya85List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya85list.h"
#include "jobmaya85table.h"
#define MappedJobMaya85List JobMaya85List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya85Schema::instance() );
%End
};

class JobMaya85List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya85list.h>

%End
public:
	JobMaya85List();
	JobMaya85List( const RecordList &, Table * t = 0 );
	JobMaya85List( const JobMaya85List & );
	JobMaya85List( const Record &, Table * t = 0 );
	
	~JobMaya85List();

//	void insert( JobMaya85Iter, const JobMaya85 & );

//	JobMaya85Iter at( uint );

//	JobMaya85Iter find( const Record & );

//	JobMaya85Iter remove( const JobMaya85Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaya85Iter begin();

	//JobMaya85Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaya85List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaya85List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaya85List sorted( const QString & c, bool a = true ) const;

	MappedJobMaya85List unique() const;
	MappedJobMaya85List reversed() const;
	MappedJobMaya85List reloaded() const;



};


