
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
	JobErrorHandler();

	JobErrorHandler( uint key );

	JobErrorHandler( const JobErrorHandler & other );

	JobErrorHandler( const Record & r );

	JobErrorHandler( RecordImp * imp, bool checkType = true );
	
	MappedJobErrorHandler copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedJobType jobType() const;
	MappedJobErrorHandler & setJobType( const JobType & );
	QString errorRegEx() const;
	MappedJobErrorHandler & setErrorRegEx( const QString & );
	MappedJobErrorHandlerScript jobErrorHandlerScript() const;
	MappedJobErrorHandler & setJobErrorHandlerScript( const JobErrorHandlerScript & );


	static MappedJobErrorHandlerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobErrorHandler reload( bool lockForUpdate = false );







	static Table * table();
	//static JobErrorHandlerSchema * schema();
};


