


%MappedType MappedRangeFileTrackerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "rangefiletrackerlist.h"
#include "rangefiletrackertable.h"
#define MappedRangeFileTrackerList RangeFileTrackerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, RangeFileTrackerSchema::instance() );
%End
};

class RangeFileTrackerList : FileTrackerList
{
%TypeHeaderCode
#include <rangefiletrackerlist.h>
#include "resolution.h"

%End
public:
	RangeFileTrackerList();
	RangeFileTrackerList( const RecordList &, Table * t = 0 );
	RangeFileTrackerList( const RangeFileTrackerList & );
	RangeFileTrackerList( const Record &, Table * t = 0 );
	
	~RangeFileTrackerList();

//	void insert( RangeFileTrackerIter, const RangeFileTracker & );

//	RangeFileTrackerIter at( uint );

//	RangeFileTrackerIter find( const Record & );

//	RangeFileTrackerIter remove( const RangeFileTrackerIter & );

	int remove( const Record & );
	
	int remove();
	
	//RangeFileTrackerIter begin();

	//RangeFileTrackerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedRangeFileTrackerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedRangeFileTrackerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedRangeFileTrackerList sorted( const QString & c, bool a = true ) const;

	MappedRangeFileTrackerList unique() const;
	MappedRangeFileTrackerList reversed() const;
	MappedRangeFileTrackerList reloaded() const;

	QStringList fileNameTemplates() const;
	MappedRangeFileTrackerList & setFileNameTemplates( const QString & );
	QList<int> frameStarts() const;
	MappedRangeFileTrackerList & setFrameStarts( const int & );
	QList<int> frameEnds() const;
	MappedRangeFileTrackerList & setFrameEnds( const int & );
	MappedResolutionList resolutions() const;
	MappedRangeFileTrackerList & setResolutions( const Resolution & );
	QStringList renderElements() const;
	MappedRangeFileTrackerList & setRenderElements( const QString & );


};


