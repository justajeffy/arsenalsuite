


%MappedType MappedFileTrackerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "filetrackerlist.h"
#include "filetrackertable.h"
#define MappedFileTrackerList FileTrackerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, FileTrackerSchema::instance() );
%End
};

class FileTrackerList : RecordList
{
%TypeHeaderCode
#include <filetrackerlist.h>
#include "element.h"
#include "pathtemplate.h"
#include "projectstorage.h"

%End
public:
	FileTrackerList();
	FileTrackerList( const RecordList &, Table * t = 0 );
	FileTrackerList( const FileTrackerList & );
	FileTrackerList( const Record &, Table * t = 0 );
	
	~FileTrackerList();

//	void insert( FileTrackerIter, const FileTracker & );

//	FileTrackerIter at( uint );

//	FileTrackerIter find( const Record & );

//	FileTrackerIter remove( const FileTrackerIter & );

	int remove( const Record & );
	
	int remove();
	
	//FileTrackerIter begin();

	//FileTrackerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedFileTrackerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedFileTrackerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedFileTrackerList sorted( const QString & c, bool a = true ) const;

	MappedFileTrackerList unique() const;
	MappedFileTrackerList reversed() const;
	MappedFileTrackerList reloaded() const;

	MappedElementList elements() const;
	MappedFileTrackerList & setElements( const Element & );
	QStringList names() const;
	MappedFileTrackerList & setNames( const QString & );
	QStringList pathRaws() const;
	MappedFileTrackerList & setPathRaws( const QString & );
	QStringList fileNameRaws() const;
	MappedFileTrackerList & setFileNameRaws( const QString & );
	MappedPathTemplateList pathTemplates() const;
	MappedFileTrackerList & setPathTemplates( const PathTemplate & );
	MappedProjectStorageList projectStorages() const;
	MappedFileTrackerList & setProjectStorages( const ProjectStorage & );
	QStringList storageNames() const;
	MappedFileTrackerList & setStorageNames( const QString & );
	QList<int> mPathCacheNumbers() const;
	MappedFileTrackerList & setMPathCacheNumbers( const int & );
	QStringList mPathCaches() const;
	MappedFileTrackerList & setMPathCaches( const QString & );


};


