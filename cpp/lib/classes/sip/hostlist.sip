


%MappedType MappedHostList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostlist.h"
#include "hosttable.h"
#define MappedHostList HostList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostSchema::instance() );
%End
};

class HostList : RecordList
{
%TypeHeaderCode
#include <hostlist.h>
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
	HostList();
	HostList( const RecordList &, Table * t = 0 );
	HostList( const HostList & );
	HostList( const Record &, Table * t = 0 );
	
	~HostList();

//	void insert( HostIter, const Host & );

//	HostIter at( uint );

//	HostIter find( const Record & );

//	HostIter remove( const HostIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostIter begin();

	//HostIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostList sorted( const QString & c, bool a = true ) const;

	MappedHostList unique() const;
	MappedHostList reversed() const;
	MappedHostList reloaded() const;

	QStringList abVersions() const;
	MappedHostList & setAbVersions( const QString & );
	QStringList backupbyteses() const;
	MappedHostList & setBackupbyteses( const QString & );
	QList<uint> cpuses() const;
	MappedHostList & setCpuses( const uint & );
	QStringList cpuNames() const;
	MappedHostList & setCpuNames( const QString & );
	QStringList architectures() const;
	MappedHostList & setArchitectures( const QString & );
	QStringList osVersions() const;
	MappedHostList & setOsVersions( const QString & );
	QStringList descriptions() const;
	MappedHostList & setDescriptions( const QString & );
	QStringList diskusages() const;
	MappedHostList & setDiskusages( const QString & );
	QStringList names() const;
	MappedHostList & setNames( const QString & );
	QStringList manufacturers() const;
	MappedHostList & setManufacturers( const QString & );
	QStringList models() const;
	MappedHostList & setModels( const QString & );
	QStringList oses() const;
	MappedHostList & setOses( const QString & );
	QStringList slavePluginLists() const;
	MappedHostList & setSlavePluginLists( const QString & );
	QStringList sns() const;
	MappedHostList & setSns( const QString & );
	QStringList versions() const;
	MappedHostList & setVersions( const QString & );
	QList<double> dutyCycles() const;
	MappedHostList & setDutyCycles( const double & );
	QList<uint> memories() const;
	MappedHostList & setMemories( const uint & );
	QList<uint> mhzs() const;
	MappedHostList & setMhzs( const uint & );
	QList<int> onlines() const;
	MappedHostList & setOnlines( const int & );
	QList<uint> uids() const;
	MappedHostList & setUids( const uint & );
	QList<uint> virusCounts() const;
	MappedHostList & setVirusCounts( const uint & );
	QList<QDate> virusTimeStamps() const;
	MappedHostList & setVirusTimeStamps( const QDate & );
	MappedHostList backupHosts() const;
	MappedHostList & setBackupHosts( const Host & );
	QList<bool> allowMappings() const;
	MappedHostList & setAllowMappings( const bool & );
	QList<bool> allowSleeps() const;
	MappedHostList & setAllowSleeps( const bool & );
	QList<double> locationXs() const;
	MappedHostList & setLocationXs( const double & );
	QList<double> locationYs() const;
	MappedHostList & setLocationYs( const double & );
	QList<double> locationZs() const;
	MappedHostList & setLocationZs( const double & );
	MappedDiskImageList diskImages() const;
	MappedHostList & setDiskImages( const DiskImage & );
	QStringList bootActions() const;
	MappedHostList & setBootActions( const QString & );
	QStringList syncNames() const;
	MappedHostList & setSyncNames( const QString & );
	MappedLocationList locations() const;
	MappedHostList & setLocations( const Location & );
	QList<QDateTime> puppetPulses() const;
	MappedHostList & setPuppetPulses( const QDateTime & );
	QList<int> maxAssignments() const;
	MappedHostList & setMaxAssignments( const int & );
	MappedUserList users() const;
	MappedHostList & setUsers( const User & );
	MappedHostInterfaceList hostInterfaces();
	MappedHostLoadList hostLoads();
	MappedHostServiceList hostServices();
	MappedHostSoftwareList hostSoftwares();
	MappedHostStatusList hostStatuses();
	MappedJobAssignmentList jobAssignments();
	MappedJobHistoryList jobHistories();


};


