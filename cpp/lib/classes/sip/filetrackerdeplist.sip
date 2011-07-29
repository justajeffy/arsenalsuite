


%MappedType MappedFileTrackerDepList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "filetrackerdeplist.h"
#include "filetrackerdeptable.h"
#define MappedFileTrackerDepList FileTrackerDepList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, FileTrackerDepSchema::instance() );
%End
};

class FileTrackerDepList : RecordList
{
%TypeHeaderCode
#include <filetrackerdeplist.h>
#include "filetracker.h"
#include "filetracker.h"

%End
public:
	FileTrackerDepList();
	FileTrackerDepList( const RecordList &, Table * t = 0 );
	FileTrackerDepList( const FileTrackerDepList & );
	FileTrackerDepList( const Record &, Table * t = 0 );
	
	~FileTrackerDepList();

//	void insert( FileTrackerDepIter, const FileTrackerDep & );

//	FileTrackerDepIter at( uint );

//	FileTrackerDepIter find( const Record & );

//	FileTrackerDepIter remove( const FileTrackerDepIter & );

	int remove( const Record & );
	
	int remove();
	
	//FileTrackerDepIter begin();

	//FileTrackerDepIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedFileTrackerDepList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedFileTrackerDepList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedFileTrackerDepList sorted( const QString & c, bool a = true ) const;

	MappedFileTrackerDepList unique() const;
	MappedFileTrackerDepList reversed() const;
	MappedFileTrackerDepList reloaded() const;

	MappedFileTrackerList inputs() const;
	MappedFileTrackerDepList & setInputs( const FileTracker & );
	MappedFileTrackerList outputs() const;
	MappedFileTrackerDepList & setOutputs( const FileTracker & );


};


