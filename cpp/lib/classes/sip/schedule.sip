
%MappedType MappedSchedule
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "schedulelist.h"
#include "scheduletable.h"
#define MappedSchedule Schedule
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Schedule(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ScheduleSchema::instance() );
%End
};

class Schedule : Record
{
%TypeHeaderCode
#include <schedule.h>
#include "user.h"
#include "element.h"
#include "assettype.h"
#include "user.h"

%End
public:
	Schedule();

	Schedule( uint key );

	Schedule( const Schedule & other );

	Schedule( const Record & r );

	Schedule( RecordImp * imp, bool checkType = true );
	
	MappedSchedule copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedUser user() const;
	MappedSchedule & setUser( const User & );
	QDate date() const;
	MappedSchedule & setDate( const QDate & );
	MappedElement element() const;
	MappedSchedule & setElement( const Element & );
	MappedAssetType assetType() const;
	MappedSchedule & setAssetType( const AssetType & );
	MappedUser createdByUser() const;
	MappedSchedule & setCreatedByUser( const User & );
	QTime startTime() const;
	MappedSchedule & setStartTime( const QTime & );
	Interval duration() const;
	MappedSchedule & setDuration( const Interval & );


	static MappedScheduleList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedSchedule reload( bool lockForUpdate = false );

	static MappedScheduleList recordsByUser( const User &fkeyUser );
	static MappedScheduleList recordsByElement( const Element &fkeyElement );






	static Table * table();
	//static ScheduleSchema * schema();
};


