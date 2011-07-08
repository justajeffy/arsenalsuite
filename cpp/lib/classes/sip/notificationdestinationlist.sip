


%MappedType MappedNotificationDestinationList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationdestinationlist.h"
#include "notificationdestinationtable.h"
#define MappedNotificationDestinationList NotificationDestinationList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, NotificationDestinationSchema::instance() );
%End
};

class NotificationDestinationList : RecordList
{
%TypeHeaderCode
#include <notificationdestinationlist.h>
#include "notification.h"
#include "notificationmethod.h"
#include "user.h"

%End
public:
	NotificationDestinationList();
	NotificationDestinationList( const RecordList &, Table * t = 0 );
	NotificationDestinationList( const NotificationDestinationList & );
	NotificationDestinationList( const Record &, Table * t = 0 );
	
	~NotificationDestinationList();

//	void insert( NotificationDestinationIter, const NotificationDestination & );

//	NotificationDestinationIter at( uint );

//	NotificationDestinationIter find( const Record & );

//	NotificationDestinationIter remove( const NotificationDestinationIter & );

	int remove( const Record & );
	
	int remove();
	
	//NotificationDestinationIter begin();

	//NotificationDestinationIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedNotificationDestinationList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedNotificationDestinationList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedNotificationDestinationList sorted( const QString & c, bool a = true ) const;

	MappedNotificationDestinationList unique() const;
	MappedNotificationDestinationList reversed() const;
	MappedNotificationDestinationList reloaded() const;

	MappedNotificationList notifications() const;
	MappedNotificationDestinationList & setNotifications( const Notification & );
	MappedNotificationMethodList notificationMethods() const;
	MappedNotificationDestinationList & setNotificationMethods( const NotificationMethod & );
	QList<QDateTime> delivered() const;
	MappedNotificationDestinationList & setDelivered( const QDateTime & );
	QStringList destinations() const;
	MappedNotificationDestinationList & setDestinations( const QString & );
	MappedUserList users() const;
	MappedNotificationDestinationList & setUsers( const User & );
	QList<QDateTime> routed() const;
	MappedNotificationDestinationList & setRouted( const QDateTime & );


};


