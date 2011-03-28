


%MappedType MappedServerFileActionList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactionlist.h"
#include "serverfileactiontable.h"
#define MappedServerFileActionList ServerFileActionList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ServerFileActionSchema::instance() );
%End
};

class ServerFileActionList : RecordList
{
%TypeHeaderCode
#include <serverfileactionlist.h>
#include "serverfileactionstatus.h"
#include "serverfileactiontype.h"
#include "host.h"

%End
public:
	ServerFileActionList();
	ServerFileActionList( const RecordList &, Table * t = 0 );
	ServerFileActionList( const ServerFileActionList & );
	ServerFileActionList( const Record &, Table * t = 0 );
	
	~ServerFileActionList();

//	void insert( ServerFileActionIter, const ServerFileAction & );

//	ServerFileActionIter at( uint );

//	ServerFileActionIter find( const Record & );

//	ServerFileActionIter remove( const ServerFileActionIter & );

	int remove( const Record & );
	
	int remove();
	
	//ServerFileActionIter begin();

	//ServerFileActionIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedServerFileActionList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedServerFileActionList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedServerFileActionList sorted( const QString & c, bool a = true ) const;

	MappedServerFileActionList unique() const;
	MappedServerFileActionList reversed() const;
	MappedServerFileActionList reloaded() const;

	MappedServerFileActionStatusList statuses() const;
	MappedServerFileActionList & setStatuses( const ServerFileActionStatus & );
	MappedServerFileActionTypeList serverFileActionTypes() const;
	MappedServerFileActionList & setServerFileActionTypes( const ServerFileActionType & );
	MappedHostList hosts() const;
	MappedServerFileActionList & setHosts( const Host & );
	QStringList destPaths() const;
	MappedServerFileActionList & setDestPaths( const QString & );
	QStringList errorMessages() const;
	MappedServerFileActionList & setErrorMessages( const QString & );
	QStringList sourcePaths() const;
	MappedServerFileActionList & setSourcePaths( const QString & );


};


