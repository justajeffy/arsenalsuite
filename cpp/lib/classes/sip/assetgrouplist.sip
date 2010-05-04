


%MappedType MappedAssetGroupList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetgrouplist.h"
#include "assetgrouptable.h"
#define MappedAssetGroupList AssetGroupList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AssetGroupSchema::instance() );
%End
};

class AssetGroupList : ElementList
{
%TypeHeaderCode
#include <assetgrouplist.h>

%End
public:
	AssetGroupList();
	AssetGroupList( const RecordList &, Table * t = 0 );
	AssetGroupList( const AssetGroupList & );
	AssetGroupList( const Record &, Table * t = 0 );
	
	~AssetGroupList();

//	void insert( AssetGroupIter, const AssetGroup & );

//	AssetGroupIter at( uint );

//	AssetGroupIter find( const Record & );

//	AssetGroupIter remove( const AssetGroupIter & );

	int remove( const Record & );
	
	int remove();
	
	//AssetGroupIter begin();

	//AssetGroupIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAssetGroupList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAssetGroupList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAssetGroupList sorted( const QString & c, bool a = true ) const;

	MappedAssetGroupList unique() const;
	MappedAssetGroupList reversed() const;
	MappedAssetGroupList reloaded() const;



};


