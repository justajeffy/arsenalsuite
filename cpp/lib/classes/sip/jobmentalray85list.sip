


%MappedType MappedJobMentalRay85List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray85list.h"
#include "jobmentalray85table.h"
#define MappedJobMentalRay85List JobMentalRay85List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMentalRay85Schema::instance() );
%End
};

class JobMentalRay85List : JobMayaList
{
%TypeHeaderCode
#include <jobmentalray85list.h>

%End
public:
	JobMentalRay85List();
	JobMentalRay85List( const RecordList &, Table * t = 0 );
	JobMentalRay85List( const JobMentalRay85List & );
	JobMentalRay85List( const Record &, Table * t = 0 );
	
	~JobMentalRay85List();

//	void insert( JobMentalRay85Iter, const JobMentalRay85 & );

//	JobMentalRay85Iter at( uint );

//	JobMentalRay85Iter find( const Record & );

//	JobMentalRay85Iter remove( const JobMentalRay85Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMentalRay85Iter begin();

	//JobMentalRay85Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMentalRay85List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMentalRay85List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMentalRay85List sorted( const QString & c, bool a = true ) const;

	MappedJobMentalRay85List unique() const;
	MappedJobMentalRay85List reversed() const;
	MappedJobMentalRay85List reloaded() const;



};


