
%MappedType MappedResolution
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "resolutionlist.h"
#include "resolutiontable.h"
#define MappedResolution Resolution
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Resolution(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ResolutionSchema::instance() );
%End
};

class Resolution : Record
{
%TypeHeaderCode
#include <resolution.h>
#include "project.h"

%End
public:
	Resolution();

	Resolution( uint key );

	Resolution( const Resolution & other );

	Resolution( const Record & r );

	Resolution( RecordImp * imp, bool checkType = true );
	
	MappedResolution copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString deliveryFormat() const;
	MappedResolution & setDeliveryFormat( const QString & );
	MappedProject project() const;
	MappedResolution & setProject( const Project & );
	uint height() const;
	MappedResolution & setHeight( const uint & );
	QString outputFormat() const;
	MappedResolution & setOutputFormat( const QString & );
	QString name() const;
	MappedResolution & setName( const QString & );
	uint width() const;
	MappedResolution & setWidth( const uint & );
	float pixelAspect() const;
	MappedResolution & setPixelAspect( const float & );
	uint fps() const;
	MappedResolution & setFps( const uint & );


	static MappedResolutionList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedResolution reload( bool lockForUpdate = false );

	static MappedResolutionList recordsByProject( const Project &fkeyProject );





	QString displayString() const;

	QString dimString() const;

	QString relPath() const;
	
	QString fillFrameFileName() const;
	
	QString fillFrameFilePath() const;




	static Table * table();
	//static ResolutionSchema * schema();
};


