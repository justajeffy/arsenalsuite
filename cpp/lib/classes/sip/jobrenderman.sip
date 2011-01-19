
%MappedType MappedJobRenderMan
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobrendermanlist.h"
#include "jobrendermantable.h"
#define MappedJobRenderMan JobRenderMan
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobRenderMan(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobRenderManSchema::instance() );
%End
};

class JobRenderMan : Job
{
%TypeHeaderCode
#include <jobrenderman.h>

%End
public:
	JobRenderMan();

	JobRenderMan( uint key );

	JobRenderMan( const JobRenderMan & other );

	JobRenderMan( const Record & r );

	JobRenderMan( RecordImp * imp, bool checkType = true );
	
	MappedJobRenderMan copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobRenderMan & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobRenderMan & setFrameEnd( const uint & );
	QString version() const;
	MappedJobRenderMan & setVersion( const QString & );


	static MappedJobRenderManList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobRenderMan reload( bool lockForUpdate = false );







	static Table * table();
	//static JobRenderManSchema * schema();
};


