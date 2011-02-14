


%MappedType MappedJobFusionList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionlist.h"
#include "jobfusiontable.h"
#define MappedJobFusionList JobFusionList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobFusionSchema::instance() );
%End
};

class JobFusionList : JobList
{
%TypeHeaderCode
#include <jobfusionlist.h>

%End
public:
	JobFusionList();
	JobFusionList( const RecordList &, Table * t = 0 );
	JobFusionList( const JobFusionList & );
	JobFusionList( const Record &, Table * t = 0 );
	
	~JobFusionList();

//	void insert( JobFusionIter, const JobFusion & );

//	JobFusionIter at( uint );

//	JobFusionIter find( const Record & );

//	JobFusionIter remove( const JobFusionIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobFusionIter begin();

	//JobFusionIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobFusionList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobFusionList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobFusionList sorted( const QString & c, bool a = true ) const;

	MappedJobFusionList unique() const;
	MappedJobFusionList reversed() const;
	MappedJobFusionList reloaded() const;

	QStringList frameLists() const;
	MappedJobFusionList & setFrameLists( const QString & );
	QList<bool> allFramesAsSingleTasks() const;
	MappedJobFusionList & setAllFramesAsSingleTasks( const bool & );
	QList<uint> outputCounts() const;
	MappedJobFusionList & setOutputCounts( const uint & );


};


