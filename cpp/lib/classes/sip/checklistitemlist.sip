


%MappedType MappedCheckListItemList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "checklistitemlist.h"
#include "checklistitemtable.h"
#define MappedCheckListItemList CheckListItemList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, CheckListItemSchema::instance() );
%End
};

class CheckListItemList : RecordList
{
%TypeHeaderCode
#include <checklistitemlist.h>
#include "project.h"
#include "thumbnail.h"
#include "assettype.h"
#include "statusset.h"

%End
public:
	CheckListItemList();
	CheckListItemList( const RecordList &, Table * t = 0 );
	CheckListItemList( const CheckListItemList & );
	CheckListItemList( const Record &, Table * t = 0 );
	
	~CheckListItemList();

//	void insert( CheckListItemIter, const CheckListItem & );

//	CheckListItemIter at( uint );

//	CheckListItemIter find( const Record & );

//	CheckListItemIter remove( const CheckListItemIter & );

	int remove( const Record & );
	
	int remove();
	
	//CheckListItemIter begin();

	//CheckListItemIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedCheckListItemList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedCheckListItemList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedCheckListItemList sorted( const QString & c, bool a = true ) const;

	MappedCheckListItemList unique() const;
	MappedCheckListItemList reversed() const;
	MappedCheckListItemList reloaded() const;

	QStringList bodies() const;
	MappedCheckListItemList & setBodies( const QString & );
	QStringList names() const;
	MappedCheckListItemList & setNames( const QString & );
	MappedProjectList projects() const;
	MappedCheckListItemList & setProjects( const Project & );
	MappedThumbnailList thumbnails() const;
	MappedCheckListItemList & setThumbnails( const Thumbnail & );
	MappedAssetTypeList assetTypes() const;
	MappedCheckListItemList & setAssetTypes( const AssetType & );
	MappedStatusSetList statusSets() const;
	MappedCheckListItemList & setStatusSets( const StatusSet & );


};


