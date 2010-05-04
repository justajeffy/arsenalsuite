
%MappedType MappedUserElement
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "userelementlist.h"
#include "userelementtable.h"
#define MappedUserElement UserElement
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new UserElement(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, UserElementSchema::instance() );
%End
};

class UserElement : Record
{
%TypeHeaderCode
#include <userelement.h>
#include "user.h"
#include "element.h"

%End
public:
	UserElement();

	UserElement( uint key );

	UserElement( const UserElement & other );

	UserElement( const Record & r );

	UserElement( RecordImp * imp, bool checkType = true );
	
	MappedUserElement copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedUser user() const;
	MappedUserElement & setUser( const User & );
	MappedElement element() const;
	MappedUserElement & setElement( const Element & );


	static MappedUserElementList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedUserElement reload( bool lockForUpdate = false );

	static MappedUserElementList recordsByUser( const User &fkeyUser );






	static Table * table();
	//static UserElementSchema * schema();
};


