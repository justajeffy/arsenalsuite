


%MappedType MappedJobXSIScriptList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsiscriptlist.h"
#include "jobxsiscripttable.h"
#define MappedJobXSIScriptList JobXSIScriptList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobXSIScriptSchema::instance() );
%End
};

class JobXSIScriptList : JobList
{
%TypeHeaderCode
#include <jobxsiscriptlist.h>

%End
public:
	JobXSIScriptList() /HoldGIL/;
	JobXSIScriptList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobXSIScriptList( const JobXSIScriptList & ) /HoldGIL/;
	JobXSIScriptList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobXSIScriptList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobXSIScriptList( recordListFromPyList(a0), JobXSIScript::table() );
%End

	~JobXSIScriptList() /HoldGIL/;

//	void insert( JobXSIScriptIter, const JobXSIScript & );

//	JobXSIScriptIter at( uint );

//	JobXSIScriptIter find( const Record & );

//	JobXSIScriptIter remove( const JobXSIScriptIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobXSIScriptIter begin();

	//JobXSIScriptIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobXSIScriptList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobXSIScriptList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobXSIScriptList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobXSIScriptList unique() const;
	MappedJobXSIScriptList reversed() const;
	MappedJobXSIScriptList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobXSIScript::schema() );
%End

	QList<int> frameStarts() const /HoldGIL/;
	MappedJobXSIScriptList & setFrameStarts( const int & );
	QList<int> frameEnds() const /HoldGIL/;
	MappedJobXSIScriptList & setFrameEnds( const int & );
	QList<bool> scriptRequiresUis() const /HoldGIL/;
	MappedJobXSIScriptList & setScriptRequiresUis( const bool & );
	QStringList scriptFiles() const /HoldGIL/;
	MappedJobXSIScriptList & setScriptFiles( const QString & );
	QStringList xsiFiles() const /HoldGIL/;
	MappedJobXSIScriptList & setXsiFiles( const QString & );
	QStringList scriptMethods() const /HoldGIL/;
	MappedJobXSIScriptList & setScriptMethods( const QString & );
	QStringList frameLists() const /HoldGIL/;
	MappedJobXSIScriptList & setFrameLists( const QString & );


};


