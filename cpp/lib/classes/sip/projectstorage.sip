
%MappedType MappedProjectStorage
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectstoragelist.h"
#include "projectstoragetable.h"
#define MappedProjectStorage ProjectStorage
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ProjectStorage(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ProjectStorageSchema::instance() );
%End
};

class ProjectStorage : Record
{
%TypeHeaderCode
#include <projectstorage.h>
#include "project.h"
#include "host.h"
#include "pathsynctarget.h"

%End
public:
	ProjectStorage();

	ProjectStorage( uint key );

	ProjectStorage( const ProjectStorage & other );

	ProjectStorage( const Record & r );

	ProjectStorage( RecordImp * imp, bool checkType = true );
	
	MappedProjectStorage copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedProjectStorage & setName( const QString & );
	MappedProject project() const;
	MappedProjectStorage & setProject( const Project & );
	MappedHost host() const;
	MappedProjectStorage & setHost( const Host & );
	QString location() const;
	MappedProjectStorage & setLocation( const QString & );
	bool defaultStorage() const;
	MappedProjectStorage & setDefaultStorage( const bool & );
	MappedPathSyncTargetList pathSyncTargets() const;


	static MappedProjectStorageList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedProjectStorage reload( bool lockForUpdate = false );

	static MappedProjectStorageList recordsByProject( const Project &fkeyProject );
	static MappedProjectStorage recordByProjectAndName( const Project &fkeyProject, const QString &name );






	static Table * table();
	//static ProjectStorageSchema * schema();
};


