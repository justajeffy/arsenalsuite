


%MappedType MappedJobMaya8List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya8list.h"
#include "jobmaya8table.h"
#define MappedJobMaya8List JobMaya8List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya8Schema::instance() );
%End
};

class JobMaya8List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya8list.h>

%End
public:
	JobMaya8List();
	JobMaya8List( const RecordList &, Table * t = 0 );
	JobMaya8List( const JobMaya8List & );
	JobMaya8List( const Record &, Table * t = 0 );
	
	~JobMaya8List();

//	void insert( JobMaya8Iter, const JobMaya8 & );

//	JobMaya8Iter at( uint );

//	JobMaya8Iter find( const Record & );

//	JobMaya8Iter remove( const JobMaya8Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaya8Iter begin();

	//JobMaya8Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaya8List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaya8List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaya8List sorted( const QString & c, bool a = true ) const;

	MappedJobMaya8List unique() const;
	MappedJobMaya8List reversed() const;
	MappedJobMaya8List reloaded() const;



};


