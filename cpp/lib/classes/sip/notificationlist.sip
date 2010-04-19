


%MappedType MappedNotificationList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationlist.h"
#include "notificationtable.h"
#define MappedNotificationList NotificationList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, NotificationSchema::instance() );
%End
};

class NotificationList : RecordList
{
%TypeHeaderCode
#include <notificationlist.h>
#include "element.h"

%End
public:
	NotificationList();
	NotificationList( const RecordList &, Table * t = 0 );
	NotificationList( const NotificationList & );
	NotificationList( const Record &, Table * t = 0 );
	
	~NotificationList();

//	void insert( NotificationIter, const Notification & );

//	NotificationIter at( uint );

//	NotificationIter find( const Record & );

//	NotificationIter remove( const NotificationIter & );

	int remove( const Record & );
	
	int remove();
	
	//NotificationIter begin();

	//NotificationIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedNotificationList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedNotificationList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedNotificationList sorted( const QString & c, bool a = true ) const;

	MappedNotificationList unique() const;
	MappedNotificationList reversed() const;
	MappedNotificationList reloaded() const;

	QList<QDateTime> created() const;
	MappedNotificationList & setCreated( const QDateTime & );
	QStringList subjects() const;
	MappedNotificationList & setSubjects( const QString & );
	QStringList messages() const;
	MappedNotificationList & setMessages( const QString & );
	QStringList components() const;
	MappedNotificationList & setComponents( const QString & );
	QStringList events() const;
	MappedNotificationList & setEvents( const QString & );
	QList<QDateTime> routed() const;
	MappedNotificationList & setRouted( const QDateTime & );
	MappedElementList elements() const;
	MappedNotificationList & setElements( const Element & );


};


