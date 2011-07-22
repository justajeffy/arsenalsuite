


%MappedType MappedJobMantra100List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmantra100list.h"
#include "jobmantra100table.h"
#define MappedJobMantra100List JobMantra100List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMantra100Schema::instance() );
%End
};

class JobMantra100List : JobList
{
%TypeHeaderCode
#include <jobmantra100list.h>

%End
public:
	JobMantra100List();
	JobMantra100List( const RecordList &, Table * t = 0 );
	JobMantra100List( const JobMantra100List & );
	JobMantra100List( const Record &, Table * t = 0 );
	
	~JobMantra100List();

//	void insert( JobMantra100Iter, const JobMantra100 & );

//	JobMantra100Iter at( uint );

//	JobMantra100Iter find( const Record & );

//	JobMantra100Iter remove( const JobMantra100Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMantra100Iter begin();

	//JobMantra100Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMantra100List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMantra100List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMantra100List sorted( const QString & c, bool a = true ) const;

	MappedJobMantra100List unique() const;
	MappedJobMantra100List reversed() const;
	MappedJobMantra100List reloaded() const;

	QList<bool> forceRayTraces() const;
	MappedJobMantra100List & setForceRayTraces( const bool & );
	QList<uint> geoCacheSizes() const;
	MappedJobMantra100List & setGeoCacheSizes( const uint & );
	QList<uint> heights() const;
	MappedJobMantra100List & setHeights( const uint & );
	QList<uint> widths() const;
	MappedJobMantra100List & setWidths( const uint & );
	QStringList qualityFlags() const;
	MappedJobMantra100List & setQualityFlags( const QString & );
	QList<uint> threads() const;
	MappedJobMantra100List & setThreads( const uint & );
	QList<uint> renderQualities() const;
	MappedJobMantra100List & setRenderQualities( const uint & );


};


