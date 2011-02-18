


%MappedType MappedHostGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostgrouplist.h"
#include "hostgrouptable.h"
#define MappedHostGroupList HostGroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostGroupSchema::instance() );
%End
};

class HostGroupList : RecordList
{
%TypeHeaderCode
#include <hostgrouplist.h>
#include "user.h"
#include "hostgroupitem.h"

%End
public:
	HostGroupList();
	HostGroupList( const RecordList &, Table * t = 0 );
	HostGroupList( const HostGroupList & );
	HostGroupList( const Record &, Table * t = 0 );
	
	~HostGroupList();

//	void insert( HostGroupIter, const HostGroup & );

//	HostGroupIter at( uint );

//	HostGroupIter find( const Record & );

//	HostGroupIter remove( const HostGroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostGroupIter begin();

	//HostGroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostGroupList sorted( const QString & c, bool a = true ) const;

	MappedHostGroupList unique() const;
	MappedHostGroupList reversed() const;
	MappedHostGroupList reloaded() const;

	QStringList names() const;
	MappedHostGroupList & setNames( const QString & );
	MappedUserList users() const;
	MappedHostGroupList & setUsers( const User & );
	QList<bool> private_s() const;
	MappedHostGroupList & setPrivate_s( const bool & );
	MappedHostGroupItemList hostGroupItems();


};


