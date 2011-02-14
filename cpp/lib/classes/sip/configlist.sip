


%MappedType MappedConfigList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "configlist.h"
#include "configtable.h"
#define MappedConfigList ConfigList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, ConfigSchema::instance() );
%End
};

class ConfigList : RecordList
{
%TypeHeaderCode
#include <configlist.h>

%End
public:
	ConfigList();
	ConfigList( const RecordList &, Table * t = 0 );
	ConfigList( const ConfigList & );
	ConfigList( const Record &, Table * t = 0 );
	
	~ConfigList();

//	void insert( ConfigIter, const Config & );

//	ConfigIter at( uint );

//	ConfigIter find( const Record & );

//	ConfigIter remove( const ConfigIter & );

	int remove( const Record & );
	
	int remove();
	
	//ConfigIter begin();

	//ConfigIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedConfigList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedConfigList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedConfigList sorted( const QString & c, bool a = true ) const;

	MappedConfigList unique() const;
	MappedConfigList reversed() const;
	MappedConfigList reloaded() const;

	QStringList configs() const;
	MappedConfigList & setConfigs( const QString & );
	QStringList values() const;
	MappedConfigList & setValues( const QString & );


};


