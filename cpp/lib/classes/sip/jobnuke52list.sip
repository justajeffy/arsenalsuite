


%MappedType MappedJobNuke52List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobnuke52list.h"
#include "jobnuke52table.h"
#define MappedJobNuke52List JobNuke52List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobNuke52Schema::instance() );
%End
};

class JobNuke52List : JobList
{
%TypeHeaderCode
#include <jobnuke52list.h>

%End
public:
	JobNuke52List();
	JobNuke52List( const RecordList &, Table * t = 0 );
	JobNuke52List( const JobNuke52List & );
	JobNuke52List( const Record &, Table * t = 0 );
	
	~JobNuke52List();

//	void insert( JobNuke52Iter, const JobNuke52 & );

//	JobNuke52Iter at( uint );

//	JobNuke52Iter find( const Record & );

//	JobNuke52Iter remove( const JobNuke52Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobNuke52Iter begin();

	//JobNuke52Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobNuke52List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobNuke52List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobNuke52List sorted( const QString & c, bool a = true ) const;

	MappedJobNuke52List unique() const;
	MappedJobNuke52List reversed() const;
	MappedJobNuke52List reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobNuke52List & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobNuke52List & setFrameEnds( const uint & );
	QList<uint> outputCounts() const;
	MappedJobNuke52List & setOutputCounts( const uint & );


};


