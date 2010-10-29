
%MappedType MappedAssetGroup
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetgrouplist.h"
#include "assetgrouptable.h"
#define MappedAssetGroup AssetGroup
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new AssetGroup(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AssetGroupSchema::instance() );
%End
};

class AssetGroup : Element
{
%TypeHeaderCode
#include <assetgroup.h>

%End
public:
	AssetGroup();

	AssetGroup( uint key );

	AssetGroup( const AssetGroup & other );

	AssetGroup( const Record & r );

	AssetGroup( RecordImp * imp, bool checkType = true );
	
	MappedAssetGroup copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End



	static MappedAssetGroupList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAssetGroup reload( bool lockForUpdate = false );



	static ElementType type();




	static Table * table();
	//static AssetGroupSchema * schema();
};


