


%MappedType MappedUserGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "usergrouplist.h"
#include "usergrouptable.h"
#define MappedUserGroupList UserGroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, UserGroupSchema::instance() );
%End
};

class UserGroupList : RecordList
{
%TypeHeaderCode
#include <usergrouplist.h>
#include "user.h"
#include "group.h"

%End
public:
	UserGroupList();
	UserGroupList( const RecordList &, Table * t = 0 );
	UserGroupList( const UserGroupList & );
	UserGroupList( const Record &, Table * t = 0 );
	
	~UserGroupList();

//	void insert( UserGroupIter, const UserGroup & );

//	UserGroupIter at( uint );

//	UserGroupIter find( const Record & );

//	UserGroupIter remove( const UserGroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//UserGroupIter begin();

	//UserGroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedUserGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedUserGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedUserGroupList sorted( const QString & c, bool a = true ) const;

	MappedUserGroupList unique() const;
	MappedUserGroupList reversed() const;
	MappedUserGroupList reloaded() const;

	MappedUserList users() const;
	MappedUserGroupList & setUsers( const User & );
	MappedGroupList groups() const;
	MappedUserGroupList & setGroups( const Group & );


};


