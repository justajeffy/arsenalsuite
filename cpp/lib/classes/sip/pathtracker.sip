
%MappedType MappedPathTracker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathtrackerlist.h"
#include "pathtrackertable.h"
#define MappedPathTracker PathTracker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new PathTracker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, PathTrackerSchema::instance() );
%End
};

class PathTracker : Record
{
%TypeHeaderCode
#include <pathtracker.h>
#include "element.h"
#include "pathtemplate.h"
#include "projectstorage.h"

%End
public:
	PathTracker();

	PathTracker( uint key );

	PathTracker( const PathTracker & other );

	PathTracker( const Record & r );

	PathTracker( RecordImp * imp, bool checkType = true );
	
	MappedPathTracker copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedElement element() const;
	MappedPathTracker & setElement( const Element & );
	QString pathRaw() const;
	MappedPathTracker & setPathRaw( const QString & );
	MappedPathTemplate pathTemplate() const;
	MappedPathTracker & setPathTemplate( const PathTemplate & );
	MappedProjectStorage projectStorage() const;
	MappedPathTracker & setProjectStorage( const ProjectStorage & );
	QString storageName() const;
	MappedPathTracker & setStorageName( const QString & );


	static MappedPathTrackerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedPathTracker reload( bool lockForUpdate = false );

	static MappedPathTrackerList recordsByElement( const Element &fkeyElement );
	static MappedPathTrackerList recordsByPath( const QString &path );






QString generatePathFromTemplate( const ProjectStorage & ps = ProjectStorage() );

QString path( const ProjectStorage & ps = ProjectStorage() );
bool setPath( const QString & path );

bool createPath();

static MappedRecord fromPath( const QString & path, bool matchClosest = false );

static MappedRecord fromPath( const ProjectStorage &, const QString & path, bool caseSensitive = false, bool matchClosest = false );


	static Table * table();
	//static PathTrackerSchema * schema();
};


