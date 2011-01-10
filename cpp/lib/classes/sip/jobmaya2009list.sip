


%MappedType MappedJobMaya2009List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya2009list.h"
#include "jobmaya2009table.h"
#define MappedJobMaya2009List JobMaya2009List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya2009Schema::instance() );
%End
};

class JobMaya2009List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya2009list.h>

%End
public:
	JobMaya2009List();
	JobMaya2009List( const RecordList &, Table * t = 0 );
	JobMaya2009List( const JobMaya2009List & );
	JobMaya2009List( const Record &, Table * t = 0 );
	
	~JobMaya2009List();

//	void insert( JobMaya2009Iter, const JobMaya2009 & );

//	JobMaya2009Iter at( uint );

//	JobMaya2009Iter find( const Record & );

//	JobMaya2009Iter remove( const JobMaya2009Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaya2009Iter begin();

	//JobMaya2009Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaya2009List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaya2009List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaya2009List sorted( const QString & c, bool a = true ) const;

	MappedJobMaya2009List unique() const;
	MappedJobMaya2009List reversed() const;
	MappedJobMaya2009List reloaded() const;



};


