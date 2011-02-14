
%MappedType MappedJobShake
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobshakelist.h"
#include "jobshaketable.h"
#define MappedJobShake JobShake
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobShake(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobShakeSchema::instance() );
%End
};

class JobShake : Job
{
%TypeHeaderCode
#include <jobshake.h>

%End
public:
	JobShake();

	JobShake( uint key );

	JobShake( const JobShake & other );

	JobShake( const Record & r );

	JobShake( RecordImp * imp, bool checkType = true );
	
	MappedJobShake copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobShake & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobShake & setFrameEnd( const uint & );
	QString codec() const;
	MappedJobShake & setCodec( const QString & );
	QString slatePath() const;
	MappedJobShake & setSlatePath( const QString & );
	QString frameRange() const;
	MappedJobShake & setFrameRange( const QString & );


	static MappedJobShakeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobShake reload( bool lockForUpdate = false );







	static Table * table();
	//static JobShakeSchema * schema();
};


