


%MappedType MappedGridTemplateItemList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gridtemplateitemlist.h"
#include "gridtemplateitemtable.h"
#define MappedGridTemplateItemList GridTemplateItemList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, GridTemplateItemSchema::instance() );
%End
};

class GridTemplateItemList : RecordList
{
%TypeHeaderCode
#include <gridtemplateitemlist.h>
#include "gridtemplate.h"
#include "assettype.h"

%End
public:
	GridTemplateItemList();
	GridTemplateItemList( const RecordList &, Table * t = 0 );
	GridTemplateItemList( const GridTemplateItemList & );
	GridTemplateItemList( const Record &, Table * t = 0 );
	
	~GridTemplateItemList();

//	void insert( GridTemplateItemIter, const GridTemplateItem & );

//	GridTemplateItemIter at( uint );

//	GridTemplateItemIter find( const Record & );

//	GridTemplateItemIter remove( const GridTemplateItemIter & );

	int remove( const Record & );
	
	int remove();
	
	//GridTemplateItemIter begin();

	//GridTemplateItemIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedGridTemplateItemList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedGridTemplateItemList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedGridTemplateItemList sorted( const QString & c, bool a = true ) const;

	MappedGridTemplateItemList unique() const;
	MappedGridTemplateItemList reversed() const;
	MappedGridTemplateItemList reloaded() const;

	MappedGridTemplateList gridTemplates() const;
	MappedGridTemplateItemList & setGridTemplates( const GridTemplate & );
	MappedAssetTypeList assetTypes() const;
	MappedGridTemplateItemList & setAssetTypes( const AssetType & );
	QStringList checkListItemsStrings() const;
	MappedGridTemplateItemList & setCheckListItemsStrings( const QString & );
	QList<uint> columnTypes() const;
	MappedGridTemplateItemList & setColumnTypes( const uint & );
	QStringList headerNames() const;
	MappedGridTemplateItemList & setHeaderNames( const QString & );
	QList<uint> positions() const;
	MappedGridTemplateItemList & setPositions( const uint & );


};


