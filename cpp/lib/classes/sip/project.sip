
%MappedType MappedProject
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectlist.h"
#include "projecttable.h"
#define MappedProject Project
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Project(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ProjectSchema::instance() );
%End
};

class Project : Element
{
%TypeHeaderCode
#include <project.h>
#include "client.h"
#include "projectstatus.h"
#include "projectstorage.h"

%End
public:
	Project();

	Project( uint key );

	Project( const Project & other );

	Project( const Record & r );

	Project( RecordImp * imp, bool checkType = true );
	
	MappedProject copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString compOutputDrive() const;
	MappedProject & setCompOutputDrive( const QString & );
	QDate dueDate() const;
	MappedProject & setDueDate( const QDate & );
	QString filetype() const;
	MappedProject & setFiletype( const QString & );
	MappedClient client() const;
	MappedProject & setClient( const Client & );
	QString notes() const;
	MappedProject & setNotes( const QString & );
	QString renderOutputDrive() const;
	MappedProject & setRenderOutputDrive( const QString & );
	QString script() const;
	MappedProject & setScript( const QString & );
	QString shortName() const;
	MappedProject & setShortName( const QString & );
	QString wipDrive() const;
	MappedProject & setWipDrive( const QString & );
	uint projectNumber() const;
	MappedProject & setProjectNumber( const uint & );
	uint frames() const;
	MappedProject & setFrames( const uint & );
	uint nda() const;
	MappedProject & setNda( const uint & );
	float dayRate() const;
	MappedProject & setDayRate( const float & );
	uint useFileCreation() const;
	MappedProject & setUseFileCreation( const uint & );
	QString dailyDrive() const;
	MappedProject & setDailyDrive( const QString & );
	QDateTime lastScanned() const;
	MappedProject & setLastScanned( const QDateTime & );
	MappedProjectStatus projectStatus() const;
	MappedProject & setProjectStatus( const ProjectStatus & );
	float assburnerWeight() const;
	MappedProject & setAssburnerWeight( const float & );
	MappedProjectStorageList projectStorages() const;


	static MappedProjectList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedProject reload( bool lockForUpdate = false );

	static MappedProject recordByName( const QString &name );


	static ElementType type();



	MappedRecord findSequence( const QString & name );

	MappedRecord findShot( const QString & sequenceName, const QString & shotName );

	MappedRecord findShotFromPath( const QString & path );

	static MappedRecord findProjectFromPath( const QString & path );

	MappedRecordList shots();

	MappedRecordList sequences();


	static Table * table();
	//static ProjectSchema * schema();
};


