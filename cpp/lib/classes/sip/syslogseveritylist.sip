


%MappedType MappedSysLogSeverityList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "syslogseveritylist.h"
#include "syslogseveritytable.h"
#define MappedSysLogSeverityList SysLogSeverityList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, SysLogSeveritySchema::instance() );
%End
};

class SysLogSeverityList : RecordList
{
%TypeHeaderCode
#include <syslogseveritylist.h>

%End
public:
	SysLogSeverityList();
	SysLogSeverityList( const RecordList &, Table * t = 0 );
	SysLogSeverityList( const SysLogSeverityList & );
	SysLogSeverityList( const Record &, Table * t = 0 );
	
	~SysLogSeverityList();

//	void insert( SysLogSeverityIter, const SysLogSeverity & );

//	SysLogSeverityIter at( uint );

//	SysLogSeverityIter find( const Record & );

//	SysLogSeverityIter remove( const SysLogSeverityIter & );

	int remove( const Record & );
	
	int remove();
	
	//SysLogSeverityIter begin();

	//SysLogSeverityIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedSysLogSeverityList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedSysLogSeverityList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedSysLogSeverityList sorted( const QString & c, bool a = true ) const;

	MappedSysLogSeverityList unique() const;
	MappedSysLogSeverityList reversed() const;
	MappedSysLogSeverityList reloaded() const;

	QStringList sysLogSeverities() const;
	MappedSysLogSeverityList & setSysLogSeverities( const QString & );
	QList<int> severities() const;
	MappedSysLogSeverityList & setSeverities( const int & );


};


