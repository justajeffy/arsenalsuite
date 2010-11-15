


%MappedType MappedSysLogList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "sysloglist.h"
#include "syslogtable.h"
#define MappedSysLogList SysLogList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, SysLogSchema::instance() );
%End
};

class SysLogList : RecordList
{
%TypeHeaderCode
#include <sysloglist.h>
#include "host.h"
#include "syslogrealm.h"
#include "syslogseverity.h"

%End
public:
	SysLogList();
	SysLogList( const RecordList &, Table * t = 0 );
	SysLogList( const SysLogList & );
	SysLogList( const Record &, Table * t = 0 );
	
	~SysLogList();

//	void insert( SysLogIter, const SysLog & );

//	SysLogIter at( uint );

//	SysLogIter find( const Record & );

//	SysLogIter remove( const SysLogIter & );

	int remove( const Record & );
	
	int remove();
	
	//SysLogIter begin();

	//SysLogIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedSysLogList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedSysLogList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedSysLogList sorted( const QString & c, bool a = true ) const;

	MappedSysLogList unique() const;
	MappedSysLogList reversed() const;
	MappedSysLogList reloaded() const;

	MappedHostList hosts() const;
	MappedSysLogList & setHosts( const Host & );
	MappedSysLogRealmList sysLogRealms() const;
	MappedSysLogList & setSysLogRealms( const SysLogRealm & );
	MappedSysLogSeverityList sysLogSeverities() const;
	MappedSysLogList & setSysLogSeverities( const SysLogSeverity & );
	QStringList messages() const;
	MappedSysLogList & setMessages( const QString & );
	QList<int> counts() const;
	MappedSysLogList & setCounts( const int & );
	QList<QDateTime> created() const;
	MappedSysLogList & setCreated( const QDateTime & );
	QStringList methods() const;
	MappedSysLogList & setMethods( const QString & );
	QStringList _classes() const;
	MappedSysLogList & set_classes( const QString & );
	QList<QDateTime> lastOccurrences() const;
	MappedSysLogList & setLastOccurrences( const QDateTime & );
	QList<uint> acks() const;
	MappedSysLogList & setAcks( const uint & );
	QStringList userNames() const;
	MappedSysLogList & setUserNames( const QString & );
	QStringList hostNames() const;
	MappedSysLogList & setHostNames( const QString & );
	QList<QDateTime> firstOccurences() const;
	MappedSysLogList & setFirstOccurences( const QDateTime & );


};


