


%MappedType MappedPathTrackerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathtrackerlist.h"
#include "pathtrackertable.h"
#define MappedPathTrackerList PathTrackerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, PathTrackerSchema::instance() );
%End
};

class PathTrackerList : RecordList
{
%TypeHeaderCode
#include <pathtrackerlist.h>
#include "element.h"
#include "pathtemplate.h"
#include "projectstorage.h"

%End
public:
	PathTrackerList();
	PathTrackerList( const RecordList &, Table * t = 0 );
	PathTrackerList( const PathTrackerList & );
	PathTrackerList( const Record &, Table * t = 0 );
	
	~PathTrackerList();

//	void insert( PathTrackerIter, const PathTracker & );

//	PathTrackerIter at( uint );

//	PathTrackerIter find( const Record & );

//	PathTrackerIter remove( const PathTrackerIter & );

	int remove( const Record & );
	
	int remove();
	
	//PathTrackerIter begin();

	//PathTrackerIter end();

	Table * table() const;
	TableSchema * schema() const;

	MappedPathTrackerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const;
	MappedPathTrackerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const;
	MappedPathTrackerList sorted( const QString & c, bool a = true ) const;

	MappedPathTrackerList unique() const;
	MappedPathTrackerList reversed() const;
	MappedPathTrackerList reloaded() const;

	MappedElementList elements() const;
	MappedPathTrackerList & setElements( const Element & );
	QStringList pathRaws() const;
	MappedPathTrackerList & setPathRaws( const QString & );
	MappedPathTemplateList pathTemplates() const;
	MappedPathTrackerList & setPathTemplates( const PathTemplate & );
	MappedProjectStorageList projectStorages() const;
	MappedPathTrackerList & setProjectStorages( const ProjectStorage & );
	QStringList storageNames() const;
	MappedPathTrackerList & setStorageNames( const QString & );


};


