


%MappedType MappedHostInterfaceList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostinterfacelist.h"
#include "hostinterfacetable.h"
#define MappedHostInterfaceList HostInterfaceList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostInterfaceSchema::instance() );
%End
};

class HostInterfaceList : RecordList
{
%TypeHeaderCode
#include <hostinterfacelist.h>
#include "host.h"
#include "hostinterfacetype.h"

%End
public:
	HostInterfaceList();
	HostInterfaceList( const RecordList &, Table * t = 0 );
	HostInterfaceList( const HostInterfaceList & );
	HostInterfaceList( const Record &, Table * t = 0 );
	
	~HostInterfaceList();

//	void insert( HostInterfaceIter, const HostInterface & );

//	HostInterfaceIter at( uint );

//	HostInterfaceIter find( const Record & );

//	HostInterfaceIter remove( const HostInterfaceIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostInterfaceIter begin();

	//HostInterfaceIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostInterfaceList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostInterfaceList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostInterfaceList sorted( const QString & c, bool a = true ) const;

	MappedHostInterfaceList unique() const;
	MappedHostInterfaceList reversed() const;
	MappedHostInterfaceList reloaded() const;

	MappedHostList hosts() const;
	MappedHostInterfaceList & setHosts( const Host & );
	QStringList macs() const;
	MappedHostInterfaceList & setMacs( const QString & );
	QStringList ips() const;
	MappedHostInterfaceList & setIps( const QString & );
	MappedHostInterfaceTypeList types() const;
	MappedHostInterfaceList & setTypes( const HostInterfaceType & );
	QList<int> switchPorts() const;
	MappedHostInterfaceList & setSwitchPorts( const int & );


};


