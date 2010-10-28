
%MappedType MappedUserGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "usergrouplist.h"
#include "usergrouptable.h"
#define MappedUserGroup UserGroup
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new UserGroup(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, UserGroupSchema::instance() );
%End
};

class UserGroup : Record
{
%TypeHeaderCode
#include <usergroup.h>
#include "user.h"
#include "group.h"

%End
public:
	UserGroup();

	UserGroup( uint key );

	UserGroup( const UserGroup & other );

	UserGroup( const Record & r );

	UserGroup( RecordImp * imp, bool checkType = true );
	
	MappedUserGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedUser user() const;
	MappedUserGroup & setUser( const User & );
	MappedGroup group() const;
	MappedUserGroup & setGroup( const Group & );


	static MappedUserGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedUserGroup reload( bool lockForUpdate = false );

	static MappedUserGroupList recordsByUser( const User &fkeyusr );
	static MappedUserGroupList recordsByGroup( const Group &fkeygrp );
	static MappedUserGroup recordByUserAndGroup( const User &fkeyusr, const Group &fkeygrp );






	static Table * table();
	//static UserGroupSchema * schema();
};


