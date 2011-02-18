
%MappedType MappedHostSoftware
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostsoftwarelist.h"
#include "hostsoftwaretable.h"
#define MappedHostSoftware HostSoftware
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostSoftware(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostSoftwareSchema::instance() );
%End
};

class HostSoftware : Record
{
%TypeHeaderCode
#include <hostsoftware.h>
#include "host.h"
#include "software.h"

%End
public:
	HostSoftware();

	HostSoftware( uint key );

	HostSoftware( const HostSoftware & other );

	HostSoftware( const Record & r );

	HostSoftware( RecordImp * imp, bool checkType = true );
	
	MappedHostSoftware copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostSoftware & setHost( const Host & );
	MappedSoftware software() const;
	MappedHostSoftware & setSoftware( const Software & );


	static MappedHostSoftwareList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostSoftware reload( bool lockForUpdate = false );

	static MappedHostSoftwareList recordsByHost( const Host &fkeyHost );
	static MappedHostSoftwareList recordsBySoftware( const Software &fkeySoftware );






	static Table * table();
	//static HostSoftwareSchema * schema();
};


