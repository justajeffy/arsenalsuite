


%MappedType MappedJobMax6List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax6list.h"
#include "jobmax6table.h"
#define MappedJobMax6List JobMax6List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax6Schema::instance() );
%End
};

class JobMax6List : JobList
{
%TypeHeaderCode
#include <jobmax6list.h>

%End
public:
	JobMax6List();
	JobMax6List( const RecordList &, Table * t = 0 );
	JobMax6List( const JobMax6List & );
	JobMax6List( const Record &, Table * t = 0 );
	
	~JobMax6List();

//	void insert( JobMax6Iter, const JobMax6 & );

//	JobMax6Iter at( uint );

//	JobMax6Iter find( const Record & );

//	JobMax6Iter remove( const JobMax6Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax6Iter begin();

	//JobMax6Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax6List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax6List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax6List sorted( const QString & c, bool a = true ) const;

	MappedJobMax6List unique() const;
	MappedJobMax6List reversed() const;
	MappedJobMax6List reloaded() const;

	QStringList cameras() const;
	MappedJobMax6List & setCameras( const QString & );
	QStringList elementFiles() const;
	MappedJobMax6List & setElementFiles( const QString & );
	QStringList fileOriginals() const;
	MappedJobMax6List & setFileOriginals( const QString & );
	QList<uint> flag_hs() const;
	MappedJobMax6List & setFlag_hs( const uint & );
	QList<uint> flag_vs() const;
	MappedJobMax6List & setFlag_vs( const uint & );
	QList<uint> flag_ws() const;
	MappedJobMax6List & setFlag_ws( const uint & );
	QList<uint> flag_x2s() const;
	MappedJobMax6List & setFlag_x2s( const uint & );
	QList<uint> flag_xas() const;
	MappedJobMax6List & setFlag_xas( const uint & );
	QList<uint> flag_xcs() const;
	MappedJobMax6List & setFlag_xcs( const uint & );
	QList<uint> flag_xds() const;
	MappedJobMax6List & setFlag_xds( const uint & );
	QList<uint> flag_xes() const;
	MappedJobMax6List & setFlag_xes( const uint & );
	QList<uint> flag_xfs() const;
	MappedJobMax6List & setFlag_xfs( const uint & );
	QList<uint> flag_xhs() const;
	MappedJobMax6List & setFlag_xhs( const uint & );
	QList<uint> flag_xks() const;
	MappedJobMax6List & setFlag_xks( const uint & );
	QList<uint> flag_xns() const;
	MappedJobMax6List & setFlag_xns( const uint & );
	QList<uint> flag_xos() const;
	MappedJobMax6List & setFlag_xos( const uint & );
	QList<uint> flag_xps() const;
	MappedJobMax6List & setFlag_xps( const uint & );
	QList<uint> flag_xvs() const;
	MappedJobMax6List & setFlag_xvs( const uint & );
	QList<uint> frameEnds() const;
	MappedJobMax6List & setFrameEnds( const uint & );
	QStringList frameLists() const;
	MappedJobMax6List & setFrameLists( const QString & );
	QList<uint> frameStarts() const;
	MappedJobMax6List & setFrameStarts( const uint & );


};


