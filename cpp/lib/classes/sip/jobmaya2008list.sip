


%MappedType MappedJobMaya2008List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya2008list.h"
#include "jobmaya2008table.h"
#define MappedJobMaya2008List JobMaya2008List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya2008Schema::instance() );
%End
};

class JobMaya2008List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya2008list.h>

%End
public:
	JobMaya2008List();
	JobMaya2008List( const RecordList &, Table * t = 0 );
	JobMaya2008List( const JobMaya2008List & );
	JobMaya2008List( const Record &, Table * t = 0 );
	
	~JobMaya2008List();

//	void insert( JobMaya2008Iter, const JobMaya2008 & );

//	JobMaya2008Iter at( uint );

//	JobMaya2008Iter find( const Record & );

//	JobMaya2008Iter remove( const JobMaya2008Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaya2008Iter begin();

	//JobMaya2008Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaya2008List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaya2008List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaya2008List sorted( const QString & c, bool a = true ) const;

	MappedJobMaya2008List unique() const;
	MappedJobMaya2008List reversed() const;
	MappedJobMaya2008List reloaded() const;



};


