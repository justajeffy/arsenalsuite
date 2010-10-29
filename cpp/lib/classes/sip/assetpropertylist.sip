


%MappedType MappedAssetPropertyList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assetpropertylist.h"
#include "assetpropertytable.h"
#define MappedAssetPropertyList AssetPropertyList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AssetPropertySchema::instance() );
%End
};

class AssetPropertyList : RecordList
{
%TypeHeaderCode
#include <assetpropertylist.h>
#include "element.h"

%End
public:
	AssetPropertyList();
	AssetPropertyList( const RecordList &, Table * t = 0 );
	AssetPropertyList( const AssetPropertyList & );
	AssetPropertyList( const Record &, Table * t = 0 );
	
	~AssetPropertyList();

//	void insert( AssetPropertyIter, const AssetProperty & );

//	AssetPropertyIter at( uint );

//	AssetPropertyIter find( const Record & );

//	AssetPropertyIter remove( const AssetPropertyIter & );

	int remove( const Record & );
	
	int remove();
	
	//AssetPropertyIter begin();

	//AssetPropertyIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAssetPropertyList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAssetPropertyList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAssetPropertyList sorted( const QString & c, bool a = true ) const;

	MappedAssetPropertyList unique() const;
	MappedAssetPropertyList reversed() const;
	MappedAssetPropertyList reloaded() const;

	QStringList names() const;
	MappedAssetPropertyList & setNames( const QString & );
	QList<int> types() const;
	MappedAssetPropertyList & setTypes( const int & );
	QStringList values() const;
	MappedAssetPropertyList & setValues( const QString & );
	MappedElementList elements() const;
	MappedAssetPropertyList & setElements( const Element & );


};


