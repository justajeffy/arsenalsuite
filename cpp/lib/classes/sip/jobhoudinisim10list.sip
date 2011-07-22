


%MappedType MappedJobHoudiniSim10List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhoudinisim10list.h"
#include "jobhoudinisim10table.h"
#define MappedJobHoudiniSim10List JobHoudiniSim10List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobHoudiniSim10Schema::instance() );
%End
};

class JobHoudiniSim10List : JobList
{
%TypeHeaderCode
#include <jobhoudinisim10list.h>

%End
public:
	JobHoudiniSim10List();
	JobHoudiniSim10List( const RecordList &, Table * t = 0 );
	JobHoudiniSim10List( const JobHoudiniSim10List & );
	JobHoudiniSim10List( const Record &, Table * t = 0 );
	
	~JobHoudiniSim10List();

//	void insert( JobHoudiniSim10Iter, const JobHoudiniSim10 & );

//	JobHoudiniSim10Iter at( uint );

//	JobHoudiniSim10Iter find( const Record & );

//	JobHoudiniSim10Iter remove( const JobHoudiniSim10Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobHoudiniSim10Iter begin();

	//JobHoudiniSim10Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobHoudiniSim10List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobHoudiniSim10List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobHoudiniSim10List sorted( const QString & c, bool a = true ) const;

	MappedJobHoudiniSim10List unique() const;
	MappedJobHoudiniSim10List reversed() const;
	MappedJobHoudiniSim10List reloaded() const;

	QList<uint> slices() const;
	MappedJobHoudiniSim10List & setSlices( const uint & );
	QStringList trackers() const;
	MappedJobHoudiniSim10List & setTrackers( const QString & );
	QList<uint> frameStarts() const;
	MappedJobHoudiniSim10List & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobHoudiniSim10List & setFrameEnds( const uint & );
	QStringList nodeNames() const;
	MappedJobHoudiniSim10List & setNodeNames( const QString & );


};


