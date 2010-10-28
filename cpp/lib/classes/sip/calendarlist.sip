


%MappedType MappedCalendarList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "calendarlist.h"
#include "calendartable.h"
#define MappedCalendarList CalendarList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, CalendarSchema::instance() );
%End
};

class CalendarList : RecordList
{
%TypeHeaderCode
#include <calendarlist.h>
#include "calendarcategory.h"
#include "user.h"
#include "user.h"
#include "project.h"

%End
public:
	CalendarList();
	CalendarList( const RecordList &, Table * t = 0 );
	CalendarList( const CalendarList & );
	CalendarList( const Record &, Table * t = 0 );
	
	~CalendarList();

//	void insert( CalendarIter, const Calendar & );

//	CalendarIter at( uint );

//	CalendarIter find( const Record & );

//	CalendarIter remove( const CalendarIter & );

	int remove( const Record & );
	
	int remove();
	
	//CalendarIter begin();

	//CalendarIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedCalendarList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedCalendarList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedCalendarList sorted( const QString & c, bool a = true ) const;

	MappedCalendarList unique() const;
	MappedCalendarList reversed() const;
	MappedCalendarList reloaded() const;

	QList<uint> repeats() const;
	MappedCalendarList & setRepeats( const uint & );
	MappedCalendarCategoryList categories() const;
	MappedCalendarList & setCategories( const CalendarCategory & );
	QStringList urls() const;
	MappedCalendarList & setUrls( const QString & );
	MappedUserList authors() const;
	MappedCalendarList & setAuthors( const User & );
	QStringList fieldNames() const;
	MappedCalendarList & setFieldNames( const QString & );
	QStringList notifyLists() const;
	MappedCalendarList & setNotifyLists( const QString & );
	QStringList notifyBatchs() const;
	MappedCalendarList & setNotifyBatchs( const QString & );
	QList<uint> leadTimes() const;
	MappedCalendarList & setLeadTimes( const uint & );
	QList<int> notifyMasks() const;
	MappedCalendarList & setNotifyMasks( const int & );
	MappedUserList users() const;
	MappedCalendarList & setUsers( const User & );
	QList<int> _Privates() const;
	MappedCalendarList & set_Privates( const int & );
	QList<QDateTime> dateTimes() const;
	MappedCalendarList & setDateTimes( const QDateTime & );
	QStringList calendars() const;
	MappedCalendarList & setCalendars( const QString & );
	MappedProjectList projects() const;
	MappedCalendarList & setProjects( const Project & );


};


