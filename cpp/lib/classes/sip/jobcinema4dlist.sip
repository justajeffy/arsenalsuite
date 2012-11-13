


%MappedType MappedJobCinema4DList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcinema4dlist.h"
#include "jobcinema4dtable.h"
#define MappedJobCinema4DList JobCinema4DList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobCinema4DSchema::instance() );
%End
};

class JobCinema4DList : JobList
{
%TypeHeaderCode
#include <jobcinema4dlist.h>

%End
public:
	JobCinema4DList() /HoldGIL/;
	JobCinema4DList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobCinema4DList( const JobCinema4DList & ) /HoldGIL/;
	JobCinema4DList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobCinema4DList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobCinema4DList( recordListFromPyList(a0), JobCinema4D::table() );
%End

	~JobCinema4DList() /HoldGIL/;

//	void insert( JobCinema4DIter, const JobCinema4D & );

//	JobCinema4DIter at( uint );

//	JobCinema4DIter find( const Record & );

//	JobCinema4DIter remove( const JobCinema4DIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobCinema4DIter begin();

	//JobCinema4DIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobCinema4DList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobCinema4DList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobCinema4DList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobCinema4DList unique() const;
	MappedJobCinema4DList reversed() const;
	MappedJobCinema4DList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobCinema4D::schema() );
%End

	QList<bool> videoModes() const /HoldGIL/;
	MappedJobCinema4DList & setVideoModes( const bool & );
	QList<int> videoStartFrames() const /HoldGIL/;
	MappedJobCinema4DList & setVideoStartFrames( const int & );
	QList<int> videoEndFrames() const /HoldGIL/;
	MappedJobCinema4DList & setVideoEndFrames( const int & );


};


