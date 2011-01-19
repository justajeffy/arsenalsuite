
%MappedType MappedJobMaya
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmayalist.h"
#include "jobmayatable.h"
#define MappedJobMaya JobMaya
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMaya(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMayaSchema::instance() );
%End
};

class JobMaya : Job
{
%TypeHeaderCode
#include <jobmaya.h>

%End
public:
	JobMaya();

	JobMaya( uint key );

	JobMaya( const JobMaya & other );

	JobMaya( const Record & r );

	JobMaya( RecordImp * imp, bool checkType = true );
	
	MappedJobMaya copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	int frameStart() const;
	MappedJobMaya & setFrameStart( const int & );
	int frameEnd() const;
	MappedJobMaya & setFrameEnd( const int & );
	QString camera() const;
	MappedJobMaya & setCamera( const QString & );
	QString renderer() const;
	MappedJobMaya & setRenderer( const QString & );
	QString projectPath() const;
	MappedJobMaya & setProjectPath( const QString & );
	uint width() const;
	MappedJobMaya & setWidth( const uint & );
	uint height() const;
	MappedJobMaya & setHeight( const uint & );
	QString append() const;
	MappedJobMaya & setAppend( const QString & );


	static MappedJobMayaList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMaya reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMayaSchema * schema();
};


