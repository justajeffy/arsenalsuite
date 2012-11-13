


%MappedType MappedJobAutodeskBurnList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobautodeskburnlist.h"
#include "jobautodeskburntable.h"
#define MappedJobAutodeskBurnList JobAutodeskBurnList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAutodeskBurnSchema::instance() );
%End
};

class JobAutodeskBurnList : JobList
{
%TypeHeaderCode
#include <jobautodeskburnlist.h>

%End
public:
	JobAutodeskBurnList() /HoldGIL/;
	JobAutodeskBurnList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobAutodeskBurnList( const JobAutodeskBurnList & ) /HoldGIL/;
	JobAutodeskBurnList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobAutodeskBurnList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobAutodeskBurnList( recordListFromPyList(a0), JobAutodeskBurn::table() );
%End

	~JobAutodeskBurnList() /HoldGIL/;

//	void insert( JobAutodeskBurnIter, const JobAutodeskBurn & );

//	JobAutodeskBurnIter at( uint );

//	JobAutodeskBurnIter find( const Record & );

//	JobAutodeskBurnIter remove( const JobAutodeskBurnIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobAutodeskBurnIter begin();

	//JobAutodeskBurnIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobAutodeskBurnList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobAutodeskBurnList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobAutodeskBurnList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobAutodeskBurnList unique() const;
	MappedJobAutodeskBurnList reversed() const;
	MappedJobAutodeskBurnList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobAutodeskBurn::schema() );
%End

	QList<uint> frameStarts() const /HoldGIL/;
	MappedJobAutodeskBurnList & setFrameStarts( const uint & );
	QList<uint> frameEnds() const /HoldGIL/;
	MappedJobAutodeskBurnList & setFrameEnds( const uint & );
	QStringList handles() const /HoldGIL/;
	MappedJobAutodeskBurnList & setHandles( const QString & );


};


