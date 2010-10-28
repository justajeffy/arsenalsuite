


%MappedType MappedTimeSheetList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "timesheetlist.h"
#include "timesheettable.h"
#define MappedTimeSheetList TimeSheetList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, TimeSheetSchema::instance() );
%End
};

class TimeSheetList : RecordList
{
%TypeHeaderCode
#include <timesheetlist.h>
#include "element.h"
#include "employee.h"
#include "project.h"
#include "assettype.h"

%End
public:
	TimeSheetList();
	TimeSheetList( const RecordList &, Table * t = 0 );
	TimeSheetList( const TimeSheetList & );
	TimeSheetList( const Record &, Table * t = 0 );
	
	~TimeSheetList();

//	void insert( TimeSheetIter, const TimeSheet & );

//	TimeSheetIter at( uint );

//	TimeSheetIter find( const Record & );

//	TimeSheetIter remove( const TimeSheetIter & );

	int remove( const Record & );
	
	int remove();
	
	//TimeSheetIter begin();

	//TimeSheetIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedTimeSheetList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedTimeSheetList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedTimeSheetList sorted( const QString & c, bool a = true ) const;

	MappedTimeSheetList unique() const;
	MappedTimeSheetList reversed() const;
	MappedTimeSheetList reloaded() const;

	QList<QDateTime> dateTimes() const;
	MappedTimeSheetList & setDateTimes( const QDateTime & );
	QStringList comments() const;
	MappedTimeSheetList & setComments( const QString & );
	MappedElementList elements() const;
	MappedTimeSheetList & setElements( const Element & );
	MappedEmployeeList users() const;
	MappedTimeSheetList & setUsers( const Employee & );
	MappedProjectList projects() const;
	MappedTimeSheetList & setProjects( const Project & );
	MappedAssetTypeList assetTypes() const;
	MappedTimeSheetList & setAssetTypes( const AssetType & );
	QList<float> scheduledHours() const;
	MappedTimeSheetList & setScheduledHours( const float & );
	QList<QDateTime> dateTimeSubmitted() const;
	MappedTimeSheetList & setDateTimeSubmitted( const QDateTime & );
	QList<float> unscheduledHours() const;
	MappedTimeSheetList & setUnscheduledHours( const float & );


};


