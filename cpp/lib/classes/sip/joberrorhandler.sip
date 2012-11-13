
%MappedType MappedJobErrorHandler
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorhandlerlist.h"
#include "joberrorhandlertable.h"
#define MappedJobErrorHandler JobErrorHandler
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobErrorHandler(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobErrorHandlerSchema::instance() );
%End
};

class JobErrorHandler : Record
{
%TypeHeaderCode
#include <joberrorhandler.h>
#include "jobtype.h"
#include "joberrorhandlerscript.h"

%End
public:
	JobErrorHandler() /HoldGIL/;

	JobErrorHandler( uint key ) throw(SqlException,LostConnectionException,PythonException);

	JobErrorHandler( const JobErrorHandler & other ) /HoldGIL/;

	JobErrorHandler( const Record & r ) /HoldGIL/;

	JobErrorHandler( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedJobErrorHandler copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJobType jobType(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedJobErrorHandler & setJobType( const JobType & );
	QString errorRegEx() const /HoldGIL/;
	MappedJobErrorHandler & setErrorRegEx( const QString & );
	MappedJobErrorHandlerScript jobErrorHandlerScript(int lookupMode = Index::UseSelect|Index::PartialSelect|Index::UseCache) const /HoldGIL/;
	MappedJobErrorHandler & setJobErrorHandlerScript( const JobErrorHandlerScript & );


	static MappedJobErrorHandlerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedJobErrorHandlerList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

	static JoinedSelect join( SIP_PYOBJECT cls, QString condition = QString(), JoinType joinType = InnerJoin, bool ignoreResults = false, const QString & alias = QString() );
%MethodCode
		// Convert to python
		Table * inst = 0;

		if( !sipCanConvertToType(a0,sipType_Table,SIP_NOT_NONE) ) {
			// Attempt to get the table * by calling the static method table()
			if( !sipIsErr && !inst ) {
				PyObject * pyTableMethod = PyObject_GetAttrString( a0, "table" );
				if( pyTableMethod ) {
					PyObject * pyTable = PyObject_CallObject( pyTableMethod, 0 );
					if( pyTable && sipCanConvertToType(pyTable,sipType_Table,SIP_NOT_NONE) )
						inst = (Table*)sipConvertToType(pyTable,sipType_Table,0,SIP_NOT_NONE,0,&sipIsErr);
					Py_XDECREF(pyTable);
					Py_XDECREF(pyTableMethod);
				} else
					sipIsErr = 1;
			}
		}
		
		if( !inst && !sipIsErr && a0 && sipCanConvertToType(a0,sipType_Table,SIP_NOT_NONE) ) {
			inst = (Table*)sipConvertToType(a0,sipType_Table,0,SIP_NOT_NONE,0,&sipIsErr);
		}

		if( !sipIsErr ) {
			sipRes = new JoinedSelect(JobErrorHandler::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedJobErrorHandler reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);







	struct _c {
		StaticFieldExpression Key;
		StaticFieldExpression JobType;
		StaticFieldExpression ErrorRegEx;
		StaticFieldExpression JobErrorHandlerScript;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static JobErrorHandlerSchema * schema();
};


