
%MappedType MappedJobAutodeskBurn
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobautodeskburnlist.h"
#include "jobautodeskburntable.h"
#define MappedJobAutodeskBurn JobAutodeskBurn
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAutodeskBurn(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAutodeskBurnSchema::instance() );
%End
};

class JobAutodeskBurn : Job
{
%TypeHeaderCode
#include <jobautodeskburn.h>

%End
public:
	JobAutodeskBurn();

	JobAutodeskBurn( uint key );

	JobAutodeskBurn( const JobAutodeskBurn & other );

	JobAutodeskBurn( const Record & r );

	JobAutodeskBurn( RecordImp * imp, bool checkType = true );
	
	MappedJobAutodeskBurn copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobAutodeskBurn & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobAutodeskBurn & setFrameEnd( const uint & );
	QString handle() const;
	MappedJobAutodeskBurn & setHandle( const QString & );


	static MappedJobAutodeskBurnList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAutodeskBurn reload( bool lockForUpdate = false );

	static MappedJobAutodeskBurn recordBynameAndHandle( const QString &job, const QString &handle );






	static Table * table();
	//static JobAutodeskBurnSchema * schema();
};


