
%MappedType MappedLocation
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "locationlist.h"
#include "locationtable.h"
#define MappedLocation Location
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Location(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, LocationSchema::instance() );
%End
};

class Location : Record
{
%TypeHeaderCode
#include <location.h>

%End
public:
	Location();

	Location( uint key );

	Location( const Location & other );

	Location( const Record & r );

	Location( RecordImp * imp, bool checkType = true );
	
	MappedLocation copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedLocation & setName( const QString & );


	static MappedLocationList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedLocation reload( bool lockForUpdate = false );







	static Table * table();
	//static LocationSchema * schema();
};


