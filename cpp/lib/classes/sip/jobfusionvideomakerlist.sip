


%MappedType MappedJobFusionVideoMakerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionvideomakerlist.h"
#include "jobfusionvideomakertable.h"
#define MappedJobFusionVideoMakerList JobFusionVideoMakerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobFusionVideoMakerSchema::instance() );
%End
};

class JobFusionVideoMakerList : JobFusionList
{
%TypeHeaderCode
#include <jobfusionvideomakerlist.h>

%End
public:
	JobFusionVideoMakerList();
	JobFusionVideoMakerList( const RecordList &, Table * t = 0 );
	JobFusionVideoMakerList( const JobFusionVideoMakerList & );
	JobFusionVideoMakerList( const Record &, Table * t = 0 );
	
	~JobFusionVideoMakerList();

//	void insert( JobFusionVideoMakerIter, const JobFusionVideoMaker & );

//	JobFusionVideoMakerIter at( uint );

//	JobFusionVideoMakerIter find( const Record & );

//	JobFusionVideoMakerIter remove( const JobFusionVideoMakerIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobFusionVideoMakerIter begin();

	//JobFusionVideoMakerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobFusionVideoMakerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobFusionVideoMakerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobFusionVideoMakerList sorted( const QString & c, bool a = true ) const;

	MappedJobFusionVideoMakerList unique() const;
	MappedJobFusionVideoMakerList reversed() const;
	MappedJobFusionVideoMakerList reloaded() const;

	QStringList codecs() const;
	MappedJobFusionVideoMakerList & setCodecs( const QString & );
	QStringList inputFramePaths() const;
	MappedJobFusionVideoMakerList & setInputFramePaths( const QString & );
	QList<uint> sequenceFrameStarts() const;
	MappedJobFusionVideoMakerList & setSequenceFrameStarts( const uint & );
	QList<uint> sequenceFrameEnds() const;
	MappedJobFusionVideoMakerList & setSequenceFrameEnds( const uint & );


};


