
%MappedType MappedCalendarCategory
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "calendarcategorylist.h"
#include "calendarcategorytable.h"
#define MappedCalendarCategory CalendarCategory
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new CalendarCategory(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, CalendarCategorySchema::instance() );
%End
};

class CalendarCategory : Record
{
%TypeHeaderCode
#include <calendarcategory.h>

%End
public:
	CalendarCategory();

	CalendarCategory( uint key );

	CalendarCategory( const CalendarCategory & other );

	CalendarCategory( const Record & r );

	CalendarCategory( RecordImp * imp, bool checkType = true );
	
	MappedCalendarCategory copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedCalendarCategory & setName( const QString & );


	static MappedCalendarCategoryList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedCalendarCategory reload( bool lockForUpdate = false );







	static Table * table();
	//static CalendarCategorySchema * schema();
};


