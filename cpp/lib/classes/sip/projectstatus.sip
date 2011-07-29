
%MappedType MappedProjectStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "projectstatuslist.h"
#include "projectstatustable.h"
#define MappedProjectStatus ProjectStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ProjectStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ProjectStatusSchema::instance() );
%End
};

class ProjectStatus : Record
{
%TypeHeaderCode
#include <projectstatus.h>

%End
public:
	ProjectStatus();

	ProjectStatus( uint key );

	ProjectStatus( const ProjectStatus & other );

	ProjectStatus( const Record & r );

	ProjectStatus( RecordImp * imp, bool checkType = true );
	
	MappedProjectStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString projectStatus() const;
	MappedProjectStatus & setProjectStatus( const QString & );
	uint chronology() const;
	MappedProjectStatus & setChronology( const uint & );


	static MappedProjectStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedProjectStatus reload( bool lockForUpdate = false );

	static MappedProjectStatus recordByName( const QString &projectStatus );






	static Table * table();
	//static ProjectStatusSchema * schema();
};


