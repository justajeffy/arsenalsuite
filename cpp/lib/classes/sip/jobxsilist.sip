


%MappedType MappedJobXSIList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsilist.h"
#include "jobxsitable.h"
#define MappedJobXSIList JobXSIList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobXSISchema::instance() );
%End
};

class JobXSIList : JobList
{
%TypeHeaderCode
#include <jobxsilist.h>

%End
public:
	JobXSIList();
	JobXSIList( const RecordList &, Table * t = 0 );
	JobXSIList( const JobXSIList & );
	JobXSIList( const Record &, Table * t = 0 );
	
	~JobXSIList();

//	void insert( JobXSIIter, const JobXSI & );

//	JobXSIIter at( uint );

//	JobXSIIter find( const Record & );

//	JobXSIIter remove( const JobXSIIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobXSIIter begin();

	//JobXSIIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobXSIList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobXSIList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobXSIList sorted( const QString & c, bool a = true ) const;

	MappedJobXSIList unique() const;
	MappedJobXSIList reversed() const;
	MappedJobXSIList reloaded() const;

	QStringList passes() const;
	MappedJobXSIList & setPasses( const QString & );
	QStringList framelists() const;
	MappedJobXSIList & setFramelists( const QString & );
	QList<uint> frameStarts() const;
	MappedJobXSIList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobXSIList & setFrameEnds( const uint & );
	QList<uint> resolutionXs() const;
	MappedJobXSIList & setResolutionXs( const uint & );
	QList<uint> resolutionYs() const;
	MappedJobXSIList & setResolutionYs( const uint & );
	QStringList renderers() const;
	MappedJobXSIList & setRenderers( const QString & );
	QList<bool> motionBlurs() const;
	MappedJobXSIList & setMotionBlurs( const bool & );
	QList<bool> deformMotionBlurs() const;
	MappedJobXSIList & setDeformMotionBlurs( const bool & );


};


