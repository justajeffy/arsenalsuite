
%MappedType MappedService
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "servicelist.h"
#include "servicetable.h"
#define MappedService Service
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Service(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ServiceSchema::instance() );
%End
};

class Service : Record
{
%TypeHeaderCode
#include <service.h>
#include "license.h"
#include "software.h"
#include "hostservice.h"
#include "jobtype.h"

%End
public:
	Service();

	Service( uint key );

	Service( const Service & other );

	Service( const Record & r );

	Service( RecordImp * imp, bool checkType = true );
	
	MappedService copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString service() const;
	MappedService & setService( const QString & );
	MappedLicense license() const;
	MappedService & setLicense( const License & );
	bool enabled() const;
	MappedService & setEnabled( const bool & );
	/**
	  * comma seperated list of process names that can't be running for AB to start up, or pick up a job.
	  **/
	QString forbiddenProcesses() const;
	MappedService & setForbiddenProcesses( const QString & );
	/**
	  * This describes if the service is and active or passive service.  Active services are running and are expected to pulse.
	  **/
	bool active() const;
	MappedService & setActive( const bool & );
	/**
	  * This describes if this service should only be enabled on a single host at any given time.
	  **/
	bool unique() const;
	MappedService & setUnique( const bool & );
	QString description() const;
	MappedService & setDescription( const QString & );
	MappedSoftware software() const;
	MappedService & setSoftware( const Software & );
	MappedHostServiceList hostServices() const;
	MappedJobTypeList jobTypes() const;


	static MappedServiceList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedService reload( bool lockForUpdate = false );

	static MappedService recordByName( const QString &service );






	bool pulse( bool autoCreate = true );

	static MappedService ensureServiceExists( const QString & name );

	MappedHostService byHost( const Host & host = Host::currentHost(), bool create = true );


	static Table * table();
	//static ServiceSchema * schema();
};


