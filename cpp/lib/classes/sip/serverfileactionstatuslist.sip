


%MappedType MappedServerFileActionStatusList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactionstatuslist.h"
#include "serverfileactionstatustable.h"
#define MappedServerFileActionStatusList ServerFileActionStatusList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ServerFileActionStatusSchema::instance() );
%End
};

class ServerFileActionStatusList : RecordList
{
%TypeHeaderCode
#include <serverfileactionstatuslist.h>

%End
public:
	ServerFileActionStatusList();
	ServerFileActionStatusList( const RecordList &, Table * t = 0 );
	ServerFileActionStatusList( const ServerFileActionStatusList & );
	ServerFileActionStatusList( const Record &, Table * t = 0 );
	
	~ServerFileActionStatusList();

//	void insert( ServerFileActionStatusIter, const ServerFileActionStatus & );

//	ServerFileActionStatusIter at( uint );

//	ServerFileActionStatusIter find( const Record & );

//	ServerFileActionStatusIter remove( const ServerFileActionStatusIter & );

	int remove( const Record & );
	
	int remove();
	
	//ServerFileActionStatusIter begin();

	//ServerFileActionStatusIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedServerFileActionStatusList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedServerFileActionStatusList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedServerFileActionStatusList sorted( const QString & c, bool a = true ) const;

	MappedServerFileActionStatusList unique() const;
	MappedServerFileActionStatusList reversed() const;
	MappedServerFileActionStatusList reloaded() const;

	QStringList names() const;
	MappedServerFileActionStatusList & setNames( const QString & );


};


