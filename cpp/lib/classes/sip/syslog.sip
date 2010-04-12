
%MappedType MappedSysLog
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "sysloglist.h"
#include "syslogtable.h"
#define MappedSysLog SysLog
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new SysLog(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, SysLogSchema::instance() );
%End
};

class SysLog : Record
{
%TypeHeaderCode
#include <syslog.h>
#include "host.h"
#include "syslogrealm.h"
#include "syslogseverity.h"

%End
public:
	SysLog();

	SysLog( uint key );

	SysLog( const SysLog & other );

	SysLog( const Record & r );

	SysLog( RecordImp * imp, bool checkType = true );
	
	MappedSysLog copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedSysLog & setHost( const Host & );
	MappedSysLogRealm sysLogRealm() const;
	MappedSysLog & setSysLogRealm( const SysLogRealm & );
	MappedSysLogSeverity sysLogSeverity() const;
	MappedSysLog & setSysLogSeverity( const SysLogSeverity & );
	QString message() const;
	MappedSysLog & setMessage( const QString & );
	int count() const;
	MappedSysLog & setCount( const int & );
	QDateTime created() const;
	MappedSysLog & setCreated( const QDateTime & );
	QString method() const;
	MappedSysLog & setMethod( const QString & );
	QString _class() const;
	MappedSysLog & set_class( const QString & );
	QDateTime lastOccurrence() const;
	MappedSysLog & setLastOccurrence( const QDateTime & );
	uint ack() const;
	MappedSysLog & setAck( const uint & );
	QString userName() const;
	MappedSysLog & setUserName( const QString & );
	QString hostName() const;
	MappedSysLog & setHostName( const QString & );
	QDateTime firstOccurence() const;
	MappedSysLog & setFirstOccurence( const QDateTime & );


	static MappedSysLogList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedSysLog reload( bool lockForUpdate = false );

	static MappedSysLogList recordsByHostAndAck( const Host &fkeyHost, const uint &ack );
	static MappedSysLogList recordsByuserName( const QString &userName );
	static MappedSysLogList recordsByhostName( const QString &hostName );






	static Table * table();
	//static SysLogSchema * schema();
};


