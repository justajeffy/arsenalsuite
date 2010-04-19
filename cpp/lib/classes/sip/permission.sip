
%MappedType MappedPermission
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "permissionlist.h"
#include "permissiontable.h"
#define MappedPermission Permission
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Permission(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, PermissionSchema::instance() );
%End
};

class Permission : Record
{
%TypeHeaderCode
#include <permission.h>
#include "user.h"
#include "group.h"

%End
public:
	Permission();

	Permission( uint key );

	Permission( const Permission & other );

	Permission( const Record & r );

	Permission( RecordImp * imp, bool checkType = true );
	
	MappedPermission copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString methodPattern() const;
	MappedPermission & setMethodPattern( const QString & );
	MappedUser user() const;
	MappedPermission & setUser( const User & );
	QString permission() const;
	MappedPermission & setPermission( const QString & );
	MappedGroup group() const;
	MappedPermission & setGroup( const Group & );
	QString _class() const;
	MappedPermission & set_class( const QString & );


	static MappedPermissionList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedPermission reload( bool lockForUpdate = false );







	static Table * table();
	//static PermissionSchema * schema();
};


