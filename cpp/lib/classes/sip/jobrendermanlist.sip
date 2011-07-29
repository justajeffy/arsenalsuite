


%MappedType MappedJobRenderManList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobrendermanlist.h"
#include "jobrendermantable.h"
#define MappedJobRenderManList JobRenderManList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobRenderManSchema::instance() );
%End
};

class JobRenderManList : JobList
{
%TypeHeaderCode
#include <jobrendermanlist.h>

%End
public:
	JobRenderManList();
	JobRenderManList( const RecordList &, Table * t = 0 );
	JobRenderManList( const JobRenderManList & );
	JobRenderManList( const Record &, Table * t = 0 );
	
	~JobRenderManList();

//	void insert( JobRenderManIter, const JobRenderMan & );

//	JobRenderManIter at( uint );

//	JobRenderManIter find( const Record & );

//	JobRenderManIter remove( const JobRenderManIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobRenderManIter begin();

	//JobRenderManIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobRenderManList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobRenderManList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobRenderManList sorted( const QString & c, bool a = true ) const;

	MappedJobRenderManList unique() const;
	MappedJobRenderManList reversed() const;
	MappedJobRenderManList reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobRenderManList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobRenderManList & setFrameEnds( const uint & );
	QStringList versions() const;
	MappedJobRenderManList & setVersions( const QString & );


};


