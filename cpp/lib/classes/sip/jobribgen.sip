
%MappedType MappedJobRibGen
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobribgenlist.h"
#include "jobribgentable.h"
#define MappedJobRibGen JobRibGen
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobRibGen(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobRibGenSchema::instance() );
%End
};

class JobRibGen : Job
{
%TypeHeaderCode
#include <jobribgen.h>

%End
public:
	JobRibGen();

	JobRibGen( uint key );

	JobRibGen( const JobRibGen & other );

	JobRibGen( const Record & r );

	JobRibGen( RecordImp * imp, bool checkType = true );
	
	MappedJobRibGen copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobRibGen & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobRibGen & setFrameEnd( const uint & );
	QString version() const;
	MappedJobRibGen & setVersion( const QString & );


	static MappedJobRibGenList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobRibGen reload( bool lockForUpdate = false );







	static Table * table();
	//static JobRibGenSchema * schema();
};


