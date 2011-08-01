


%MappedType MappedJobErrorHandlerScriptList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorhandlerscriptlist.h"
#include "joberrorhandlerscripttable.h"
#define MappedJobErrorHandlerScriptList JobErrorHandlerScriptList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobErrorHandlerScriptSchema::instance() );
%End
};

class JobErrorHandlerScriptList : RecordList
{
%TypeHeaderCode
#include <joberrorhandlerscriptlist.h>

%End
public:
	JobErrorHandlerScriptList();
	JobErrorHandlerScriptList( const RecordList &, Table * t = 0 );
	JobErrorHandlerScriptList( const JobErrorHandlerScriptList & );
	JobErrorHandlerScriptList( const Record &, Table * t = 0 );
	
	~JobErrorHandlerScriptList();

//	void insert( JobErrorHandlerScriptIter, const JobErrorHandlerScript & );

//	JobErrorHandlerScriptIter at( uint );

//	JobErrorHandlerScriptIter find( const Record & );

//	JobErrorHandlerScriptIter remove( const JobErrorHandlerScriptIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobErrorHandlerScriptIter begin();

	//JobErrorHandlerScriptIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobErrorHandlerScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobErrorHandlerScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobErrorHandlerScriptList sorted( const QString & c, bool a = true ) const;

	MappedJobErrorHandlerScriptList unique() const;
	MappedJobErrorHandlerScriptList reversed() const;
	MappedJobErrorHandlerScriptList reloaded() const;

	QStringList scripts() const;
	MappedJobErrorHandlerScriptList & setScripts( const QString & );


};


