


%MappedType MappedJobCinema4DList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobcinema4dlist.h"
#include "jobcinema4dtable.h"
#define MappedJobCinema4DList JobCinema4DList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobCinema4DSchema::instance() );
%End
};

class JobCinema4DList : JobList
{
%TypeHeaderCode
#include <jobcinema4dlist.h>

%End
public:
	JobCinema4DList();
	JobCinema4DList( const RecordList &, Table * t = 0 );
	JobCinema4DList( const JobCinema4DList & );
	JobCinema4DList( const Record &, Table * t = 0 );
	
	~JobCinema4DList();

//	void insert( JobCinema4DIter, const JobCinema4D & );

//	JobCinema4DIter at( uint );

//	JobCinema4DIter find( const Record & );

//	JobCinema4DIter remove( const JobCinema4DIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobCinema4DIter begin();

	//JobCinema4DIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobCinema4DList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobCinema4DList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobCinema4DList sorted( const QString & c, bool a = true ) const;

	MappedJobCinema4DList unique() const;
	MappedJobCinema4DList reversed() const;
	MappedJobCinema4DList reloaded() const;



};


