


%MappedType MappedAssetTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "assettypelist.h"
#include "assettypetable.h"
#define MappedAssetTypeList AssetTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AssetTypeSchema::instance() );
%End
};

class AssetTypeList : RecordList
{
%TypeHeaderCode
#include <assettypelist.h>
#include "elementtype.h"
#include "pathtemplate.h"
#include "assettemplate.h"

%End
public:
	AssetTypeList();
	AssetTypeList( const RecordList &, Table * t = 0 );
	AssetTypeList( const AssetTypeList & );
	AssetTypeList( const Record &, Table * t = 0 );
	
	~AssetTypeList();

//	void insert( AssetTypeIter, const AssetType & );

//	AssetTypeIter at( uint );

//	AssetTypeIter find( const Record & );

//	AssetTypeIter remove( const AssetTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//AssetTypeIter begin();

	//AssetTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAssetTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAssetTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAssetTypeList sorted( const QString & c, bool a = true ) const;

	MappedAssetTypeList unique() const;
	MappedAssetTypeList reversed() const;
	MappedAssetTypeList reloaded() const;

	QStringList names() const;
	MappedAssetTypeList & setNames( const QString & );
	QList<uint> hasDailies() const;
	MappedAssetTypeList & setHasDailies( const uint & );
	QList<int> disabled() const;
	MappedAssetTypeList & setDisabled( const int & );
	MappedElementTypeList elementTypes() const;
	MappedAssetTypeList & setElementTypes( const ElementType & );
	QList<bool> isTasks() const;
	MappedAssetTypeList & setIsTasks( const bool & );
	MappedPathTemplateList pathTemplates() const;
	MappedAssetTypeList & setPathTemplates( const PathTemplate & );
	QStringList nameRegExps() const;
	MappedAssetTypeList & setNameRegExps( const QString & );
	QList<bool> allowTimes() const;
	MappedAssetTypeList & setAllowTimes( const bool & );
	QStringList colors() const;
	MappedAssetTypeList & setColors( const QString & );
	QStringList descriptions() const;
	MappedAssetTypeList & setDescriptions( const QString & );
	QStringList sortColumns() const;
	MappedAssetTypeList & setSortColumns( const QString & );
	QStringList tagses() const;
	MappedAssetTypeList & setTagses( const QString & );
	QList<int> sortNumbers() const;
	MappedAssetTypeList & setSortNumbers( const int & );
	MappedAssetTemplateList assetTemplates();


};


