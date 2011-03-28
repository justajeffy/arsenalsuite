
%MappedType MappedJobHistoryType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhistorytypelist.h"
#include "jobhistorytypetable.h"
#define MappedJobHistoryType JobHistoryType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobHistoryType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobHistoryTypeSchema::instance() );
%End
};

class JobHistoryType : Record
{
%TypeHeaderCode
#include <jobhistorytype.h>

%End
public:
	JobHistoryType();

	JobHistoryType( uint key );

	JobHistoryType( const JobHistoryType & other );

	JobHistoryType( const Record & r );

	JobHistoryType( RecordImp * imp, bool checkType = true );
	
	MappedJobHistoryType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString type() const;
	MappedJobHistoryType & setType( const QString & );


	static MappedJobHistoryTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobHistoryType reload( bool lockForUpdate = false );

	static MappedJobHistoryType recordByName( const QString &type );






	static Table * table();
	//static JobHistoryTypeSchema * schema();
};


