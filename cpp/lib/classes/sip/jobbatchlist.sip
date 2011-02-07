


%MappedType MappedJobBatchList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobbatchlist.h"
#include "jobbatchtable.h"
#define MappedJobBatchList JobBatchList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobBatchSchema::instance() );
%End
};

class JobBatchList : JobList
{
%TypeHeaderCode
#include <jobbatchlist.h>

%End
public:
	JobBatchList();
	JobBatchList( const RecordList &, Table * t = 0 );
	JobBatchList( const JobBatchList & );
	JobBatchList( const Record &, Table * t = 0 );
	
	~JobBatchList();

//	void insert( JobBatchIter, const JobBatch & );

//	JobBatchIter at( uint );

//	JobBatchIter find( const Record & );

//	JobBatchIter remove( const JobBatchIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobBatchIter begin();

	//JobBatchIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobBatchList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobBatchList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobBatchList sorted( const QString & c, bool a = true ) const;

	MappedJobBatchList unique() const;
	MappedJobBatchList reversed() const;
	MappedJobBatchList reloaded() const;

	QStringList cmds() const;
	MappedJobBatchList & setCmds( const QString & );
	QList<bool> restartAfterShutdowns() const;
	MappedJobBatchList & setRestartAfterShutdowns( const bool & );
	QList<bool> passSlaveFramesAsParams() const;
	MappedJobBatchList & setPassSlaveFramesAsParams( const bool & );
	QList<bool> disableWow64FsRedirects() const;
	MappedJobBatchList & setDisableWow64FsRedirects( const bool & );


};


