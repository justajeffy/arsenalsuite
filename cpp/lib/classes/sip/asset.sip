
%MappedType MappedAsset
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetlist.h"
#include "assettable.h"
#define MappedAsset Asset
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Asset(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AssetSchema::instance() );
%End
};

class Asset : Element
{
%TypeHeaderCode
#include <asset.h>

%End
public:
	Asset();

	Asset( uint key );

	Asset( const Asset & other );

	Asset( const Record & r );

	Asset( RecordImp * imp, bool checkType = true );
	
	MappedAsset copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedAssetList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAsset reload( bool lockForUpdate = false );

	static MappedAsset recordByProjectAndName( const Project &fkeyProject, const QString &name );


	static ElementType type();




	static Table * table();
	//static AssetSchema * schema();
};


