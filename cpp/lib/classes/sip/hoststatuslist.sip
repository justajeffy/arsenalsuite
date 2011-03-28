


%MappedType MappedHostStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hoststatuslist.h"
#include "hoststatustable.h"
#define MappedHostStatusList HostStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, HostStatusSchema::instance() );
%End
};

class HostStatusList : RecordList
{
%TypeHeaderCode
#include <hoststatuslist.h>
#include "host.h"

%End
public:
	HostStatusList();
	HostStatusList( const RecordList &, Table * t = 0 );
	HostStatusList( const HostStatusList & );
	HostStatusList( const Record &, Table * t = 0 );
	
	~HostStatusList();

//	void insert( HostStatusIter, const HostStatus & );

//	HostStatusIter at( uint );

//	HostStatusIter find( const Record & );

//	HostStatusIter remove( const HostStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//HostStatusIter begin();

	//HostStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedHostStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedHostStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedHostStatusList sorted( const QString & c, bool a = true ) const;

	MappedHostStatusList unique() const;
	MappedHostStatusList reversed() const;
	MappedHostStatusList reloaded() const;

	MappedHostList hosts() const;
	MappedHostStatusList & setHosts( const Host & );
	QStringList slaveStatuses() const;
	MappedHostStatusList & setSlaveStatuses( const QString & );
	QList<QDateTime> lastStatusChanges() const;
	MappedHostStatusList & setLastStatusChanges( const QDateTime & );
	QList<QDateTime> slavePulses() const;
	MappedHostStatusList & setSlavePulses( const QDateTime & );
	QList<int> onlines() const;
	MappedHostStatusList & setOnlines( const int & );
	QList<int> activeAssignmentCounts() const;
	MappedHostStatusList & setActiveAssignmentCounts( const int & );
	QList<QDateTime> lastAssignmentChanges() const;
	MappedHostStatusList & setLastAssignmentChanges( const QDateTime & );
	QList<int> availableMemories() const;
	MappedHostStatusList & setAvailableMemories( const int & );


};


