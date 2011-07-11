


%MappedType MappedJobMax5List
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax5list.h"
#include "jobmax5table.h"
#define MappedJobMax5List JobMax5List
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMax5Schema::instance() );
%End
};

class JobMax5List : JobList
{
%TypeHeaderCode
#include <jobmax5list.h>

%End
public:
	JobMax5List();
	JobMax5List( const RecordList &, Table * t = 0 );
	JobMax5List( const JobMax5List & );
	JobMax5List( const Record &, Table * t = 0 );
	
	~JobMax5List();

//	void insert( JobMax5Iter, const JobMax5 & );

//	JobMax5Iter at( uint );

//	JobMax5Iter find( const Record & );

//	JobMax5Iter remove( const JobMax5Iter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMax5Iter begin();

	//JobMax5Iter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMax5List filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMax5List filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMax5List sorted( const QString & c, bool a = true ) const;

	MappedJobMax5List unique() const;
	MappedJobMax5List reversed() const;
	MappedJobMax5List reloaded() const;

	QStringList cameras() const;
	MappedJobMax5List & setCameras( const QString & );
	QStringList fileOriginals() const;
	MappedJobMax5List & setFileOriginals( const QString & );
	QList<uint> flag_hs() const;
	MappedJobMax5List & setFlag_hs( const uint & );
	QList<uint> frameStarts() const;
	MappedJobMax5List & setFrameStarts( const uint & );
	QList<uint> frameEnds() const;
	MappedJobMax5List & setFrameEnds( const uint & );
	QList<uint> flag_ws() const;
	MappedJobMax5List & setFlag_ws( const uint & );
	QList<uint> flag_xvs() const;
	MappedJobMax5List & setFlag_xvs( const uint & );
	QList<uint> flag_x2s() const;
	MappedJobMax5List & setFlag_x2s( const uint & );
	QList<uint> flag_xas() const;
	MappedJobMax5List & setFlag_xas( const uint & );
	QList<uint> flag_xes() const;
	MappedJobMax5List & setFlag_xes( const uint & );
	QList<uint> flag_xks() const;
	MappedJobMax5List & setFlag_xks( const uint & );
	QList<uint> flag_xds() const;
	MappedJobMax5List & setFlag_xds( const uint & );
	QList<uint> flag_xhs() const;
	MappedJobMax5List & setFlag_xhs( const uint & );
	QList<uint> flag_xos() const;
	MappedJobMax5List & setFlag_xos( const uint & );
	QList<uint> flag_xfs() const;
	MappedJobMax5List & setFlag_xfs( const uint & );
	QList<uint> flag_xns() const;
	MappedJobMax5List & setFlag_xns( const uint & );
	QList<uint> flag_xps() const;
	MappedJobMax5List & setFlag_xps( const uint & );
	QList<uint> flag_xcs() const;
	MappedJobMax5List & setFlag_xcs( const uint & );
	QList<uint> flag_vs() const;
	MappedJobMax5List & setFlag_vs( const uint & );
	QStringList elementFiles() const;
	MappedJobMax5List & setElementFiles( const QString & );
	QStringList frameLists() const;
	MappedJobMax5List & setFrameLists( const QString & );


};


