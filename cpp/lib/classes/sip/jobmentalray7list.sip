


%MappedType MappedJobMentalRay7List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray7list.h"
#include "jobmentalray7table.h"
#define MappedJobMentalRay7List JobMentalRay7List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMentalRay7Schema::instance() );
%End
};

class JobMentalRay7List : JobMayaList
{
%TypeHeaderCode
#include <jobmentalray7list.h>

%End
public:
	JobMentalRay7List();
	JobMentalRay7List( const RecordList &, Table * t = 0 );
	JobMentalRay7List( const JobMentalRay7List & );
	JobMentalRay7List( const Record &, Table * t = 0 );
	
	~JobMentalRay7List();

//	void insert( JobMentalRay7Iter, const JobMentalRay7 & );

//	JobMentalRay7Iter at( uint );

//	JobMentalRay7Iter find( const Record & );

//	JobMentalRay7Iter remove( const JobMentalRay7Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMentalRay7Iter begin();

	//JobMentalRay7Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMentalRay7List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMentalRay7List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMentalRay7List sorted( const QString & c, bool a = true ) const;

	MappedJobMentalRay7List unique() const;
	MappedJobMentalRay7List reversed() const;
	MappedJobMentalRay7List reloaded() const;



};


