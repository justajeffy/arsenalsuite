


%MappedType MappedJobHistoryTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobhistorytypelist.h"
#include "jobhistorytypetable.h"
#define MappedJobHistoryTypeList JobHistoryTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobHistoryTypeSchema::instance() );
%End
};

class JobHistoryTypeList : RecordList
{
%TypeHeaderCode
#include <jobhistorytypelist.h>

%End
public:
	JobHistoryTypeList();
	JobHistoryTypeList( const RecordList &, Table * t = 0 );
	JobHistoryTypeList( const JobHistoryTypeList & );
	JobHistoryTypeList( const Record &, Table * t = 0 );
	
	~JobHistoryTypeList();

//	void insert( JobHistoryTypeIter, const JobHistoryType & );

//	JobHistoryTypeIter at( uint );

//	JobHistoryTypeIter find( const Record & );

//	JobHistoryTypeIter remove( const JobHistoryTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobHistoryTypeIter begin();

	//JobHistoryTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobHistoryTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobHistoryTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobHistoryTypeList sorted( const QString & c, bool a = true ) const;

	MappedJobHistoryTypeList unique() const;
	MappedJobHistoryTypeList reversed() const;
	MappedJobHistoryTypeList reloaded() const;

	QStringList types() const;
	MappedJobHistoryTypeList & setTypes( const QString & );


};


