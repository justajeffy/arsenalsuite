
%MappedType MappedHostInterface
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostinterfacelist.h"
#include "hostinterfacetable.h"
#define MappedHostInterface HostInterface
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostInterface(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostInterfaceSchema::instance() );
%End
};

class HostInterface : Record
{
%TypeHeaderCode
#include <hostinterface.h>
#include "host.h"
#include "hostinterfacetype.h"

%End
public:
	HostInterface();

	HostInterface( uint key );

	HostInterface( const HostInterface & other );

	HostInterface( const Record & r );

	HostInterface( RecordImp * imp, bool checkType = true );
	
	MappedHostInterface copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostInterface & setHost( const Host & );
	QString mac() const;
	MappedHostInterface & setMac( const QString & );
	QString ip() const;
	MappedHostInterface & setIp( const QString & );
	MappedHostInterfaceType type() const;
	MappedHostInterface & setType( const HostInterfaceType & );
	int switchPort() const;
	MappedHostInterface & setSwitchPort( const int & );


	static MappedHostInterfaceList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostInterface reload( bool lockForUpdate = false );

	static MappedHostInterfaceList recordsByHost( const Host &fkeyHost );






	static Table * table();
	//static HostInterfaceSchema * schema();
};


