
%MappedType MappedFileTracker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "filetrackerlist.h"
#include "filetrackertable.h"
#define MappedFileTracker FileTracker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new FileTracker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, FileTrackerSchema::instance() );
%End
};

class FileTracker : Record
{
%TypeHeaderCode
#include <filetracker.h>
#include "element.h"
#include "pathtemplate.h"
#include "projectstorage.h"

%End
public:
	FileTracker();

	FileTracker( uint key );

	FileTracker( const FileTracker & other );

	FileTracker( const Record & r );

	FileTracker( RecordImp * imp, bool checkType = true );
	
	MappedFileTracker copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedFileTracker & setElement( const Element & );
	QString name() const;
	MappedFileTracker & setName( const QString & );
	QString pathRaw() const;
	MappedFileTracker & setPathRaw( const QString & );
	QString fileNameRaw() const;
	MappedFileTracker & setFileNameRaw( const QString & );
	MappedPathTemplate pathTemplate() const;
	MappedFileTracker & setPathTemplate( const PathTemplate & );
	MappedProjectStorage projectStorage() const;
	MappedFileTracker & setProjectStorage( const ProjectStorage & );
	QString storageName() const;
	MappedFileTracker & setStorageName( const QString & );
	int mPathCacheNumber() const;
	MappedFileTracker & setMPathCacheNumber( const int & );
	QString mPathCache() const;
	MappedFileTracker & setMPathCache( const QString & );


	static MappedFileTrackerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedFileTracker reload( bool lockForUpdate = false );

	static MappedFileTrackerList recordsByElement( const Element &fkeyElement );
	static MappedFileTrackerList recordsByPath( const QString &path );






	bool pathMatchesTemplate() const;
	bool fileNameMatchesTemplate() const;
	bool matchesTemplate() const;

	bool doesTrackFile( const QString & filePath ) const;
	
	// Generates the filename from the path template
	QString generateFileName() const;

	QString fileName() const;
	bool setFileName( const QString & fn );

	// Generates the path from the path template
	QString generatePath() const;

	QString path() const;
	void setPath( const QString & path );

	QString setCachedPath( const QString & path ) const;
	static void invalidatePathCache();

	void checkForUpdates();
	
	QString filePath() const;
	void setFilePath( const QString & filePath );

	QDateTime updated( bool last = true ) const;
	QDateTime firstUpdated() const;
	QDateTime lastUpdated() const;
	
	// Returns all FileTrackers that have files in 'dir'
	static MappedRecordList fromDirPath( const QString & dir );
	
	// Returns the FileTracker that tracks 'file'
	static MappedRecord fromPath( const QString & file );
	
	bool needsUpdate() const;
	
	MappedRecordList inputs() const;
	MappedRecordList outputs() const;




	static Table * table();
	//static FileTrackerSchema * schema();
};


