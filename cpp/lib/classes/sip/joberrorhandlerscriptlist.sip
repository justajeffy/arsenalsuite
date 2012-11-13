


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
	JobErrorHandlerScriptList() /HoldGIL/;
	JobErrorHandlerScriptList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobErrorHandlerScriptList( const JobErrorHandlerScriptList & ) /HoldGIL/;
	JobErrorHandlerScriptList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobErrorHandlerScriptList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobErrorHandlerScriptList( recordListFromPyList(a0), JobErrorHandlerScript::table() );
%End

	~JobErrorHandlerScriptList() /HoldGIL/;

//	void insert( JobErrorHandlerScriptIter, const JobErrorHandlerScript & );

//	JobErrorHandlerScriptIter at( uint );

//	JobErrorHandlerScriptIter find( const Record & );

//	JobErrorHandlerScriptIter remove( const JobErrorHandlerScriptIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobErrorHandlerScriptIter begin();

	//JobErrorHandlerScriptIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobErrorHandlerScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobErrorHandlerScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobErrorHandlerScriptList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobErrorHandlerScriptList unique() const;
	MappedJobErrorHandlerScriptList reversed() const;
	MappedJobErrorHandlerScriptList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobErrorHandlerScript::schema() );
%End

	QStringList scripts() const /HoldGIL/;
	MappedJobErrorHandlerScriptList & setScripts( const QString & );


};


