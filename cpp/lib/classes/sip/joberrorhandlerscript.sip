
%MappedType MappedJobErrorHandlerScript
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "joberrorhandlerscriptlist.h"
#include "joberrorhandlerscripttable.h"
#define MappedJobErrorHandlerScript JobErrorHandlerScript
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobErrorHandlerScript(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobErrorHandlerScriptSchema::instance() );
%End
};

class JobErrorHandlerScript : Record
{
%TypeHeaderCode
#include <joberrorhandlerscript.h>

%End
public:
	JobErrorHandlerScript() /HoldGIL/;

	JobErrorHandlerScript( uint key ) throw(SqlException,LostConnectionException,PythonException);

	JobErrorHandlerScript( const JobErrorHandlerScript & other ) /HoldGIL/;

	JobErrorHandlerScript( const Record & r ) /HoldGIL/;

	JobErrorHandlerScript( RecordImp * imp, bool checkType = true ) /HoldGIL/;
	
	MappedJobErrorHandlerScript copy() const /HoldGIL/;

	bool operator==( const Record & other ) const /HoldGIL/;

	bool operator!=( const Record & other ) const /HoldGIL/;
	
	bool operator <( const Record & other ) const /HoldGIL/;

	long __hash__() const /HoldGIL/;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString script() const /HoldGIL/;
	MappedJobErrorHandlerScript & setScript( const QString & );


	static MappedJobErrorHandlerScriptList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() ) throw(SqlException,LostConnectionException,PythonException);
	static MappedJobErrorHandlerScriptList select( const Expression & ) throw(SqlException,LostConnectionException,PythonException);

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
			sipRes = new JoinedSelect(JobErrorHandlerScript::table()->join( inst, *a1, a2, a3, *a4 ));
		}
%End

	MappedJobErrorHandlerScript reload( bool lockForUpdate = false ) throw(SqlException,LostConnectionException,PythonException);







	struct _c {
		StaticFieldExpression Key;
		StaticFieldExpression Script;

	private:
		_c();
	};
	static _c c;

	static Table * table() /HoldGIL/;
	//static JobErrorHandlerScriptSchema * schema();
};


