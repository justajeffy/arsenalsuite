


%MappedType MappedHostGroupItemList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostgroupitemlist.h"
#include "hostgroupitemtable.h"
#define MappedHostGroupItemList HostGroupItemList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostGroupItemSchema::instance() );
%End
};

class HostGroupItemList : RecordList
{
%TypeHeaderCode
#include <hostgroupitemlist.h>
#include "hostgroup.h"
#include "host.h"

%End
public:
	HostGroupItemList();
	HostGroupItemList( const RecordList &, Table * t = 0 );
	HostGroupItemList( const HostGroupItemList & );
	HostGroupItemList( const Record &, Table * t = 0 );
	
	~HostGroupItemList();

//	void insert( HostGroupItemIter, const HostGroupItem & );

//	HostGroupItemIter at( uint );

//	HostGroupItemIter find( const Record & );

//	HostGroupItemIter remove( const HostGroupItemIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostGroupItemIter begin();

	//HostGroupItemIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostGroupItemList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostGroupItemList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostGroupItemList sorted( const QString & c, bool a = true ) const;

	MappedHostGroupItemList unique() const;
	MappedHostGroupItemList reversed() const;
	MappedHostGroupItemList reloaded() const;

	MappedHostGroupList hostGroups() const;
	MappedHostGroupItemList & setHostGroups( const HostGroup & );
	MappedHostList hosts() const;
	MappedHostGroupItemList & setHosts( const Host & );


};


