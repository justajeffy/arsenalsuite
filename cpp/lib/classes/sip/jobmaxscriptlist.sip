


%MappedType MappedJobMaxScriptList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaxscriptlist.h"
#include "jobmaxscripttable.h"
#define MappedJobMaxScriptList JobMaxScriptList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaxScriptSchema::instance() );
%End
};

class JobMaxScriptList : JobList
{
%TypeHeaderCode
#include <jobmaxscriptlist.h>

%End
public:
	JobMaxScriptList();
	JobMaxScriptList( const RecordList &, Table * t = 0 );
	JobMaxScriptList( const JobMaxScriptList & );
	JobMaxScriptList( const Record &, Table * t = 0 );
	
	~JobMaxScriptList();

//	void insert( JobMaxScriptIter, const JobMaxScript & );

//	JobMaxScriptIter at( uint );

//	JobMaxScriptIter find( const Record & );

//	JobMaxScriptIter remove( const JobMaxScriptIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaxScriptIter begin();

	//JobMaxScriptIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaxScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaxScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaxScriptList sorted( const QString & c, bool a = true ) const;

	MappedJobMaxScriptList unique() const;
	MappedJobMaxScriptList reversed() const;
	MappedJobMaxScriptList reloaded() const;

	QStringList scripts() const;
	MappedJobMaxScriptList & setScripts( const QString & );
	QList<uint> maxTimes() const;
	MappedJobMaxScriptList & setMaxTimes( const uint & );
	QStringList outputFileses() const;
	MappedJobMaxScriptList & setOutputFileses( const QString & );
	QList<bool> silents() const;
	MappedJobMaxScriptList & setSilents( const bool & );
	QStringList maxVersions() const;
	MappedJobMaxScriptList & setMaxVersions( const QString & );
	QList<bool> runMax64s() const;
	MappedJobMaxScriptList & setRunMax64s( const bool & );


};


