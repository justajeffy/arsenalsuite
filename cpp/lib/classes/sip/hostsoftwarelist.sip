


%MappedType MappedHostSoftwareList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostsoftwarelist.h"
#include "hostsoftwaretable.h"
#define MappedHostSoftwareList HostSoftwareList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostSoftwareSchema::instance() );
%End
};

class HostSoftwareList : RecordList
{
%TypeHeaderCode
#include <hostsoftwarelist.h>
#include "host.h"
#include "software.h"

%End
public:
	HostSoftwareList();
	HostSoftwareList( const RecordList &, Table * t = 0 );
	HostSoftwareList( const HostSoftwareList & );
	HostSoftwareList( const Record &, Table * t = 0 );
	
	~HostSoftwareList();

//	void insert( HostSoftwareIter, const HostSoftware & );

//	HostSoftwareIter at( uint );

//	HostSoftwareIter find( const Record & );

//	HostSoftwareIter remove( const HostSoftwareIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostSoftwareIter begin();

	//HostSoftwareIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostSoftwareList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostSoftwareList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostSoftwareList sorted( const QString & c, bool a = true ) const;

	MappedHostSoftwareList unique() const;
	MappedHostSoftwareList reversed() const;
	MappedHostSoftwareList reloaded() const;

	MappedHostList hosts() const;
	MappedHostSoftwareList & setHosts( const Host & );
	MappedSoftwareList softwares() const;
	MappedHostSoftwareList & setSoftwares( const Software & );


};


