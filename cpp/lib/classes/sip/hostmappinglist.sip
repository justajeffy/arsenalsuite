


%MappedType MappedHostMappingList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostmappinglist.h"
#include "hostmappingtable.h"
#define MappedHostMappingList HostMappingList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostMappingSchema::instance() );
%End
};

class HostMappingList : RecordList
{
%TypeHeaderCode
#include <hostmappinglist.h>
#include "host.h"
#include "mapping.h"

%End
public:
	HostMappingList();
	HostMappingList( const RecordList &, Table * t = 0 );
	HostMappingList( const HostMappingList & );
	HostMappingList( const Record &, Table * t = 0 );
	
	~HostMappingList();

//	void insert( HostMappingIter, const HostMapping & );

//	HostMappingIter at( uint );

//	HostMappingIter find( const Record & );

//	HostMappingIter remove( const HostMappingIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostMappingIter begin();

	//HostMappingIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostMappingList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostMappingList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostMappingList sorted( const QString & c, bool a = true ) const;

	MappedHostMappingList unique() const;
	MappedHostMappingList reversed() const;
	MappedHostMappingList reloaded() const;

	MappedHostList hosts() const;
	MappedHostMappingList & setHosts( const Host & );
	MappedMappingList mappings() const;
	MappedHostMappingList & setMappings( const Mapping & );


};


