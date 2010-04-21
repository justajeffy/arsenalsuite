


%MappedType MappedAbDownloadStatList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "abdownloadstatlist.h"
#include "abdownloadstattable.h"
#define MappedAbDownloadStatList AbDownloadStatList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, AbDownloadStatSchema::instance() );
%End
};

class AbDownloadStatList : RecordList
{
%TypeHeaderCode
#include <abdownloadstatlist.h>
#include "host.h"
#include "job.h"

%End
public:
	AbDownloadStatList();
	AbDownloadStatList( const RecordList &, Table * t = 0 );
	AbDownloadStatList( const AbDownloadStatList & );
	AbDownloadStatList( const Record &, Table * t = 0 );
	
	~AbDownloadStatList();

//	void insert( AbDownloadStatIter, const AbDownloadStat & );

//	AbDownloadStatIter at( uint );

//	AbDownloadStatIter find( const Record & );

//	AbDownloadStatIter remove( const AbDownloadStatIter & );

	int remove( const Record & );
	
	int remove();
	
	//AbDownloadStatIter begin();

	//AbDownloadStatIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedAbDownloadStatList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedAbDownloadStatList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedAbDownloadStatList sorted( const QString & c, bool a = true ) const;

	MappedAbDownloadStatList unique() const;
	MappedAbDownloadStatList reversed() const;
	MappedAbDownloadStatList reloaded() const;

	QStringList types() const;
	MappedAbDownloadStatList & setTypes( const QString & );
	QList<int> sizes() const;
	MappedAbDownloadStatList & setSizes( const int & );
	QList<int> times() const;
	MappedAbDownloadStatList & setTimes( const int & );
	MappedHostList hosts() const;
	MappedAbDownloadStatList & setHosts( const Host & );
	QList<int> abrevs() const;
	MappedAbDownloadStatList & setAbrevs( const int & );
	QList<QDateTime> finished() const;
	MappedAbDownloadStatList & setFinished( const QDateTime & );
	MappedJobList jobs() const;
	MappedAbDownloadStatList & setJobs( const Job & );


};


