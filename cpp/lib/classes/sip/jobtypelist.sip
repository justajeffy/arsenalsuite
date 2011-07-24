


%MappedType MappedJobTypeList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobtypelist.h"
#include "jobtypetable.h"
#define MappedJobTypeList JobTypeList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobTypeSchema::instance() );
%End
};

class JobTypeList : RecordList
{
%TypeHeaderCode
#include <jobtypelist.h>
#include "service.h"
#include "jobtypemapping.h"

%End
public:
	JobTypeList();
	JobTypeList( const RecordList &, Table * t = 0 );
	JobTypeList( const JobTypeList & );
	JobTypeList( const Record &, Table * t = 0 );
	
	~JobTypeList();

//	void insert( JobTypeIter, const JobType & );

//	JobTypeIter at( uint );

//	JobTypeIter find( const Record & );

//	JobTypeIter remove( const JobTypeIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobTypeIter begin();

	//JobTypeIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobTypeList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobTypeList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobTypeList sorted( const QString & c, bool a = true ) const;

	MappedJobTypeList unique() const;
	MappedJobTypeList reversed() const;
	MappedJobTypeList reloaded() const;

	QStringList names() const;
	MappedJobTypeList & setNames( const QString & );
	MappedServiceList services() const;
	MappedJobTypeList & setServices( const Service & );
	QList<QImage> icons() const;
	MappedJobTypeList & setIcons( const QImage & );
	MappedJobTypeMappingList jobTypeMappings();


};


