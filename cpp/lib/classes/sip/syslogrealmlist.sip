


%MappedType MappedSysLogRealmList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "syslogrealmlist.h"
#include "syslogrealmtable.h"
#define MappedSysLogRealmList SysLogRealmList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, SysLogRealmSchema::instance() );
%End
};

class SysLogRealmList : RecordList
{
%TypeHeaderCode
#include <syslogrealmlist.h>

%End
public:
	SysLogRealmList();
	SysLogRealmList( const RecordList &, Table * t = 0 );
	SysLogRealmList( const SysLogRealmList & );
	SysLogRealmList( const Record &, Table * t = 0 );
	
	~SysLogRealmList();

//	void insert( SysLogRealmIter, const SysLogRealm & );

//	SysLogRealmIter at( uint );

//	SysLogRealmIter find( const Record & );

//	SysLogRealmIter remove( const SysLogRealmIter & );

	int remove( const Record & );
	
	int remove();
	
	//SysLogRealmIter begin();

	//SysLogRealmIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedSysLogRealmList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedSysLogRealmList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedSysLogRealmList sorted( const QString & c, bool a = true ) const;

	MappedSysLogRealmList unique() const;
	MappedSysLogRealmList reversed() const;
	MappedSysLogRealmList reloaded() const;

	QStringList realms() const;
	MappedSysLogRealmList & setRealms( const QString & );


};


