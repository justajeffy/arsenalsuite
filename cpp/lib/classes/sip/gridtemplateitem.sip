
%MappedType MappedGridTemplateItem
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gridtemplateitemlist.h"
#include "gridtemplateitemtable.h"
#define MappedGridTemplateItem GridTemplateItem
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GridTemplateItem(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GridTemplateItemSchema::instance() );
%End
};

class GridTemplateItem : Record
{
%TypeHeaderCode
#include <gridtemplateitem.h>
#include "gridtemplate.h"
#include "assettype.h"

%End
public:
	GridTemplateItem();

	GridTemplateItem( uint key );

	GridTemplateItem( const GridTemplateItem & other );

	GridTemplateItem( const Record & r );

	GridTemplateItem( RecordImp * imp, bool checkType = true );
	
	MappedGridTemplateItem copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedGridTemplate gridTemplate() const;
	MappedGridTemplateItem & setGridTemplate( const GridTemplate & );
	MappedAssetType assetType() const;
	MappedGridTemplateItem & setAssetType( const AssetType & );
	QString checkListItemsString() const;
	MappedGridTemplateItem & setCheckListItemsString( const QString & );
	uint columnType() const;
	MappedGridTemplateItem & setColumnType( const uint & );
	QString headerName() const;
	MappedGridTemplateItem & setHeaderName( const QString & );
	uint position() const;
	MappedGridTemplateItem & setPosition( const uint & );


	static MappedGridTemplateItemList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGridTemplateItem reload( bool lockForUpdate = false );

	static MappedGridTemplateItemList recordsByGridTemplate( const GridTemplate &fkeyGridTemplate );






	enum {
		Status 				= 1,
		AssignedUsers 		= 2,
		CheckListSummary 	= 4,
		FileName 			= 8,
		DaysBid 			= 16,
		DaysEstimated 		= 32,
		DaysScheduled 		= 64,
		DaysSpentActual 	= 128,
		DaysSpent8Hour 		= 256,
		Dependencies		= 512
	};

	MappedRecordList checkListItems() const;
	void setCheckListItems( CheckListItemList );
	QString textFromElement( const Element & ) const;
	//QColor colorFromElement( const Element & ) const;
	




	static Table * table();
	//static GridTemplateItemSchema * schema();
};


