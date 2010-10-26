


%MappedType MappedJobCannedBatchList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcannedbatchlist.h"
#include "jobcannedbatchtable.h"
#define MappedJobCannedBatchList JobCannedBatchList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobCannedBatchSchema::instance() );
%End
};

class JobCannedBatchList : RecordList
{
%TypeHeaderCode
#include <jobcannedbatchlist.h>

%End
public:
	JobCannedBatchList();
	JobCannedBatchList( const RecordList &, Table * t = 0 );
	JobCannedBatchList( const JobCannedBatchList & );
	JobCannedBatchList( const Record &, Table * t = 0 );
	
	~JobCannedBatchList();

//	void insert( JobCannedBatchIter, const JobCannedBatch & );

//	JobCannedBatchIter at( uint );

//	JobCannedBatchIter find( const Record & );

//	JobCannedBatchIter remove( const JobCannedBatchIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobCannedBatchIter begin();

	//JobCannedBatchIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobCannedBatchList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobCannedBatchList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobCannedBatchList sorted( const QString & c, bool a = true ) const;

	MappedJobCannedBatchList unique() const;
	MappedJobCannedBatchList reversed() const;
	MappedJobCannedBatchList reloaded() const;

	QStringList names() const;
	MappedJobCannedBatchList & setNames( const QString & );
	QStringList groups() const;
	MappedJobCannedBatchList & setGroups( const QString & );
	QStringList cmds() const;
	MappedJobCannedBatchList & setCmds( const QString & );
	QList<bool> disableWow64FsRedirects() const;
	MappedJobCannedBatchList & setDisableWow64FsRedirects( const bool & );


};


