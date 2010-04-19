
%MappedType MappedJobType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtypelist.h"
#include "jobtypetable.h"
#define MappedJobType JobType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobTypeSchema::instance() );
%End
};

class JobType : Record
{
%TypeHeaderCode
#include <jobtype.h>
#include "service.h"
#include "jobtypemapping.h"

%End
public:
	JobType();

	JobType( uint key );

	JobType( const JobType & other );

	JobType( const Record & r );

	JobType( RecordImp * imp, bool checkType = true );
	
	MappedJobType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedJobType & setName( const QString & );
	MappedService service() const;
	MappedJobType & setService( const Service & );
	QImage icon() const;
	MappedJobType & setIcon( const QImage & );
	MappedJobTypeMappingList jobTypeMappings() const;


	static MappedJobTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobType reload( bool lockForUpdate = false );

	static MappedJobTypeList recordsByService( const Service &fkeyService );
	static MappedJobType recordByName( const QString &jobType );






	static Table * table();
	//static JobTypeSchema * schema();
};


