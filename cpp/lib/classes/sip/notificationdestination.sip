
%MappedType MappedNotificationDestination
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationdestinationlist.h"
#include "notificationdestinationtable.h"
#define MappedNotificationDestination NotificationDestination
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new NotificationDestination(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, NotificationDestinationSchema::instance() );
%End
};

class NotificationDestination : Record
{
%TypeHeaderCode
#include <notificationdestination.h>
#include "notification.h"
#include "notificationmethod.h"
#include "user.h"

%End
public:
	NotificationDestination();

	NotificationDestination( uint key );

	NotificationDestination( const NotificationDestination & other );

	NotificationDestination( const Record & r );

	NotificationDestination( RecordImp * imp, bool checkType = true );
	
	MappedNotificationDestination copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedNotification notification() const;
	MappedNotificationDestination & setNotification( const Notification & );
	MappedNotificationMethod notificationMethod() const;
	MappedNotificationDestination & setNotificationMethod( const NotificationMethod & );
	/**
	  * This holds the datetime when the notification was delivered to this destination.  If this field is null, the notification has not been delivered.
	  **/
	QDateTime delivered() const;
	MappedNotificationDestination & setDelivered( const QDateTime & );
	/**
	  * This is a generic field, can be used to hold email address, phone number, jabber id, etc.
	  **/
	QString destination() const;
	MappedNotificationDestination & setDestination( const QString & );
	/**
	  * Specifies the user that is being notified by this destination.  Can be null if a user does not apply, or does not exist.
	  **/
	MappedUser user() const;
	MappedNotificationDestination & setUser( const User & );
	QDateTime routed() const;
	MappedNotificationDestination & setRouted( const QDateTime & );


	static MappedNotificationDestinationList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedNotificationDestination reload( bool lockForUpdate = false );







	static Table * table();
	//static NotificationDestinationSchema * schema();
};


