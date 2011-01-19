
%MappedType MappedJobXSIScript
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsiscriptlist.h"
#include "jobxsiscripttable.h"
#define MappedJobXSIScript JobXSIScript
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobXSIScript(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobXSIScriptSchema::instance() );
%End
};

class JobXSIScript : Job
{
%TypeHeaderCode
#include <jobxsiscript.h>

%End
public:
	JobXSIScript();

	JobXSIScript( uint key );

	JobXSIScript( const JobXSIScript & other );

	JobXSIScript( const Record & r );

	JobXSIScript( RecordImp * imp, bool checkType = true );
	
	MappedJobXSIScript copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	int frameStart() const;
	MappedJobXSIScript & setFrameStart( const int & );
	int frameEnd() const;
	MappedJobXSIScript & setFrameEnd( const int & );
	bool scriptRequiresUi() const;
	MappedJobXSIScript & setScriptRequiresUi( const bool & );
	QString scriptFile() const;
	MappedJobXSIScript & setScriptFile( const QString & );
	QString xsiFile() const;
	MappedJobXSIScript & setXsiFile( const QString & );
	QString scriptMethod() const;
	MappedJobXSIScript & setScriptMethod( const QString & );
	QString frameList() const;
	MappedJobXSIScript & setFrameList( const QString & );


	static MappedJobXSIScriptList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobXSIScript reload( bool lockForUpdate = false );







	static Table * table();
	//static JobXSIScriptSchema * schema();
};


