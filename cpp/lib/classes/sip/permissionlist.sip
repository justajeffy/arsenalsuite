


%MappedType MappedPermissionList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "permissionlist.h"
#include "permissiontable.h"
#define MappedPermissionList PermissionList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, PermissionSchema::instance() );
%End
};

class PermissionList : RecordList
{
%TypeHeaderCode
#include <permissionlist.h>
#include "user.h"
#include "group.h"

%End
public:
	PermissionList();
	PermissionList( const RecordList &, Table * t = 0 );
	PermissionList( const PermissionList & );
	PermissionList( const Record &, Table * t = 0 );
	
	~PermissionList();

//	void insert( PermissionIter, const Permission & );

//	PermissionIter at( uint );

//	PermissionIter find( const Record & );

//	PermissionIter remove( const PermissionIter & );

	int remove( const Record & );
	
	int remove();
	
	//PermissionIter begin();

	//PermissionIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedPermissionList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedPermissionList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedPermissionList sorted( const QString & c, bool a = true ) const;

	MappedPermissionList unique() const;
	MappedPermissionList reversed() const;
	MappedPermissionList reloaded() const;

	QStringList methodPatterns() const;
	MappedPermissionList & setMethodPatterns( const QString & );
	MappedUserList users() const;
	MappedPermissionList & setUsers( const User & );
	QStringList permissions() const;
	MappedPermissionList & setPermissions( const QString & );
	MappedGroupList groups() const;
	MappedPermissionList & setGroups( const Group & );
	QStringList _classes() const;
	MappedPermissionList & set_classes( const QString & );


};


