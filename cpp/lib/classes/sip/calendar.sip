
%MappedType MappedCalendar
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "calendarlist.h"
#include "calendartable.h"
#define MappedCalendar Calendar
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Calendar(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, CalendarSchema::instance() );
%End
};

class Calendar : Record
{
%TypeHeaderCode
#include <calendar.h>
#include "calendarcategory.h"
#include "user.h"
#include "user.h"
#include "project.h"

%End
public:
	Calendar();

	Calendar( uint key );

	Calendar( const Calendar & other );

	Calendar( const Record & r );

	Calendar( RecordImp * imp, bool checkType = true );
	
	MappedCalendar copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint repeat() const;
	MappedCalendar & setRepeat( const uint & );
	MappedCalendarCategory category() const;
	MappedCalendar & setCategory( const CalendarCategory & );
	QString url() const;
	MappedCalendar & setUrl( const QString & );
	MappedUser author() const;
	MappedCalendar & setAuthor( const User & );
	QString fieldName() const;
	MappedCalendar & setFieldName( const QString & );
	QString notifyList() const;
	MappedCalendar & setNotifyList( const QString & );
	QString notifyBatch() const;
	MappedCalendar & setNotifyBatch( const QString & );
	uint leadTime() const;
	MappedCalendar & setLeadTime( const uint & );
	int notifyMask() const;
	MappedCalendar & setNotifyMask( const int & );
	MappedUser user() const;
	MappedCalendar & setUser( const User & );
	int _Private() const;
	MappedCalendar & set_Private( const int & );
	QDateTime dateTime() const;
	MappedCalendar & setDateTime( const QDateTime & );
	QString calendar() const;
	MappedCalendar & setCalendar( const QString & );
	MappedProject project() const;
	MappedCalendar & setProject( const Project & );


	static MappedCalendarList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedCalendar reload( bool lockForUpdate = false );







	static Table * table();
	//static CalendarSchema * schema();
};


