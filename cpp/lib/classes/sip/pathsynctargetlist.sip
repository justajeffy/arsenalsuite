


%MappedType MappedPathSyncTargetList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathsynctargetlist.h"
#include "pathsynctargettable.h"
#define MappedPathSyncTargetList PathSyncTargetList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, PathSyncTargetSchema::instance() );
%End
};

class PathSyncTargetList : RecordList
{
%TypeHeaderCode
#include <pathsynctargetlist.h>
#include "pathtracker.h"
#include "projectstorage.h"

%End
public:
	PathSyncTargetList();
	PathSyncTargetList( const RecordList &, Table * t = 0 );
	PathSyncTargetList( const PathSyncTargetList & );
	PathSyncTargetList( const Record &, Table * t = 0 );
	
	~PathSyncTargetList();

//	void insert( PathSyncTargetIter, const PathSyncTarget & );

//	PathSyncTargetIter at( uint );

//	PathSyncTargetIter find( const Record & );

//	PathSyncTargetIter remove( const PathSyncTargetIter & );

	int remove( const Record & );
	
	int remove();
	
	//PathSyncTargetIter begin();

	//PathSyncTargetIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedPathSyncTargetList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedPathSyncTargetList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedPathSyncTargetList sorted( const QString & c, bool a = true ) const;

	MappedPathSyncTargetList unique() const;
	MappedPathSyncTargetList reversed() const;
	MappedPathSyncTargetList reloaded() const;

	MappedPathTrackerList pathTrackers() const;
	MappedPathSyncTargetList & setPathTrackers( const PathTracker & );
	MappedProjectStorageList projectStorages() const;
	MappedPathSyncTargetList & setProjectStorages( const ProjectStorage & );


};


