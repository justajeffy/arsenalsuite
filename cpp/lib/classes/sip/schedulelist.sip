


%MappedType MappedScheduleList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "schedulelist.h"
#include "scheduletable.h"
#define MappedScheduleList ScheduleList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ScheduleSchema::instance() );
%End
};

class ScheduleList : RecordList
{
%TypeHeaderCode
#include <schedulelist.h>
#include "user.h"
#include "element.h"
#include "assettype.h"
#include "user.h"

%End
public:
	ScheduleList();
	ScheduleList( const RecordList &, Table * t = 0 );
	ScheduleList( const ScheduleList & );
	ScheduleList( const Record &, Table * t = 0 );
	
	~ScheduleList();

//	void insert( ScheduleIter, const Schedule & );

//	ScheduleIter at( uint );

//	ScheduleIter find( const Record & );

//	ScheduleIter remove( const ScheduleIter & );

	int remove( const Record & );
	
	int remove();
	
	//ScheduleIter begin();

	//ScheduleIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedScheduleList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedScheduleList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedScheduleList sorted( const QString & c, bool a = true ) const;

	MappedScheduleList unique() const;
	MappedScheduleList reversed() const;
	MappedScheduleList reloaded() const;

	MappedUserList users() const;
	MappedScheduleList & setUsers( const User & );
	QList<QDate> dates() const;
	MappedScheduleList & setDates( const QDate & );
	MappedElementList elements() const;
	MappedScheduleList & setElements( const Element & );
	MappedAssetTypeList assetTypes() const;
	MappedScheduleList & setAssetTypes( const AssetType & );
	MappedUserList createdByUsers() const;
	MappedScheduleList & setCreatedByUsers( const User & );
	QList<QTime> startTimes() const;
	MappedScheduleList & setStartTimes( const QTime & );
	QList<Interval> durations() const;
	MappedScheduleList & setDurations( const Interval & );


};


