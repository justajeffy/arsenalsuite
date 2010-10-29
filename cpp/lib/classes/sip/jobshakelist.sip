


%MappedType MappedJobShakeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobshakelist.h"
#include "jobshaketable.h"
#define MappedJobShakeList JobShakeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobShakeSchema::instance() );
%End
};

class JobShakeList : JobList
{
%TypeHeaderCode
#include <jobshakelist.h>

%End
public:
	JobShakeList();
	JobShakeList( const RecordList &, Table * t = 0 );
	JobShakeList( const JobShakeList & );
	JobShakeList( const Record &, Table * t = 0 );
	
	~JobShakeList();

//	void insert( JobShakeIter, const JobShake & );

//	JobShakeIter at( uint );

//	JobShakeIter find( const Record & );

//	JobShakeIter remove( const JobShakeIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobShakeIter begin();

	//JobShakeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobShakeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobShakeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobShakeList sorted( const QString & c, bool a = true ) const;

	MappedJobShakeList unique() const;
	MappedJobShakeList reversed() const;
	MappedJobShakeList reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobShakeList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobShakeList & setFrameEnds( const uint & );
	QStringList codecs() const;
	MappedJobShakeList & setCodecs( const QString & );
	QStringList slatePaths() const;
	MappedJobShakeList & setSlatePaths( const QString & );
	QStringList frameRanges() const;
	MappedJobShakeList & setFrameRanges( const QString & );


};


