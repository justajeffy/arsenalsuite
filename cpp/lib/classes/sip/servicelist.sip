


%MappedType MappedServiceList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "servicelist.h"
#include "servicetable.h"
#define MappedServiceList ServiceList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ServiceSchema::instance() );
%End
};

class ServiceList : RecordList
{
%TypeHeaderCode
#include <servicelist.h>
#include "license.h"
#include "software.h"
#include "hostservice.h"
#include "jobtype.h"

%End
public:
	ServiceList();
	ServiceList( const RecordList &, Table * t = 0 );
	ServiceList( const ServiceList & );
	ServiceList( const Record &, Table * t = 0 );
	
	~ServiceList();

//	void insert( ServiceIter, const Service & );

//	ServiceIter at( uint );

//	ServiceIter find( const Record & );

//	ServiceIter remove( const ServiceIter & );

	int remove( const Record & );
	
	int remove();
	
	//ServiceIter begin();

	//ServiceIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedServiceList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedServiceList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedServiceList sorted( const QString & c, bool a = true ) const;

	MappedServiceList unique() const;
	MappedServiceList reversed() const;
	MappedServiceList reloaded() const;

	QStringList services() const;
	MappedServiceList & setServices( const QString & );
	MappedLicenseList licenses() const;
	MappedServiceList & setLicenses( const License & );
	QList<bool> enabled() const;
	MappedServiceList & setEnabled( const bool & );
	QStringList forbiddenProcesses() const;
	MappedServiceList & setForbiddenProcesses( const QString & );
	QList<bool> actives() const;
	MappedServiceList & setActives( const bool & );
	QList<bool> uniques() const;
	MappedServiceList & setUniques( const bool & );
	QStringList descriptions() const;
	MappedServiceList & setDescriptions( const QString & );
	MappedSoftwareList software() const;
	MappedServiceList & setSoftware( const Software & );
	MappedHostServiceList hostServices();
	MappedJobTypeList jobTypes();


};


