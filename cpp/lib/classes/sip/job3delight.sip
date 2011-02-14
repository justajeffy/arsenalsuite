
%MappedType MappedJob3Delight
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "job3delightlist.h"
#include "job3delighttable.h"
#define MappedJob3Delight Job3Delight
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Job3Delight(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, Job3DelightSchema::instance() );
%End
};

class Job3Delight : Job
{
%TypeHeaderCode
#include <job3delight.h>

%End
public:
	Job3Delight();

	Job3Delight( uint key );

	Job3Delight( const Job3Delight & other );

	Job3Delight( const Record & r );

	Job3Delight( RecordImp * imp, bool checkType = true );
	
	MappedJob3Delight copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint width() const;
	MappedJob3Delight & setWidth( const uint & );
	uint height() const;
	MappedJob3Delight & setHeight( const uint & );
	uint frameStart() const;
	MappedJob3Delight & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJob3Delight & setFrameEnd( const uint & );
	/**
	  * launch the render using 'n' threads
	  **/
	uint threads() const;
	MappedJob3Delight & setThreads( const uint & );
	/**
	  * launch the render using 'n' processes
	  **/
	uint processes() const;
	MappedJob3Delight & setProcesses( const uint & );
	/**
	  * use 'script' to start renders
	  **/
	QString jobscript() const;
	MappedJob3Delight & setJobscript( const QString & );
	/**
	  * passes 'p' as the first parameter of script
	  **/
	QString jobscriptparam() const;
	MappedJob3Delight & setJobscriptparam( const QString & );
	/**
	  * Override the default call to "renderdl" binary.
	  **/
	QString renderdlCmd() const;
	MappedJob3Delight & setRenderdlCmd( const QString & );


	static MappedJob3DelightList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJob3Delight reload( bool lockForUpdate = false );







	static Table * table();
	//static Job3DelightSchema * schema();
};


