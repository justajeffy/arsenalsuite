
%MappedType MappedLicense
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "licenselist.h"
#include "licensetable.h"
#define MappedLicense License
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new License(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, LicenseSchema::instance() );
%End
};

class License : Record
{
%TypeHeaderCode
#include <license.h>
#include "host.h"
#include "software.h"

%End
public:
	License();

	License( uint key );

	License( const License & other );

	License( const Record & r );

	License( RecordImp * imp, bool checkType = true );
	
	MappedLicense copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString license() const;
	MappedLicense & setLicense( const QString & );
	MappedHost host() const;
	MappedLicense & setHost( const Host & );
	MappedSoftware software() const;
	MappedLicense & setSoftware( const Software & );
	int total() const;
	MappedLicense & setTotal( const int & );
	int reserved() const;
	MappedLicense & setReserved( const int & );
	int inUse() const;
	MappedLicense & setInUse( const int & );


	static MappedLicenseList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedLicense reload( bool lockForUpdate = false );

	static MappedLicenseList recordsByHost( const Host &fkeyHost );
	static MappedLicenseList recordsBySoftware( const Software &fkeySoftware );






	static Table * table();
	//static LicenseSchema * schema();
};


