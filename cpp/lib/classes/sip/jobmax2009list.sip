


%MappedType MappedJobMax2009List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax2009list.h"
#include "jobmax2009table.h"
#define MappedJobMax2009List JobMax2009List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax2009Schema::instance() );
%End
};

class JobMax2009List : JobMaxList
{
%TypeHeaderCode
#include <jobmax2009list.h>

%End
public:
	JobMax2009List();
	JobMax2009List( const RecordList &, Table * t = 0 );
	JobMax2009List( const JobMax2009List & );
	JobMax2009List( const Record &, Table * t = 0 );
	
	~JobMax2009List();

//	void insert( JobMax2009Iter, const JobMax2009 & );

//	JobMax2009Iter at( uint );

//	JobMax2009Iter find( const Record & );

//	JobMax2009Iter remove( const JobMax2009Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax2009Iter begin();

	//JobMax2009Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax2009List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax2009List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax2009List sorted( const QString & c, bool a = true ) const;

	MappedJobMax2009List unique() const;
	MappedJobMax2009List reversed() const;
	MappedJobMax2009List reloaded() const;



};


