


%MappedType MappedAssetList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetlist.h"
#include "assettable.h"
#define MappedAssetList AssetList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AssetSchema::instance() );
%End
};

class AssetList : ElementList
{
%TypeHeaderCode
#include <assetlist.h>

%End
public:
	AssetList();
	AssetList( const RecordList &, Table * t = 0 );
	AssetList( const AssetList & );
	AssetList( const Record &, Table * t = 0 );
	
	~AssetList();

//	void insert( AssetIter, const Asset & );

//	AssetIter at( uint );

//	AssetIter find( const Record & );

//	AssetIter remove( const AssetIter & );

	int remove( const Record & );
	
	int remove();
	
	//AssetIter begin();

	//AssetIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAssetList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAssetList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAssetList sorted( const QString & c, bool a = true ) const;

	MappedAssetList unique() const;
	MappedAssetList reversed() const;
	MappedAssetList reloaded() const;



};


