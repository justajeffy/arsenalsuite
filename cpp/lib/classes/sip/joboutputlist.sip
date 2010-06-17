


%MappedType MappedJobOutputList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joboutputlist.h"
#include "joboutputtable.h"
#define MappedJobOutputList JobOutputList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobOutputSchema::instance() );
%End
};

class JobOutputList : RecordList
{
%TypeHeaderCode
#include <joboutputlist.h>
#include "job.h"
#include "filetracker.h"

%End
public:
	JobOutputList();
	JobOutputList( const RecordList &, Table * t = 0 );
	JobOutputList( const JobOutputList & );
	JobOutputList( const Record &, Table * t = 0 );
	
	~JobOutputList();

//	void insert( JobOutputIter, const JobOutput & );

//	JobOutputIter at( uint );

//	JobOutputIter find( const Record & );

//	JobOutputIter remove( const JobOutputIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobOutputIter begin();

	//JobOutputIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobOutputList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobOutputList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobOutputList sorted( const QString & c, bool a = true ) const;

	MappedJobOutputList unique() const;
	MappedJobOutputList reversed() const;
	MappedJobOutputList reloaded() const;

	MappedJobList jobs() const;
	MappedJobOutputList & setJobs( const Job & );
	QStringList names() const;
	MappedJobOutputList & setNames( const QString & );
	MappedFileTrackerList fileTrackers() const;
	MappedJobOutputList & setFileTrackers( const FileTracker & );


};


