
%MappedType MappedElementUser
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "elementuserlist.h"
#include "elementusertable.h"
#define MappedElementUser ElementUser
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ElementUser(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ElementUserSchema::instance() );
%End
};

class ElementUser : Record
{
%TypeHeaderCode
#include <elementuser.h>
#include "element.h"
#include "user.h"
#include "assettype.h"

%End
public:
	ElementUser();

	ElementUser( uint key );

	ElementUser( const ElementUser & other );

	ElementUser( const Record & r );

	ElementUser( RecordImp * imp, bool checkType = true );
	
	MappedElementUser copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedElementUser & setElement( const Element & );
	MappedUser user() const;
	MappedElementUser & setUser( const User & );
	bool active() const;
	MappedElementUser & setActive( const bool & );
	MappedAssetType assetType() const;
	MappedElementUser & setAssetType( const AssetType & );


	static MappedElementUserList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedElementUser reload( bool lockForUpdate = false );

	static MappedElementUserList recordsByElement( const Element &fkeyElement );
	static MappedElementUserList recordsByUser( const User &fkeyUser );






	static Table * table();
	//static ElementUserSchema * schema();
};


