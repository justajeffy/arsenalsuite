
%MappedType MappedNotificationMethod
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "notificationmethodlist.h"
#include "notificationmethodtable.h"
#define MappedNotificationMethod NotificationMethod
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new NotificationMethod(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, NotificationMethodSchema::instance() );
%End
};

class NotificationMethod : Record
{
%TypeHeaderCode
#include <notificationmethod.h>

%End
public:
	NotificationMethod();

	NotificationMethod( uint key );

	NotificationMethod( const NotificationMethod & other );

	NotificationMethod( const Record & r );

	NotificationMethod( RecordImp * imp, bool checkType = true );
	
	MappedNotificationMethod copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedNotificationMethod & setName( const QString & );


	static MappedNotificationMethodList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedNotificationMethod reload( bool lockForUpdate = false );

	static MappedNotificationMethod recordByName( const QString &name );






	static Table * table();
	//static NotificationMethodSchema * schema();
};


