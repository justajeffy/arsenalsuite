
%MappedType MappedNotification
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationlist.h"
#include "notificationtable.h"
#define MappedNotification Notification
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Notification(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, NotificationSchema::instance() );
%End
};

class Notification : Record
{
%TypeHeaderCode
#include <notification.h>
#include "element.h"

%End
public:
	Notification();

	Notification( uint key );

	Notification( const Notification & other );

	Notification( const Record & r );

	Notification( RecordImp * imp, bool checkType = true );
	
	MappedNotification copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QDateTime created() const;
	MappedNotification & setCreated( const QDateTime & );
	QString subject() const;
	MappedNotification & setSubject( const QString & );
	QString message() const;
	MappedNotification & setMessage( const QString & );
	QString component() const;
	MappedNotification & setComponent( const QString & );
	QString event() const;
	MappedNotification & setEvent( const QString & );
	QDateTime routed() const;
	MappedNotification & setRouted( const QDateTime & );
	MappedElement element() const;
	MappedNotification & setElement( const Element & );


	static MappedNotificationList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedNotification reload( bool lockForUpdate = false );






static MappedRecord create( const QString & component, const QString & event, const QString & subject, const QString & message = QString() );

MappedRecord sendTo( const User & user, const QString & method = QString() );
MappedRecord sendTo( const QString & address, const QString & method );


	static Table * table();
	//static NotificationSchema * schema();
};


