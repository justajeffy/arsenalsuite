
%MappedType MappedJobXSI
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobxsilist.h"
#include "jobxsitable.h"
#define MappedJobXSI JobXSI
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobXSI(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobXSISchema::instance() );
%End
};

class JobXSI : Job
{
%TypeHeaderCode
#include <jobxsi.h>

%End
public:
	JobXSI();

	JobXSI( uint key );

	JobXSI( const JobXSI & other );

	JobXSI( const Record & r );

	JobXSI( RecordImp * imp, bool checkType = true );
	
	MappedJobXSI copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString pass() const;
	MappedJobXSI & setPass( const QString & );
	QString framelist() const;
	MappedJobXSI & setFramelist( const QString & );
	uint frameStart() const;
	MappedJobXSI & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobXSI & setFrameEnd( const uint & );
	uint resolutionX() const;
	MappedJobXSI & setResolutionX( const uint & );
	uint resolutionY() const;
	MappedJobXSI & setResolutionY( const uint & );
	/**
	  * Valid values are
	  * default - Default Scanline
	  * ogl - OpenGL scanline
	  * rapid - Rapid scanline, designed for very large scenes
	  * trace - Raytrace
	  **/
	QString renderer() const;
	MappedJobXSI & setRenderer( const QString & );
	bool motionBlur() const;
	MappedJobXSI & setMotionBlur( const bool & );
	bool deformMotionBlur() const;
	MappedJobXSI & setDeformMotionBlur( const bool & );


	static MappedJobXSIList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobXSI reload( bool lockForUpdate = false );







	static Table * table();
	//static JobXSISchema * schema();
};


