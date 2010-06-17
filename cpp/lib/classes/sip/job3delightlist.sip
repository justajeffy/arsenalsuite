


%MappedType MappedJob3DelightList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "job3delightlist.h"
#include "job3delighttable.h"
#define MappedJob3DelightList Job3DelightList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, Job3DelightSchema::instance() );
%End
};

class Job3DelightList : JobList
{
%TypeHeaderCode
#include <job3delightlist.h>

%End
public:
	Job3DelightList();
	Job3DelightList( const RecordList &, Table * t = 0 );
	Job3DelightList( const Job3DelightList & );
	Job3DelightList( const Record &, Table * t = 0 );
	
	~Job3DelightList();

//	void insert( Job3DelightIter, const Job3Delight & );

//	Job3DelightIter at( uint );

//	Job3DelightIter find( const Record & );

//	Job3DelightIter remove( const Job3DelightIter & );

	int remove( const Record & );
	
	int remove();
	
	//Job3DelightIter begin();

	//Job3DelightIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJob3DelightList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJob3DelightList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJob3DelightList sorted( const QString & c, bool a = true ) const;

	MappedJob3DelightList unique() const;
	MappedJob3DelightList reversed() const;
	MappedJob3DelightList reloaded() const;

	QList<uint> widths() const;
	MappedJob3DelightList & setWidths( const uint & );
	QList<uint> heights() const;
	MappedJob3DelightList & setHeights( const uint & );
	QList<uint> frameStarts() const;
	MappedJob3DelightList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJob3DelightList & setFrameEnds( const uint & );
	QList<uint> threads() const;
	MappedJob3DelightList & setThreads( const uint & );
	QList<uint> processes() const;
	MappedJob3DelightList & setProcesses( const uint & );
	QStringList jobscripts() const;
	MappedJob3DelightList & setJobscripts( const QString & );
	QStringList jobscriptparams() const;
	MappedJob3DelightList & setJobscriptparams( const QString & );


};


