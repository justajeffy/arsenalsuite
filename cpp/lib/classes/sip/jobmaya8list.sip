


%MappedType MappedJobMaya8List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaya8list.h"
#include "jobmaya8table.h"
#define MappedJobMaya8List JobMaya8List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaya8Schema::instance() );
%End
};

class JobMaya8List : JobMayaList
{
%TypeHeaderCode
#include <jobmaya8list.h>

%End
public:
	JobMaya8List() /HoldGIL/;
	JobMaya8List( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobMaya8List( const JobMaya8List & ) /HoldGIL/;
	JobMaya8List( const Record &, Table * t = 0 ) /HoldGIL/;
	JobMaya8List( SIP_PYLIST );
%MethodCode
	sipCpp = new JobMaya8List( recordListFromPyList(a0), JobMaya8::table() );
%End

	~JobMaya8List() /HoldGIL/;

//	void insert( JobMaya8Iter, const JobMaya8 & );

//	JobMaya8Iter at( uint );

//	JobMaya8Iter find( const Record & );

//	JobMaya8Iter remove( const JobMaya8Iter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobMaya8Iter begin();

	//JobMaya8Iter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobMaya8List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobMaya8List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobMaya8List sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobMaya8List unique() const;
	MappedJobMaya8List reversed() const;
	MappedJobMaya8List reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobMaya8::schema() );
%End



};


