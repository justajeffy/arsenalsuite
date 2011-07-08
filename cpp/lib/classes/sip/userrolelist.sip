


%MappedType MappedUserRoleList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userrolelist.h"
#include "userroletable.h"
#define MappedUserRoleList UserRoleList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, UserRoleSchema::instance() );
%End
};

class UserRoleList : RecordList
{
%TypeHeaderCode
#include <userrolelist.h>
#include "assettype.h"
#include "user.h"

%End
public:
	UserRoleList();
	UserRoleList( const RecordList &, Table * t = 0 );
	UserRoleList( const UserRoleList & );
	UserRoleList( const Record &, Table * t = 0 );
	
	~UserRoleList();

//	void insert( UserRoleIter, const UserRole & );

//	UserRoleIter at( uint );

//	UserRoleIter find( const Record & );

//	UserRoleIter remove( const UserRoleIter & );

	int remove( const Record & );
	
	int remove();
	
	//UserRoleIter begin();

	//UserRoleIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedUserRoleList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedUserRoleList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedUserRoleList sorted( const QString & c, bool a = true ) const;

	MappedUserRoleList unique() const;
	MappedUserRoleList reversed() const;
	MappedUserRoleList reloaded() const;

	MappedAssetTypeList assetTypes() const;
	MappedUserRoleList & setAssetTypes( const AssetType & );
	MappedUserList users() const;
	MappedUserRoleList & setUsers( const User & );


};


