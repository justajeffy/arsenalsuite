


%MappedType MappedNotificationRouteList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationroutelist.h"
#include "notificationroutetable.h"
#define MappedNotificationRouteList NotificationRouteList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, NotificationRouteSchema::instance() );
%End
};

class NotificationRouteList : RecordList
{
%TypeHeaderCode
#include <notificationroutelist.h>
#include "user.h"
#include "element.h"

%End
public:
	NotificationRouteList();
	NotificationRouteList( const RecordList &, Table * t = 0 );
	NotificationRouteList( const NotificationRouteList & );
	NotificationRouteList( const Record &, Table * t = 0 );
	
	~NotificationRouteList();

//	void insert( NotificationRouteIter, const NotificationRoute & );

//	NotificationRouteIter at( uint );

//	NotificationRouteIter find( const Record & );

//	NotificationRouteIter remove( const NotificationRouteIter & );

	int remove( const Record & );
	
	int remove();
	
	//NotificationRouteIter begin();

	//NotificationRouteIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedNotificationRouteList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedNotificationRouteList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedNotificationRouteList sorted( const QString & c, bool a = true ) const;

	MappedNotificationRouteList unique() const;
	MappedNotificationRouteList reversed() const;
	MappedNotificationRouteList reloaded() const;

	QStringList eventMatchs() const;
	MappedNotificationRouteList & setEventMatchs( const QString & );
	QStringList componentMatchs() const;
	MappedNotificationRouteList & setComponentMatchs( const QString & );
	MappedUserList users() const;
	MappedNotificationRouteList & setUsers( const User & );
	QStringList subjectMatchs() const;
	MappedNotificationRouteList & setSubjectMatchs( const QString & );
	QStringList messageMatchs() const;
	MappedNotificationRouteList & setMessageMatchs( const QString & );
	QStringList actions() const;
	MappedNotificationRouteList & setActions( const QString & );
	QList<int> priorities() const;
	MappedNotificationRouteList & setPriorities( const int & );
	MappedElementList elements() const;
	MappedNotificationRouteList & setElements( const Element & );
	QList<bool> routeAssetDescendants() const;
	MappedNotificationRouteList & setRouteAssetDescendants( const bool & );


};


