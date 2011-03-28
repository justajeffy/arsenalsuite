
%MappedType MappedHost
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostlist.h"
#include "hosttable.h"
#define MappedHost Host
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Host(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostSchema::instance() );
%End
};

class Host : Record
{
%TypeHeaderCode
#include <host.h>
#include "host.h"
#include "diskimage.h"
#include "location.h"
#include "user.h"
#include "hostinterface.h"
#include "hostload.h"
#include "hostservice.h"
#include "hostsoftware.h"
#include "hoststatus.h"
#include "jobassignment.h"
#include "jobhistory.h"

%End
public:
	Host();

	Host( uint key );

	Host( const Host & other );

	Host( const Record & r );

	Host( RecordImp * imp, bool checkType = true );
	
	MappedHost copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString abVersion() const;
	MappedHost & setAbVersion( const QString & );
	QString backupbytes() const;
	MappedHost & setBackupbytes( const QString & );
	uint cpus() const;
	MappedHost & setCpus( const uint & );
	QString cpuName() const;
	MappedHost & setCpuName( const QString & );
	QString architecture() const;
	MappedHost & setArchitecture( const QString & );
	QString osVersion() const;
	MappedHost & setOsVersion( const QString & );
	QString description() const;
	MappedHost & setDescription( const QString & );
	QString diskusage() const;
	MappedHost & setDiskusage( const QString & );
	QString name() const;
	MappedHost & setName( const QString & );
	QString manufacturer() const;
	MappedHost & setManufacturer( const QString & );
	QString model() const;
	MappedHost & setModel( const QString & );
	QString os() const;
	MappedHost & setOs( const QString & );
	QString slavePluginList() const;
	MappedHost & setSlavePluginList( const QString & );
	QString sn() const;
	MappedHost & setSn( const QString & );
	QString version() const;
	MappedHost & setVersion( const QString & );
	double dutyCycle() const;
	MappedHost & setDutyCycle( const double & );
	uint memory() const;
	MappedHost & setMemory( const uint & );
	uint mhz() const;
	MappedHost & setMhz( const uint & );
	int online() const;
	MappedHost & setOnline( const int & );
	uint uid() const;
	MappedHost & setUid( const uint & );
	uint virusCount() const;
	MappedHost & setVirusCount( const uint & );
	QDate virusTimeStamp() const;
	MappedHost & setVirusTimeStamp( const QDate & );
	MappedHost backupHost() const;
	MappedHost & setBackupHost( const Host & );
	bool allowMapping() const;
	MappedHost & setAllowMapping( const bool & );
	bool allowSleep() const;
	MappedHost & setAllowSleep( const bool & );
	double locationX() const;
	MappedHost & setLocationX( const double & );
	double locationY() const;
	MappedHost & setLocationY( const double & );
	double locationZ() const;
	MappedHost & setLocationZ( const double & );
	MappedDiskImage diskImage() const;
	MappedHost & setDiskImage( const DiskImage & );
	QString bootAction() const;
	MappedHost & setBootAction( const QString & );
	QString syncName() const;
	MappedHost & setSyncName( const QString & );
	MappedLocation location() const;
	MappedHost & setLocation( const Location & );
	/**
	  * Timestamp of last time puppet ran on this host
	  **/
	QDateTime puppetPulse() const;
	MappedHost & setPuppetPulse( const QDateTime & );
	int maxAssignments() const;
	MappedHost & setMaxAssignments( const int & );
	MappedUser user() const;
	MappedHost & setUser( const User & );
	MappedHostInterfaceList hostInterfaces() const;
	MappedHostLoad hostLoad() const;
	MappedHostServiceList hostServices() const;
	MappedHostSoftwareList hostSoftwares() const;
	MappedHostStatus hostStatus() const;
	MappedJobAssignmentList jobAssignments() const;
	MappedJobHistoryList jobHistories() const;


	static MappedHostList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHost reload( bool lockForUpdate = false );

	static MappedHost recordByName( const QString &host );





JobAssignmentList activeAssignments() const;
static JobAssignmentList activeAssignments(HostList hosts);

static MappedHost currentHost();
static QString currentHostName();
int syslogStatus();
static MappedHost autoRegister();
void updateHardwareInfo();


	static Table * table();
	//static HostSchema * schema();
};


