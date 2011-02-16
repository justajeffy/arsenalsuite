
%MappedType MappedUserMapping
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "usermappinglist.h"
#include "usermappingtable.h"
#define MappedUserMapping UserMapping
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new UserMapping(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, UserMappingSchema::instance() );
%End
};

class UserMapping : Record
{
%TypeHeaderCode
#include <usermapping.h>
#include "user.h"
#include "mapping.h"

%End
public:
	UserMapping();

	UserMapping( uint key );

	UserMapping( const UserMapping & other );

	UserMapping( const Record & r );

	UserMapping( RecordImp * imp, bool checkType = true );
	
	MappedUserMapping copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedUser user() const;
	MappedUserMapping & setUser( const User & );
	MappedMapping mapping() const;
	MappedUserMapping & setMapping( const Mapping & );


	static MappedUserMappingList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedUserMapping reload( bool lockForUpdate = false );

	static MappedUserMappingList recordsByuser( const User &fkeyUsr );






	static Table * table();
	//static UserMappingSchema * schema();
};


