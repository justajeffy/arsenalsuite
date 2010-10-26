
%MappedType MappedDiskImage
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "diskimagelist.h"
#include "diskimagetable.h"
#define MappedDiskImage DiskImage
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new DiskImage(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, DiskImageSchema::instance() );
%End
};

class DiskImage : Record
{
%TypeHeaderCode
#include <diskimage.h>

%End
public:
	DiskImage();

	DiskImage( uint key );

	DiskImage( const DiskImage & other );

	DiskImage( const Record & r );

	DiskImage( RecordImp * imp, bool checkType = true );
	
	MappedDiskImage copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString diskImage() const;
	MappedDiskImage & setDiskImage( const QString & );
	QString path() const;
	MappedDiskImage & setPath( const QString & );
	QDateTime created() const;
	MappedDiskImage & setCreated( const QDateTime & );


	static MappedDiskImageList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedDiskImage reload( bool lockForUpdate = false );







	static Table * table();
	//static DiskImageSchema * schema();
};


