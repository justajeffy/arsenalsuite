
%MappedType MappedAssetProperty
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetpropertylist.h"
#include "assetpropertytable.h"
#define MappedAssetProperty AssetProperty
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new AssetProperty(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AssetPropertySchema::instance() );
%End
};

class AssetProperty : Record
{
%TypeHeaderCode
#include <assetproperty.h>
#include "element.h"

%End
public:
	AssetProperty();

	AssetProperty( uint key );

	AssetProperty( const AssetProperty & other );

	AssetProperty( const Record & r );

	AssetProperty( RecordImp * imp, bool checkType = true );
	
	MappedAssetProperty copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedAssetProperty & setName( const QString & );
	int type() const;
	MappedAssetProperty & setType( const int & );
	QString value() const;
	MappedAssetProperty & setValue( const QString & );
	MappedElement element() const;
	MappedAssetProperty & setElement( const Element & );


	static MappedAssetPropertyList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAssetProperty reload( bool lockForUpdate = false );

	static MappedAssetPropertyList recordsByElement( const Element &fkeyElement );
	static MappedAssetProperty recordByElementAndName( const Element &fkeyElement, const QString &name );






	static Table * table();
	//static AssetPropertySchema * schema();
};


