
%MappedType MappedTimeSheet
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "timesheetlist.h"
#include "timesheettable.h"
#define MappedTimeSheet TimeSheet
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new TimeSheet(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, TimeSheetSchema::instance() );
%End
};

class TimeSheet : Record
{
%TypeHeaderCode
#include <timesheet.h>
#include "element.h"
#include "employee.h"
#include "project.h"
#include "assettype.h"

%End
public:
	TimeSheet();

	TimeSheet( uint key );

	TimeSheet( const TimeSheet & other );

	TimeSheet( const Record & r );

	TimeSheet( RecordImp * imp, bool checkType = true );
	
	MappedTimeSheet copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QDateTime dateTime() const;
	MappedTimeSheet & setDateTime( const QDateTime & );
	QString comment() const;
	MappedTimeSheet & setComment( const QString & );
	MappedElement element() const;
	MappedTimeSheet & setElement( const Element & );
	MappedEmployee user() const;
	MappedTimeSheet & setUser( const Employee & );
	MappedProject project() const;
	MappedTimeSheet & setProject( const Project & );
	MappedAssetType assetType() const;
	MappedTimeSheet & setAssetType( const AssetType & );
	float scheduledHour() const;
	MappedTimeSheet & setScheduledHour( const float & );
	QDateTime dateTimeSubmitted() const;
	MappedTimeSheet & setDateTimeSubmitted( const QDateTime & );
	float unscheduledHour() const;
	MappedTimeSheet & setUnscheduledHour( const float & );


	static MappedTimeSheetList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedTimeSheet reload( bool lockForUpdate = false );

	static MappedTimeSheetList recordsByElement( const Element &fkeyElement );
	static MappedTimeSheetList recordsByUser( const Employee &fkeyEmployee );
	static MappedTimeSheetList recordsByProject( const Project &fkeyProject );
	static MappedTimeSheetList recordsByDateTime( const QDateTime &dateTime );






	static MappedRecordList recordsByElementAndDate(const Element & element, QDateTime dateTime);





	static Table * table();
	//static TimeSheetSchema * schema();
};


