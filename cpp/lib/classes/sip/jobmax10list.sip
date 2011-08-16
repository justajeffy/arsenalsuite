


%MappedType MappedJobMax10List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax10list.h"
#include "jobmax10table.h"
#define MappedJobMax10List JobMax10List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax10Schema::instance() );
%End
};

class JobMax10List : JobMaxList
{
%TypeHeaderCode
#include <jobmax10list.h>

%End
public:
	JobMax10List();
	JobMax10List( const RecordList &, Table * t = 0 );
	JobMax10List( const JobMax10List & );
	JobMax10List( const Record &, Table * t = 0 );
	
	~JobMax10List();

//	void insert( JobMax10Iter, const JobMax10 & );

//	JobMax10Iter at( uint );

//	JobMax10Iter find( const Record & );

//	JobMax10Iter remove( const JobMax10Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax10Iter begin();

	//JobMax10Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax10List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax10List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax10List sorted( const QString & c, bool a = true ) const;

	MappedJobMax10List unique() const;
	MappedJobMax10List reversed() const;
	MappedJobMax10List reloaded() const;



};


