


%MappedType MappedJobMaxList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaxlist.h"
#include "jobmaxtable.h"
#define MappedJobMaxList JobMaxList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobMaxSchema::instance() );
%End
};

class JobMaxList : JobList
{
%TypeHeaderCode
#include <jobmaxlist.h>

%End
public:
	JobMaxList();
	JobMaxList( const RecordList &, Table * t = 0 );
	JobMaxList( const JobMaxList & );
	JobMaxList( const Record &, Table * t = 0 );
	
	~JobMaxList();

//	void insert( JobMaxIter, const JobMax & );

//	JobMaxIter at( uint );

//	JobMaxIter find( const Record & );

//	JobMaxIter remove( const JobMaxIter & );

	int remove( const Record & );
	
	int remove();
	
	//JobMaxIter begin();

	//JobMaxIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedJobMaxList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedJobMaxList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedJobMaxList sorted( const QString & c, bool a = true ) const;

	MappedJobMaxList unique() const;
	MappedJobMaxList reversed() const;
	MappedJobMaxList reloaded() const;

	QStringList cameras() const;
	MappedJobMaxList & setCameras( const QString & );
	QStringList elementFiles() const;
	MappedJobMaxList & setElementFiles( const QString & );
	QStringList fileOriginals() const;
	MappedJobMaxList & setFileOriginals( const QString & );
	QList<uint> flag_hs() const;
	MappedJobMaxList & setFlag_hs( const uint & );
	QList<uint> flag_vs() const;
	MappedJobMaxList & setFlag_vs( const uint & );
	QList<uint> flag_ws() const;
	MappedJobMaxList & setFlag_ws( const uint & );
	QList<uint> flag_x2s() const;
	MappedJobMaxList & setFlag_x2s( const uint & );
	QList<uint> flag_xas() const;
	MappedJobMaxList & setFlag_xas( const uint & );
	QList<uint> flag_xcs() const;
	MappedJobMaxList & setFlag_xcs( const uint & );
	QList<uint> flag_xds() const;
	MappedJobMaxList & setFlag_xds( const uint & );
	QList<uint> flag_xes() const;
	MappedJobMaxList & setFlag_xes( const uint & );
	QList<uint> flag_xfs() const;
	MappedJobMaxList & setFlag_xfs( const uint & );
	QList<uint> flag_xhs() const;
	MappedJobMaxList & setFlag_xhs( const uint & );
	QList<uint> flag_xks() const;
	MappedJobMaxList & setFlag_xks( const uint & );
	QList<uint> flag_xns() const;
	MappedJobMaxList & setFlag_xns( const uint & );
	QList<uint> flag_xos() const;
	MappedJobMaxList & setFlag_xos( const uint & );
	QList<uint> flag_xps() const;
	MappedJobMaxList & setFlag_xps( const uint & );
	QList<uint> flag_xvs() const;
	MappedJobMaxList & setFlag_xvs( const uint & );
	QList<uint> frameEnds() const;
	MappedJobMaxList & setFrameEnds( const uint & );
	QStringList frameLists() const;
	MappedJobMaxList & setFrameLists( const QString & );
	QList<uint> frameStarts() const;
	MappedJobMaxList & setFrameStarts( const uint & );
	QStringList exrChannels() const;
	MappedJobMaxList & setExrChannels( const QString & );
	QStringList exrAttributeses() const;
	MappedJobMaxList & setExrAttributeses( const QString & );
	QStringList startupScripts() const;
	MappedJobMaxList & setStartupScripts( const QString & );
	QList<int> exrSaveBitDepths() const;
	MappedJobMaxList & setExrSaveBitDepths( const int & );


};


