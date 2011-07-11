


%MappedType MappedVersionFileTrackerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "versionfiletrackerlist.h"
#include "versionfiletrackertable.h"
#define MappedVersionFileTrackerList VersionFileTrackerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, VersionFileTrackerSchema::instance() );
%End
};

class VersionFileTrackerList : FileTrackerList
{
%TypeHeaderCode
#include <versionfiletrackerlist.h>
#include "versionfiletracker.h"

%End
public:
	VersionFileTrackerList();
	VersionFileTrackerList( const RecordList &, Table * t = 0 );
	VersionFileTrackerList( const VersionFileTrackerList & );
	VersionFileTrackerList( const Record &, Table * t = 0 );
	
	~VersionFileTrackerList();

//	void insert( VersionFileTrackerIter, const VersionFileTracker & );

//	VersionFileTrackerIter at( uint );

//	VersionFileTrackerIter find( const Record & );

//	VersionFileTrackerIter remove( const VersionFileTrackerIter & );

	int remove( const Record & );
	
	int remove();
	
	//VersionFileTrackerIter begin();

	//VersionFileTrackerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedVersionFileTrackerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedVersionFileTrackerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedVersionFileTrackerList sorted( const QString & c, bool a = true ) const;

	MappedVersionFileTrackerList unique() const;
	MappedVersionFileTrackerList reversed() const;
	MappedVersionFileTrackerList reloaded() const;

	QStringList fileNameTemplateRaws() const;
	MappedVersionFileTrackerList & setFileNameTemplateRaws( const QString & );
	MappedVersionFileTrackerList versionFileTrackers() const;
	MappedVersionFileTrackerList & setVersionFileTrackers( const VersionFileTracker & );
	QStringList oldFileNamesSingles() const;
	MappedVersionFileTrackerList & setOldFileNamesSingles( const QString & );
	QList<uint> versionRaws() const;
	MappedVersionFileTrackerList & setVersionRaws( const uint & );
	QList<uint> iterationRaws() const;
	MappedVersionFileTrackerList & setIterationRaws( const uint & );
	QList<uint> autoFinalRaws() const;
	MappedVersionFileTrackerList & setAutoFinalRaws( const uint & );


};


