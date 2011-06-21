


%MappedType MappedCalendarCategoryList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "calendarcategorylist.h"
#include "calendarcategorytable.h"
#define MappedCalendarCategoryList CalendarCategoryList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, CalendarCategorySchema::instance() );
%End
};

class CalendarCategoryList : RecordList
{
%TypeHeaderCode
#include <calendarcategorylist.h>

%End
public:
	CalendarCategoryList();
	CalendarCategoryList( const RecordList &, Table * t = 0 );
	CalendarCategoryList( const CalendarCategoryList & );
	CalendarCategoryList( const Record &, Table * t = 0 );
	
	~CalendarCategoryList();

//	void insert( CalendarCategoryIter, const CalendarCategory & );

//	CalendarCategoryIter at( uint );

//	CalendarCategoryIter find( const Record & );

//	CalendarCategoryIter remove( const CalendarCategoryIter & );

	int remove( const Record & );
	
	int remove();
	
	//CalendarCategoryIter begin();

	//CalendarCategoryIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedCalendarCategoryList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedCalendarCategoryList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedCalendarCategoryList sorted( const QString & c, bool a = true ) const;

	MappedCalendarCategoryList unique() const;
	MappedCalendarCategoryList reversed() const;
	MappedCalendarCategoryList reloaded() const;

	QStringList names() const;
	MappedCalendarCategoryList & setNames( const QString & );


};


