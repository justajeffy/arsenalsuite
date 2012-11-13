


%MappedType MappedJobErrorHandlerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorhandlerlist.h"
#include "joberrorhandlertable.h"
#define MappedJobErrorHandlerList JobErrorHandlerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobErrorHandlerSchema::instance() );
%End
};

class JobErrorHandlerList : RecordList
{
%TypeHeaderCode
#include <joberrorhandlerlist.h>
#include "jobtype.h"
#include "joberrorhandlerscript.h"

%End
public:
	JobErrorHandlerList() /HoldGIL/;
	JobErrorHandlerList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobErrorHandlerList( const JobErrorHandlerList & ) /HoldGIL/;
	JobErrorHandlerList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobErrorHandlerList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobErrorHandlerList( recordListFromPyList(a0), JobErrorHandler::table() );
%End

	~JobErrorHandlerList() /HoldGIL/;

//	void insert( JobErrorHandlerIter, const JobErrorHandler & );

//	JobErrorHandlerIter at( uint );

//	JobErrorHandlerIter find( const Record & );

//	JobErrorHandlerIter remove( const JobErrorHandlerIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobErrorHandlerIter begin();

	//JobErrorHandlerIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobErrorHandlerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobErrorHandlerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobErrorHandlerList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobErrorHandlerList unique() const;
	MappedJobErrorHandlerList reversed() const;
	MappedJobErrorHandlerList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobErrorHandler::schema() );
%End

	MappedJobTypeList jobTypes(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedJobErrorHandlerList & setJobTypes( const JobType & );
	QStringList errorRegExs() const /HoldGIL/;
	MappedJobErrorHandlerList & setErrorRegExs( const QString & );
	MappedJobErrorHandlerScriptList jobErrorHandlerScripts(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedJobErrorHandlerList & setJobErrorHandlerScripts( const JobErrorHandlerScript & );


};


