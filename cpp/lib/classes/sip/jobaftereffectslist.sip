


%MappedType MappedJobAfterEffectsList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffectslist.h"
#include "jobaftereffectstable.h"
#define MappedJobAfterEffectsList JobAfterEffectsList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobAfterEffectsSchema::instance() );
%End
};

class JobAfterEffectsList : JobList
{
%TypeHeaderCode
#include <jobaftereffectslist.h>

%End
public:
	JobAfterEffectsList() /HoldGIL/;
	JobAfterEffectsList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobAfterEffectsList( const JobAfterEffectsList & ) /HoldGIL/;
	JobAfterEffectsList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobAfterEffectsList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobAfterEffectsList( recordListFromPyList(a0), JobAfterEffects::table() );
%End

	~JobAfterEffectsList() /HoldGIL/;

//	void insert( JobAfterEffectsIter, const JobAfterEffects & );

//	JobAfterEffectsIter at( uint );

//	JobAfterEffectsIter find( const Record & );

//	JobAfterEffectsIter remove( const JobAfterEffectsIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobAfterEffectsIter begin();

	//JobAfterEffectsIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobAfterEffectsList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobAfterEffectsList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobAfterEffectsList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobAfterEffectsList unique() const;
	MappedJobAfterEffectsList reversed() const;
	MappedJobAfterEffectsList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobAfterEffects::schema() );
%End

	QList<bool> ignoreMissingEffectses() const /HoldGIL/;
	MappedJobAfterEffectsList & setIgnoreMissingEffectses( const bool & );
	QStringList comps() const /HoldGIL/;
	MappedJobAfterEffectsList & setComps( const QString & );


};


