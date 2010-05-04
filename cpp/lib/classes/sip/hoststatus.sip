
%MappedType MappedHostStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hoststatuslist.h"
#include "hoststatustable.h"
#define MappedHostStatus HostStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostStatusSchema::instance() );
%End
};

class HostStatus : Record
{
%TypeHeaderCode
#include <hoststatus.h>
#include "host.h"

%End
public:
	HostStatus();

	HostStatus( uint key );

	HostStatus( const HostStatus & other );

	HostStatus( const Record & r );

	HostStatus( RecordImp * imp, bool checkType = true );
	
	MappedHostStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostStatus & setHost( const Host & );
	QString slaveStatus() const;
	MappedHostStatus & setSlaveStatus( const QString & );
	QDateTime lastStatusChange() const;
	MappedHostStatus & setLastStatusChange( const QDateTime & );
	QDateTime slavePulse() const;
	MappedHostStatus & setSlavePulse( const QDateTime & );
	int online() const;
	MappedHostStatus & setOnline( const int & );
	int activeAssignmentCount() const;
	MappedHostStatus & setActiveAssignmentCount( const int & );
	QDateTime lastAssignmentChange() const;
	MappedHostStatus & setLastAssignmentChange( const QDateTime & );
	/**
	  * Megabytes
	  **/
	int availableMemory() const;
	MappedHostStatus & setAvailableMemory( const int & );


	static MappedHostStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostStatus reload( bool lockForUpdate = false );

	static MappedHostStatus recordByHost( const Host &fkeyHost );





//
// Sets host.fkeyjob to 0, host.slaveFrames to ""
// Sets all jobtasks to new where fkeyhost= and status 'busy' or 'assigned'
// commits this host and the jobtasks
void returnSlaveFrames( bool commit=false );


	static Table * table();
	//static HostStatusSchema * schema();
};


