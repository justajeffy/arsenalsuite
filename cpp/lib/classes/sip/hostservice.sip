
%MappedType MappedHostService
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostservicelist.h"
#include "hostservicetable.h"
#define MappedHostService HostService
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostService(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostServiceSchema::instance() );
%End
};

class HostService : Record
{
%TypeHeaderCode
#include <hostservice.h>
#include "host.h"
#include "service.h"
#include "syslog.h"

%End
public:
	HostService();

	HostService( uint key );

	HostService( const HostService & other );

	HostService( const Record & r );

	HostService( RecordImp * imp, bool checkType = true );
	
	MappedHostService copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostService & setHost( const Host & );
	MappedService service() const;
	MappedHostService & setService( const Service & );
	MappedSysLog sysLog() const;
	MappedHostService & setSysLog( const SysLog & );
	QDateTime pulseDateTime() const;
	MappedHostService & setPulseDateTime( const QDateTime & );
	uint remoteLogPort() const;
	MappedHostService & setRemoteLogPort( const uint & );
	bool enabled() const;
	MappedHostService & setEnabled( const bool & );


	static MappedHostServiceList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostService reload( bool lockForUpdate = false );

	static MappedHostServiceList recordsByHost( const Host &fkeyHost );
	static MappedHostServiceList recordsByService( const Service &fkeyService );
	static MappedHostService recordByHostAndService( const Host &fkeyHost, const Service &fkeyService );




	
	bool pulse();

	bool enableUnique();


	static Table * table();
	//static HostServiceSchema * schema();
};


