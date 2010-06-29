
%MappedType MappedPathSyncTarget
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "pathsynctargetlist.h"
#include "pathsynctargettable.h"
#define MappedPathSyncTarget PathSyncTarget
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new PathSyncTarget(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, PathSyncTargetSchema::instance() );
%End
};

class PathSyncTarget : Record
{
%TypeHeaderCode
#include <pathsynctarget.h>
#include "pathtracker.h"
#include "projectstorage.h"

%End
public:
	PathSyncTarget();

	PathSyncTarget( uint key );

	PathSyncTarget( const PathSyncTarget & other );

	PathSyncTarget( const Record & r );

	PathSyncTarget( RecordImp * imp, bool checkType = true );
	
	MappedPathSyncTarget copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedPathTracker pathTracker() const;
	MappedPathSyncTarget & setPathTracker( const PathTracker & );
	MappedProjectStorage projectStorage() const;
	MappedPathSyncTarget & setProjectStorage( const ProjectStorage & );


	static MappedPathSyncTargetList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedPathSyncTarget reload( bool lockForUpdate = false );

	static MappedPathSyncTargetList recordsByPathTracker( const PathTracker &fkeyPathTracker );
	static MappedPathSyncTargetList recordsByProjectStorage( const ProjectStorage &fkeyProjectStorage );






	static Table * table();
	//static PathSyncTargetSchema * schema();
};


