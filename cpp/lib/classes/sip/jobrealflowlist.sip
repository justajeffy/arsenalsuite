


%MappedType MappedJobRealFlowList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobrealflowlist.h"
#include "jobrealflowtable.h"
#define MappedJobRealFlowList JobRealFlowList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobRealFlowSchema::instance() );
%End
};

class JobRealFlowList : JobList
{
%TypeHeaderCode
#include <jobrealflowlist.h>

%End
public:
	JobRealFlowList() /HoldGIL/;
	JobRealFlowList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobRealFlowList( const JobRealFlowList & ) /HoldGIL/;
	JobRealFlowList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobRealFlowList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobRealFlowList( recordListFromPyList(a0), JobRealFlow::table() );
%End

	~JobRealFlowList() /HoldGIL/;

//	void insert( JobRealFlowIter, const JobRealFlow & );

//	JobRealFlowIter at( uint );

//	JobRealFlowIter find( const Record & );

//	JobRealFlowIter remove( const JobRealFlowIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobRealFlowIter begin();

	//JobRealFlowIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobRealFlowList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobRealFlowList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobRealFlowList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobRealFlowList unique() const;
	MappedJobRealFlowList reversed() const;
	MappedJobRealFlowList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobRealFlow::schema() );
%End

	QList<int> frameStarts() const /HoldGIL/;
	MappedJobRealFlowList & setFrameStarts( const int & );
	QList<int> frameEnds() const /HoldGIL/;
	MappedJobRealFlowList & setFrameEnds( const int & );
	QStringList simTypes() const /HoldGIL/;
	MappedJobRealFlowList & setSimTypes( const QString & );
	QList<uint> threadses() const /HoldGIL/;
	MappedJobRealFlowList & setThreadses( const uint & );
	QStringList scripts() const /HoldGIL/;
	MappedJobRealFlowList & setScripts( const QString & );


};


