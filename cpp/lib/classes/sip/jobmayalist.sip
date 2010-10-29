


%MappedType MappedJobMayaList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmayalist.h"
#include "jobmayatable.h"
#define MappedJobMayaList JobMayaList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMayaSchema::instance() );
%End
};

class JobMayaList : JobList
{
%TypeHeaderCode
#include <jobmayalist.h>

%End
public:
	JobMayaList();
	JobMayaList( const RecordList &, Table * t = 0 );
	JobMayaList( const JobMayaList & );
	JobMayaList( const Record &, Table * t = 0 );
	
	~JobMayaList();

//	void insert( JobMayaIter, const JobMaya & );

//	JobMayaIter at( uint );

//	JobMayaIter find( const Record & );

//	JobMayaIter remove( const JobMayaIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMayaIter begin();

	//JobMayaIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMayaList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMayaList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMayaList sorted( const QString & c, bool a = true ) const;

	MappedJobMayaList unique() const;
	MappedJobMayaList reversed() const;
	MappedJobMayaList reloaded() const;

	QList<int> frameStarts() const;
	MappedJobMayaList & setFrameStarts( const int & );
	QList<int> frameEnds() const;
	MappedJobMayaList & setFrameEnds( const int & );
	QStringList cameras() const;
	MappedJobMayaList & setCameras( const QString & );
	QStringList renderers() const;
	MappedJobMayaList & setRenderers( const QString & );
	QStringList projectPaths() const;
	MappedJobMayaList & setProjectPaths( const QString & );
	QList<uint> widths() const;
	MappedJobMayaList & setWidths( const uint & );
	QList<uint> heights() const;
	MappedJobMayaList & setHeights( const uint & );
	QStringList appends() const;
	MappedJobMayaList & setAppends( const QString & );


};


