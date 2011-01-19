
%MappedType MappedCheckListItem
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "checklistitemlist.h"
#include "checklistitemtable.h"
#define MappedCheckListItem CheckListItem
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new CheckListItem(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, CheckListItemSchema::instance() );
%End
};

class CheckListItem : Record
{
%TypeHeaderCode
#include <checklistitem.h>
#include "project.h"
#include "thumbnail.h"
#include "assettype.h"
#include "statusset.h"

%End
public:
	CheckListItem();

	CheckListItem( uint key );

	CheckListItem( const CheckListItem & other );

	CheckListItem( const Record & r );

	CheckListItem( RecordImp * imp, bool checkType = true );
	
	MappedCheckListItem copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString body() const;
	MappedCheckListItem & setBody( const QString & );
	QString name() const;
	MappedCheckListItem & setName( const QString & );
	MappedProject project() const;
	MappedCheckListItem & setProject( const Project & );
	MappedThumbnail thumbnail() const;
	MappedCheckListItem & setThumbnail( const Thumbnail & );
	MappedAssetType assetType() const;
	MappedCheckListItem & setAssetType( const AssetType & );
	MappedStatusSet statusSet() const;
	MappedCheckListItem & setStatusSet( const StatusSet & );


	static MappedCheckListItemList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedCheckListItem reload( bool lockForUpdate = false );

	static MappedCheckListItemList recordsByProject( const Project &fkeyProject );
	static MappedCheckListItemList recordsByAssetTypeAndProject( const AssetType &fkeyTimesheetCategory, const Project &fkeyProject );





	MappedRecord status( const Element & ) const;

	void setStatus( const Element &, const ElementStatus & ) const;

	QString statusString( const Element & ) const;

	static QString summary( const Element & );

/*	static CheckListItemList list( const Element & );

	static CheckListItemList defaults( const TaskType &, const Project & p= Project() );

	static void setDefaults( CheckListItemList items, const TaskType &, const Project & p= Project() );

*/




	static Table * table();
	//static CheckListItemSchema * schema();
};


