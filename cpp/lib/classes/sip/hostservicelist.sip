


%MappedType MappedHostServiceList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostservicelist.h"
#include "hostservicetable.h"
#define MappedHostServiceList HostServiceList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostServiceSchema::instance() );
%End
};

class HostServiceList : RecordList
{
%TypeHeaderCode
#include <hostservicelist.h>
#include "host.h"
#include "service.h"
#include "syslog.h"

%End
public:
	HostServiceList();
	HostServiceList( const RecordList &, Table * t = 0 );
	HostServiceList( const HostServiceList & );
	HostServiceList( const Record &, Table * t = 0 );
	
	~HostServiceList();

//	void insert( HostServiceIter, const HostService & );

//	HostServiceIter at( uint );

//	HostServiceIter find( const Record & );

//	HostServiceIter remove( const HostServiceIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostServiceIter begin();

	//HostServiceIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostServiceList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostServiceList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostServiceList sorted( const QString & c, bool a = true ) const;

	MappedHostServiceList unique() const;
	MappedHostServiceList reversed() const;
	MappedHostServiceList reloaded() const;

	MappedHostList hosts() const;
	MappedHostServiceList & setHosts( const Host & );
	MappedServiceList services() const;
	MappedHostServiceList & setServices( const Service & );
	MappedSysLogList sysLogs() const;
	MappedHostServiceList & setSysLogs( const SysLog & );
	QList<QDateTime> pulseDateTimes() const;
	MappedHostServiceList & setPulseDateTimes( const QDateTime & );
	QList<uint> remoteLogPorts() const;
	MappedHostServiceList & setRemoteLogPorts( const uint & );
	QList<bool> enabled() const;
	MappedHostServiceList & setEnabled( const bool & );


};


