


%MappedType MappedJobFusionList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionlist.h"
#include "jobfusiontable.h"
#define MappedJobFusionList JobFusionList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobFusionSchema::instance() );
%End
};

class JobFusionList : JobList
{
%TypeHeaderCode
#include <jobfusionlist.h>

%End
public:
	JobFusionList() /HoldGIL/;
	JobFusionList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobFusionList( const JobFusionList & ) /HoldGIL/;
	JobFusionList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobFusionList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobFusionList( recordListFromPyList(a0), JobFusion::table() );
%End

	~JobFusionList() /HoldGIL/;

//	void insert( JobFusionIter, const JobFusion & );

//	JobFusionIter at( uint );

//	JobFusionIter find( const Record & );

//	JobFusionIter remove( const JobFusionIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobFusionIter begin();

	//JobFusionIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobFusionList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobFusionList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobFusionList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobFusionList unique() const;
	MappedJobFusionList reversed() const;
	MappedJobFusionList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobFusion::schema() );
%End

	QStringList frameLists() const /HoldGIL/;
	MappedJobFusionList & setFrameLists( const QString & );
	QList<bool> allFramesAsSingleTasks() const /HoldGIL/;
	MappedJobFusionList & setAllFramesAsSingleTasks( const bool & );
	QList<uint> outputCounts() const /HoldGIL/;
	MappedJobFusionList & setOutputCounts( const uint & );
	QList<bool> reportedSaverErrors() const /HoldGIL/;
	MappedJobFusionList & setReportedSaverErrors( const bool & );


};


