
%MappedType MappedUserRole
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userrolelist.h"
#include "userroletable.h"
#define MappedUserRole UserRole
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new UserRole(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, UserRoleSchema::instance() );
%End
};

class UserRole : Record
{
%TypeHeaderCode
#include <userrole.h>
#include "assettype.h"
#include "user.h"

%End
public:
	UserRole();

	UserRole( uint key );

	UserRole( const UserRole & other );

	UserRole( const Record & r );

	UserRole( RecordImp * imp, bool checkType = true );
	
	MappedUserRole copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedAssetType assetType() const;
	MappedUserRole & setAssetType( const AssetType & );
	MappedUser user() const;
	MappedUserRole & setUser( const User & );


	static MappedUserRoleList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedUserRole reload( bool lockForUpdate = false );

	static MappedUserRoleList recordsByAssetType( const AssetType &fkeyTaskType );
	static MappedUserRoleList recordsByUser( const User &fkeyUsr );






	static Table * table();
	//static UserRoleSchema * schema();
};


