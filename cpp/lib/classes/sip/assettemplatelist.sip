


%MappedType MappedAssetTemplateList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assettemplatelist.h"
#include "assettemplatetable.h"
#define MappedAssetTemplateList AssetTemplateList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AssetTemplateSchema::instance() );
%End
};

class AssetTemplateList : RecordList
{
%TypeHeaderCode
#include <assettemplatelist.h>
#include "element.h"
#include "assettype.h"
#include "project.h"

%End
public:
	AssetTemplateList();
	AssetTemplateList( const RecordList &, Table * t = 0 );
	AssetTemplateList( const AssetTemplateList & );
	AssetTemplateList( const Record &, Table * t = 0 );
	
	~AssetTemplateList();

//	void insert( AssetTemplateIter, const AssetTemplate & );

//	AssetTemplateIter at( uint );

//	AssetTemplateIter find( const Record & );

//	AssetTemplateIter remove( const AssetTemplateIter & );

	int remove( const Record & );
	
	int remove();
	
	//AssetTemplateIter begin();

	//AssetTemplateIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAssetTemplateList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAssetTemplateList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAssetTemplateList sorted( const QString & c, bool a = true ) const;

	MappedAssetTemplateList unique() const;
	MappedAssetTemplateList reversed() const;
	MappedAssetTemplateList reloaded() const;

	MappedElementList elements() const;
	MappedAssetTemplateList & setElements( const Element & );
	MappedAssetTypeList assetTypes() const;
	MappedAssetTemplateList & setAssetTypes( const AssetType & );
	MappedProjectList projects() const;
	MappedAssetTemplateList & setProjects( const Project & );
	QStringList names() const;
	MappedAssetTemplateList & setNames( const QString & );


};


