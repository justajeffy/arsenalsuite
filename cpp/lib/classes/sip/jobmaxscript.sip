
%MappedType MappedJobMaxScript
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaxscriptlist.h"
#include "jobmaxscripttable.h"
#define MappedJobMaxScript JobMaxScript
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaxScript(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaxScriptSchema::instance() );
%End
};

class JobMaxScript : Job
{
%TypeHeaderCode
#include <jobmaxscript.h>

%End
public:
	JobMaxScript();

	JobMaxScript( uint key );

	JobMaxScript( const JobMaxScript & other );

	JobMaxScript( const Record & r );

	JobMaxScript( RecordImp * imp, bool checkType = true );
	
	MappedJobMaxScript copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString script() const;
	MappedJobMaxScript & setScript( const QString & );
	uint maxTime() const;
	MappedJobMaxScript & setMaxTime( const uint & );
	QString outputFiles() const;
	MappedJobMaxScript & setOutputFiles( const QString & );
	bool silent() const;
	MappedJobMaxScript & setSilent( const bool & );
	QString maxVersion() const;
	MappedJobMaxScript & setMaxVersion( const QString & );
	bool runMax64() const;
	MappedJobMaxScript & setRunMax64( const bool & );


	static MappedJobMaxScriptList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaxScript reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaxScriptSchema * schema();
};


