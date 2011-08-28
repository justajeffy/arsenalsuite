


%MappedType MappedJobMaya7List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya7list.h"
#include "jobmaya7table.h"
#define MappedJobMaya7List JobMaya7List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya7Schema::instance() );
%End
};

class JobMaya7List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya7list.h>

%End
public:
	JobMaya7List();
	JobMaya7List( const RecordList &, Table * t = 0 );
	JobMaya7List( const JobMaya7List & );
	JobMaya7List( const Record &, Table * t = 0 );
	
	~JobMaya7List();

//	void insert( JobMaya7Iter, const JobMaya7 & );

//	JobMaya7Iter at( uint );

//	JobMaya7Iter find( const Record & );

//	JobMaya7Iter remove( const JobMaya7Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaya7Iter begin();

	//JobMaya7Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaya7List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaya7List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaya7List sorted( const QString & c, bool a = true ) const;

	MappedJobMaya7List unique() const;
	MappedJobMaya7List reversed() const;
	MappedJobMaya7List reloaded() const;



};


