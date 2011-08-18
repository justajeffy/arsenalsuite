


%MappedType MappedJobRibGenList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobribgenlist.h"
#include "jobribgentable.h"
#define MappedJobRibGenList JobRibGenList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobRibGenSchema::instance() );
%End
};

class JobRibGenList : JobList
{
%TypeHeaderCode
#include <jobribgenlist.h>

%End
public:
	JobRibGenList();
	JobRibGenList( const RecordList &, Table * t = 0 );
	JobRibGenList( const JobRibGenList & );
	JobRibGenList( const Record &, Table * t = 0 );
	
	~JobRibGenList();

//	void insert( JobRibGenIter, const JobRibGen & );

//	JobRibGenIter at( uint );

//	JobRibGenIter find( const Record & );

//	JobRibGenIter remove( const JobRibGenIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobRibGenIter begin();

	//JobRibGenIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobRibGenList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobRibGenList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobRibGenList sorted( const QString & c, bool a = true ) const;

	MappedJobRibGenList unique() const;
	MappedJobRibGenList reversed() const;
	MappedJobRibGenList reloaded() const;

	QList<uint> frameStarts() const;
	MappedJobRibGenList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobRibGenList & setFrameEnds( const uint & );
	QStringList versions() const;
	MappedJobRibGenList & setVersions( const QString & );


};


