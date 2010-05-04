
%MappedType MappedVersionFileTracker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "versionfiletrackerlist.h"
#include "versionfiletrackertable.h"
#define MappedVersionFileTracker VersionFileTracker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new VersionFileTracker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, VersionFileTrackerSchema::instance() );
%End
};

class VersionFileTracker : FileTracker
{
%TypeHeaderCode
#include <versionfiletracker.h>
#include "versionfiletracker.h"

%End
public:
	VersionFileTracker();

	VersionFileTracker( uint key );

	VersionFileTracker( const VersionFileTracker & other );

	VersionFileTracker( const Record & r );

	VersionFileTracker( RecordImp * imp, bool checkType = true );
	
	MappedVersionFileTracker copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString fileNameTemplateRaw() const;
	MappedVersionFileTracker & setFileNameTemplateRaw( const QString & );
	MappedVersionFileTracker versionFileTracker() const;
	MappedVersionFileTracker & setVersionFileTracker( const VersionFileTracker & );
	QString oldFileNamesSingle() const;
	MappedVersionFileTracker & setOldFileNamesSingle( const QString & );
	uint versionRaw() const;
	MappedVersionFileTracker & setVersionRaw( const uint & );
	uint iterationRaw() const;
	MappedVersionFileTracker & setIterationRaw( const uint & );
	uint autoFinalRaw() const;
	MappedVersionFileTracker & setAutoFinalRaw( const uint & );


	static MappedVersionFileTrackerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedVersionFileTracker reload( bool lockForUpdate = false );

	static MappedVersionFileTrackerList recordsByVersionFileTracker( const VersionFileTracker &fkeyVersionFileTracker );





	
	QString fileName() const;
	bool setFileName( const QString & );
	
	QString path() const;
	void setPath( const QString & );
	
	void checkForUpdates();
	
	bool doesTrackFile( const QString & );
	
	QStringList fileNames() const;

	QStringList oldFileNames() const;
	void setOldFileNames( const QStringList & );

	bool copyToFinal( QString * errorMsg=0 ) const;
	QString finalPath() const;
	QString finalFilePath() const;
	
	QString getFinalFileName() const;
	
	uint version() const;
	void setVersion( uint version );
	
	uint iteration() const;
	void setIteration( uint iteration );
	
	bool autoFinal() const;
	void setAutoFinal( bool autoFinal );
	
	QString fileNameTemplate() const;
	void setFileNameTemplate( const QString & );
	
	bool isLinked() const;
	//
	// Parses the fileName to get the version and iteration
	// Only returns true if the filename matches this fileversion's
	// prefix and if the version and iteration can be parsed out
	bool parseVersion( const QString & fileName, int * version=0, int * iteration=0 );

	QString assembleVersion( int version, int iteration );
	
	// Returns all of the elements that are using this
	// file tracker. (Linked filetrackers' elements, and
	// the one non-linked filetracker's element).
	MappedRecordList elements() const;
	
	// Returns all the elements for the tracker
	// that tracks 'file'
	static MappedRecordList elementsFromPath( const QString & file );



	static Table * table();
	//static VersionFileTrackerSchema * schema();
};


