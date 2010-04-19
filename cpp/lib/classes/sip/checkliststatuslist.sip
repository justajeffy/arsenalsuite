


%MappedType MappedCheckListStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "checkliststatuslist.h"
#include "checkliststatustable.h"
#define MappedCheckListStatusList CheckListStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, CheckListStatusSchema::instance() );
%End
};

class CheckListStatusList : RecordList
{
%TypeHeaderCode
#include <checkliststatuslist.h>
#include "checklistitem.h"
#include "element.h"
#include "elementstatus.h"

%End
public:
	CheckListStatusList();
	CheckListStatusList( const RecordList &, Table * t = 0 );
	CheckListStatusList( const CheckListStatusList & );
	CheckListStatusList( const Record &, Table * t = 0 );
	
	~CheckListStatusList();

//	void insert( CheckListStatusIter, const CheckListStatus & );

//	CheckListStatusIter at( uint );

//	CheckListStatusIter find( const Record & );

//	CheckListStatusIter remove( const CheckListStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//CheckListStatusIter begin();

	//CheckListStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedCheckListStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedCheckListStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedCheckListStatusList sorted( const QString & c, bool a = true ) const;

	MappedCheckListStatusList unique() const;
	MappedCheckListStatusList reversed() const;
	MappedCheckListStatusList reloaded() const;

	MappedCheckListItemList checkListItems() const;
	MappedCheckListStatusList & setCheckListItems( const CheckListItem & );
	MappedElementList elements() const;
	MappedCheckListStatusList & setElements( const Element & );
	MappedElementStatusList statuses() const;
	MappedCheckListStatusList & setStatuses( const ElementStatus & );


};


