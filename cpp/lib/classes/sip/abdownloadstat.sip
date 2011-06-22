
%MappedType MappedAbDownloadStat
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "abdownloadstatlist.h"
#include "abdownloadstattable.h"
#define MappedAbDownloadStat AbDownloadStat
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new AbDownloadStat(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, AbDownloadStatSchema::instance() );
%End
};

class AbDownloadStat : Record
{
%TypeHeaderCode
#include <abdownloadstat.h>
#include "host.h"
#include "job.h"

%End
public:
	AbDownloadStat();

	AbDownloadStat( uint key );

	AbDownloadStat( const AbDownloadStat & other );

	AbDownloadStat( const Record & r );

	AbDownloadStat( RecordImp * imp, bool checkType = true );
	
	MappedAbDownloadStat copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString type() const;
	MappedAbDownloadStat & setType( const QString & );
	int size() const;
	MappedAbDownloadStat & setSize( const int & );
	int time() const;
	MappedAbDownloadStat & setTime( const int & );
	MappedHost host() const;
	MappedAbDownloadStat & setHost( const Host & );
	int abrev() const;
	MappedAbDownloadStat & setAbrev( const int & );
	QDateTime finished() const;
	MappedAbDownloadStat & setFinished( const QDateTime & );
	MappedJob job() const;
	MappedAbDownloadStat & setJob( const Job & );


	static MappedAbDownloadStatList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedAbDownloadStat reload( bool lockForUpdate = false );







	static Table * table();
	//static AbDownloadStatSchema * schema();
};


