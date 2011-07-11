
%MappedType MappedCheckListStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "checkliststatuslist.h"
#include "checkliststatustable.h"
#define MappedCheckListStatus CheckListStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new CheckListStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, CheckListStatusSchema::instance() );
%End
};

class CheckListStatus : Record
{
%TypeHeaderCode
#include <checkliststatus.h>
#include "checklistitem.h"
#include "element.h"
#include "elementstatus.h"

%End
public:
	CheckListStatus();

	CheckListStatus( uint key );

	CheckListStatus( const CheckListStatus & other );

	CheckListStatus( const Record & r );

	CheckListStatus( RecordImp * imp, bool checkType = true );
	
	MappedCheckListStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedCheckListItem checkListItem() const;
	MappedCheckListStatus & setCheckListItem( const CheckListItem & );
	MappedElement element() const;
	MappedCheckListStatus & setElement( const Element & );
	MappedElementStatus status() const;
	MappedCheckListStatus & setStatus( const ElementStatus & );


	static MappedCheckListStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedCheckListStatus reload( bool lockForUpdate = false );

	static MappedCheckListStatusList recordsByCheckListItem( const CheckListItem &fkeyCheckListItem );
	static MappedCheckListStatus recordByElementAndItem( const Element &fkeyElement, const CheckListItem &fkeyCheckListItem );






	static Table * table();
	//static CheckListStatusSchema * schema();
};


