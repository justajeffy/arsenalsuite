


%MappedType MappedJobNuke51List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobnuke51list.h"
#include "jobnuke51table.h"
#define MappedJobNuke51List JobNuke51List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobNuke51Schema::instance() );
%End
};

class JobNuke51List : JobList
{
%TypeHeaderCode
#include <jobnuke51list.h>

%End
public:
	JobNuke51List();
	JobNuke51List( const RecordList &, Table * t = 0 );
	JobNuke51List( const JobNuke51List & );
	JobNuke51List( const Record &, Table * t = 0 );
	
	~JobNuke51List();

//	void insert( JobNuke51Iter, const JobNuke51 & );

//	JobNuke51Iter at( uint );

//	JobNuke51Iter find( const Record & );

//	JobNuke51Iter remove( const JobNuke51Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobNuke51Iter begin();

	//JobNuke51Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobNuke51List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobNuke51List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobNuke51List sorted( const QString & c, bool a = true ) const;

	MappedJobNuke51List unique() const;
	MappedJobNuke51List reversed() const;
	MappedJobNuke51List reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobNuke51List & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobNuke51List & setFrameEnds( const uint & );
	QList<uint> outputCounts() const;
	MappedJobNuke51List & setOutputCounts( const uint & );


};


