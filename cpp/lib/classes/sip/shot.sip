
%MappedType MappedShot
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "shotlist.h"
#include "shottable.h"
#define MappedShot Shot
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Shot(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ShotSchema::instance() );
%End
};

class Shot : Element
{
%TypeHeaderCode
#include <shot.h>

%End
public:
	Shot();

	Shot( uint key );

	Shot( const Shot & other );

	Shot( const Record & r );

	Shot( RecordImp * imp, bool checkType = true );
	
	MappedShot copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString dialog() const;
	MappedShot & setDialog( const QString & );
	uint frameEnd() const;
	MappedShot & setFrameEnd( const uint & );
	uint frameStart() const;
	MappedShot & setFrameStart( const uint & );
	double shotNumber() const;
	MappedShot & setShotNumber( const double & );
	uint frameStartEDL() const;
	MappedShot & setFrameStartEDL( const uint & );
	uint frameEndEDL() const;
	MappedShot & setFrameEndEDL( const uint & );
	QString cameraInfo() const;
	MappedShot & setCameraInfo( const QString & );
	uint scriptPage() const;
	MappedShot & setScriptPage( const uint & );


	static MappedShotList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedShot reload( bool lockForUpdate = false );



	static ElementType type();




	QString sortString() const;

	QString displayNumber() const;

	static void checkForFrameFiles( ShotList, const Resolution &, bool fillMissing=false );
	static void deleteExtraFrameFiles( ShotList, const Resolution & );
	
	void createCompFileTrackers();
	void createRenderFileTrackers();
	void createFrames();

	MappedRecord sequence();


	static Table * table();
	//static ShotSchema * schema();
};


