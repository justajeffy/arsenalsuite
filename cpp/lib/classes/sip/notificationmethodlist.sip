


%MappedType MappedNotificationMethodList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationmethodlist.h"
#include "notificationmethodtable.h"
#define MappedNotificationMethodList NotificationMethodList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, NotificationMethodSchema::instance() );
%End
};

class NotificationMethodList : RecordList
{
%TypeHeaderCode
#include <notificationmethodlist.h>

%End
public:
	NotificationMethodList();
	NotificationMethodList( const RecordList &, Table * t = 0 );
	NotificationMethodList( const NotificationMethodList & );
	NotificationMethodList( const Record &, Table * t = 0 );
	
	~NotificationMethodList();

//	void insert( NotificationMethodIter, const NotificationMethod & );

//	NotificationMethodIter at( uint );

//	NotificationMethodIter find( const Record & );

//	NotificationMethodIter remove( const NotificationMethodIter & );

	int remove( const Record & );
	
	int remove();
	
	//NotificationMethodIter begin();

	//NotificationMethodIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedNotificationMethodList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedNotificationMethodList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedNotificationMethodList sorted( const QString & c, bool a = true ) const;

	MappedNotificationMethodList unique() const;
	MappedNotificationMethodList reversed() const;
	MappedNotificationMethodList reloaded() const;

	QStringList names() const;
	MappedNotificationMethodList & setNames( const QString & );


};


