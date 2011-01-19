
%MappedType MappedGruntScript
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "gruntscriptlist.h"
#include "gruntscripttable.h"
#define MappedGruntScript GruntScript
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new GruntScript(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, GruntScriptSchema::instance() );
%End
};

class GruntScript : Record
{
%TypeHeaderCode
#include <gruntscript.h>

%End
public:
	GruntScript();

	GruntScript( uint key );

	GruntScript( const GruntScript & other );

	GruntScript( const Record & r );

	GruntScript( RecordImp * imp, bool checkType = true );
	
	MappedGruntScript copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint runCount() const;
	MappedGruntScript & setRunCount( const uint & );
	QDate lastRun() const;
	MappedGruntScript & setLastRun( const QDate & );
	QString name() const;
	MappedGruntScript & setName( const QString & );


	static MappedGruntScriptList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedGruntScript reload( bool lockForUpdate = false );

	static MappedGruntScript recordByName( const QString &scriptName );






	static Table * table();
	//static GruntScriptSchema * schema();
};


