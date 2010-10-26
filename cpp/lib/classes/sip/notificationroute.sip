
%MappedType MappedNotificationRoute
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationroutelist.h"
#include "notificationroutetable.h"
#define MappedNotificationRoute NotificationRoute
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new NotificationRoute(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, NotificationRouteSchema::instance() );
%End
};

class NotificationRoute : Record
{
%TypeHeaderCode
#include <notificationroute.h>
#include "user.h"
#include "element.h"

%End
public:
	NotificationRoute();

	NotificationRoute( uint key );

	NotificationRoute( const NotificationRoute & other );

	NotificationRoute( const Record & r );

	NotificationRoute( RecordImp * imp, bool checkType = true );
	
	MappedNotificationRoute copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString eventMatch() const;
	MappedNotificationRoute & setEventMatch( const QString & );
	QString componentMatch() const;
	MappedNotificationRoute & setComponentMatch( const QString & );
	MappedUser user() const;
	MappedNotificationRoute & setUser( const User & );
	QString subjectMatch() const;
	MappedNotificationRoute & setSubjectMatch( const QString & );
	QString messageMatch() const;
	MappedNotificationRoute & setMessageMatch( const QString & );
	/**
	  * This is a string encoded as follows
	  * 
	  * [SECTION],...
	  * 
	  * each section consists of:
	  * 
	  * ACTION:METHOD[:DESTINATION][:USER]
	  * 
	  * Actions consist of:
	  * 
	  * default - Sets default method/destination, user is ignored, only used for routing notificationdestinations.
	  * add - Adds a new destination using method/destination/user
	  * 
	  * Section Examples:
	  * 
	  * default:email - Sets default method to email
	  * add:email:gates@microsoft.com - Adds new destination, emails to gates@microsoft.com address
	  * 
	  * 
	  * 
	  **/
	QString actions() const;
	MappedNotificationRoute & setActions( const QString & );
	/**
	  * Routes are processes from lowest to highest priority.  The default method can be set multiple times, so the highest priority is ultimatly used.
	  **/
	int priority() const;
	MappedNotificationRoute & setPriority( const int & );
	MappedElement element() const;
	MappedNotificationRoute & setElement( const Element & );
	bool routeAssetDescendants() const;
	MappedNotificationRoute & setRouteAssetDescendants( const bool & );


	static MappedNotificationRouteList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedNotificationRoute reload( bool lockForUpdate = false );

	static MappedNotificationRouteList recordsByUser( const User &fkeyUser );






	static Table * table();
	//static NotificationRouteSchema * schema();
};


