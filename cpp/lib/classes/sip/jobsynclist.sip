


%MappedType MappedJobSyncList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobsynclist.h"
#include "jobsynctable.h"
#define MappedJobSyncList JobSyncList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobSyncSchema::instance() );
%End
};

class JobSyncList : JobList
{
%TypeHeaderCode
#include <jobsynclist.h>

%End
public:
	JobSyncList() /HoldGIL/;
	JobSyncList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobSyncList( const JobSyncList & ) /HoldGIL/;
	JobSyncList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobSyncList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobSyncList( recordListFromPyList(a0), JobSync::table() );
%End

	~JobSyncList() /HoldGIL/;

//	void insert( JobSyncIter, const JobSync & );

//	JobSyncIter at( uint );

//	JobSyncIter find( const Record & );

//	JobSyncIter remove( const JobSyncIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobSyncIter begin();

	//JobSyncIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobSyncList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobSyncList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobSyncList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobSyncList unique() const;
	MappedJobSyncList reversed() const;
	MappedJobSyncList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobSync::schema() );
%End

	QStringList directions() const /HoldGIL/;
	MappedJobSyncList & setDirections( const QString & );
	QStringList filesFroms() const /HoldGIL/;
	MappedJobSyncList & setFilesFroms( const QString & );
	QStringList appends() const /HoldGIL/;
	MappedJobSyncList & setAppends( const QString & );


};


