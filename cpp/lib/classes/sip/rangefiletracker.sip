
%MappedType MappedRangeFileTracker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "rangefiletrackerlist.h"
#include "rangefiletrackertable.h"
#define MappedRangeFileTracker RangeFileTracker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new RangeFileTracker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, RangeFileTrackerSchema::instance() );
%End
};

class RangeFileTracker : FileTracker
{
%TypeHeaderCode
#include <rangefiletracker.h>
#include "resolution.h"

%End
public:
	RangeFileTracker();

	RangeFileTracker( uint key );

	RangeFileTracker( const RangeFileTracker & other );

	RangeFileTracker( const Record & r );

	RangeFileTracker( RecordImp * imp, bool checkType = true );
	
	MappedRangeFileTracker copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString fileNameTemplate() const;
	MappedRangeFileTracker & setFileNameTemplate( const QString & );
	int frameStart() const;
	MappedRangeFileTracker & setFrameStart( const int & );
	int frameEnd() const;
	MappedRangeFileTracker & setFrameEnd( const int & );
	MappedResolution resolution() const;
	MappedRangeFileTracker & setResolution( const Resolution & );
	QString renderElement() const;
	MappedRangeFileTracker & setRenderElement( const QString & );


	static MappedRangeFileTrackerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedRangeFileTracker reload( bool lockForUpdate = false );






	
	QString fileName() const;
	bool setFileName( const QString & );
	void checkForUpdates();
	bool doesTrackFile( const QString & filePath );
	QDateTime updated( bool last = true ) const;
	
	QStringList files() const;

//	RFTFrame firstFrame() const;
//	RFTFrame lastFrame() const;
//	RFTFrame frame( int ) const;
		
	QString sortString( int frame ) const;

	QString displayNumber( int frame ) const;

	QString filePath( int frame ) const;
	QString fileName( int frame ) const;

	void setFilePath( const QString & );

	void fillFrames( bool overwrite=false );
	
	void fillFrame( int frame ) const;
	
	static QString timeCode( int frame, int fps );

	void deleteFrame( int frame ) const;



	static Table * table();
	//static RangeFileTrackerSchema * schema();
};


