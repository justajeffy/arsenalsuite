
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
	JobErrorHandlerScript();

	JobErrorHandlerScript( uint key );

	JobErrorHandlerScript( const JobErrorHandlerScript & other );

	JobErrorHandlerScript( const Record & r );

	JobErrorHandlerScript( RecordImp * imp, bool checkType = true );
	
	MappedJobErrorHandlerScript copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString script() const;
	MappedJobErrorHandlerScript & setScript( const QString & );


	static MappedJobErrorHandlerScriptList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobErrorHandlerScript reload( bool lockForUpdate = false );







	static Table * table();
	//static JobErrorHandlerScriptSchema * schema();
};


