


%MappedType MappedJobMentalRay8List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmentalray8list.h"
#include "jobmentalray8table.h"
#define MappedJobMentalRay8List JobMentalRay8List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMentalRay8Schema::instance() );
%End
};

class JobMentalRay8List : JobMayaList
{
%TypeHeaderCode
#include <jobmentalray8list.h>

%End
public:
	JobMentalRay8List();
	JobMentalRay8List( const RecordList &, Table * t = 0 );
	JobMentalRay8List( const JobMentalRay8List & );
	JobMentalRay8List( const Record &, Table * t = 0 );
	
	~JobMentalRay8List();

//	void insert( JobMentalRay8Iter, const JobMentalRay8 & );

//	JobMentalRay8Iter at( uint );

//	JobMentalRay8Iter find( const Record & );

//	JobMentalRay8Iter remove( const JobMentalRay8Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMentalRay8Iter begin();

	//JobMentalRay8Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMentalRay8List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMentalRay8List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMentalRay8List sorted( const QString & c, bool a = true ) const;

	MappedJobMentalRay8List unique() const;
	MappedJobMentalRay8List reversed() const;
	MappedJobMentalRay8List reloaded() const;



};


