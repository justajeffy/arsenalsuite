


%MappedType MappedJobAutodeskBurnList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobautodeskburnlist.h"
#include "jobautodeskburntable.h"
#define MappedJobAutodeskBurnList JobAutodeskBurnList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAutodeskBurnSchema::instance() );
%End
};

class JobAutodeskBurnList : JobList
{
%TypeHeaderCode
#include <jobautodeskburnlist.h>

%End
public:
	JobAutodeskBurnList();
	JobAutodeskBurnList( const RecordList &, Table * t = 0 );
	JobAutodeskBurnList( const JobAutodeskBurnList & );
	JobAutodeskBurnList( const Record &, Table * t = 0 );
	
	~JobAutodeskBurnList();

//	void insert( JobAutodeskBurnIter, const JobAutodeskBurn & );

//	JobAutodeskBurnIter at( uint );

//	JobAutodeskBurnIter find( const Record & );

//	JobAutodeskBurnIter remove( const JobAutodeskBurnIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobAutodeskBurnIter begin();

	//JobAutodeskBurnIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobAutodeskBurnList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobAutodeskBurnList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobAutodeskBurnList sorted( const QString & c, bool a = true ) const;

	MappedJobAutodeskBurnList unique() const;
	MappedJobAutodeskBurnList reversed() const;
	MappedJobAutodeskBurnList reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobAutodeskBurnList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobAutodeskBurnList & setFrameEnds( const uint & );
	QStringList handles() const;
	MappedJobAutodeskBurnList & setHandles( const QString & );


};


