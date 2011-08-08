


%MappedType MappedJobSyncList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobsynclist.h"
#include "jobsynctable.h"
#define MappedJobSyncList JobSyncList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobSyncSchema::instance() );
%End
};

class JobSyncList : JobList
{
%TypeHeaderCode
#include <jobsynclist.h>

%End
public:
	JobSyncList();
	JobSyncList( const RecordList &, Table * t = 0 );
	JobSyncList( const JobSyncList & );
	JobSyncList( const Record &, Table * t = 0 );
	
	~JobSyncList();

//	void insert( JobSyncIter, const JobSync & );

//	JobSyncIter at( uint );

//	JobSyncIter find( const Record & );

//	JobSyncIter remove( const JobSyncIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobSyncIter begin();

	//JobSyncIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobSyncList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobSyncList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobSyncList sorted( const QString & c, bool a = true ) const;

	MappedJobSyncList unique() const;
	MappedJobSyncList reversed() const;
	MappedJobSyncList reloaded() const;

	QStringList directions() const;
	MappedJobSyncList & setDirections( const QString & );
	QStringList filesFroms() const;
	MappedJobSyncList & setFilesFroms( const QString & );
	QStringList appends() const;
	MappedJobSyncList & setAppends( const QString & );


};


