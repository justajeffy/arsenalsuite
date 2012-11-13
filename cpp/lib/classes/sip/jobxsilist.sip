


%MappedType MappedJobXSIList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsilist.h"
#include "jobxsitable.h"
#define MappedJobXSIList JobXSIList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobXSISchema::instance() );
%End
};

class JobXSIList : JobList
{
%TypeHeaderCode
#include <jobxsilist.h>

%End
public:
	JobXSIList() /HoldGIL/;
	JobXSIList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobXSIList( const JobXSIList & ) /HoldGIL/;
	JobXSIList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobXSIList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobXSIList( recordListFromPyList(a0), JobXSI::table() );
%End

	~JobXSIList() /HoldGIL/;

//	void insert( JobXSIIter, const JobXSI & );

//	JobXSIIter at( uint );

//	JobXSIIter find( const Record & );

//	JobXSIIter remove( const JobXSIIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobXSIIter begin();

	//JobXSIIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobXSIList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobXSIList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobXSIList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobXSIList unique() const;
	MappedJobXSIList reversed() const;
	MappedJobXSIList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobXSI::schema() );
%End

	QStringList passes() const /HoldGIL/;
	MappedJobXSIList & setPasses( const QString & );
	QStringList framelists() const /HoldGIL/;
	MappedJobXSIList & setFramelists( const QString & );
	QList<uint> frameStarts() const /HoldGIL/;
	MappedJobXSIList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const /HoldGIL/;
	MappedJobXSIList & setFrameEnds( const uint & );
	QList<uint> resolutionXs() const /HoldGIL/;
	MappedJobXSIList & setResolutionXs( const uint & );
	QList<uint> resolutionYs() const /HoldGIL/;
	MappedJobXSIList & setResolutionYs( const uint & );
	QStringList renderers() const /HoldGIL/;
	MappedJobXSIList & setRenderers( const QString & );
	QList<bool> motionBlurs() const /HoldGIL/;
	MappedJobXSIList & setMotionBlurs( const bool & );
	QList<bool> deformMotionBlurs() const /HoldGIL/;
	MappedJobXSIList & setDeformMotionBlurs( const bool & );


};


