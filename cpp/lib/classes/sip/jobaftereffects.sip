
%MappedType MappedJobAfterEffects
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobaftereffectslist.h"
#include "jobaftereffectstable.h"
#define MappedJobAfterEffects JobAfterEffects
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobAfterEffects(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobAfterEffectsSchema::instance() );
%End
};

class JobAfterEffects : Job
{
%TypeHeaderCode
#include <jobaftereffects.h>

%End
public:
	JobAfterEffects();

	JobAfterEffects( uint key );

	JobAfterEffects( const JobAfterEffects & other );

	JobAfterEffects( const Record & r );

	JobAfterEffects( RecordImp * imp, bool checkType = true );
	
	MappedJobAfterEffects copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	uint frameStart() const;
	MappedJobAfterEffects & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobAfterEffects & setFrameEnd( const uint & );
	uint width() const;
	MappedJobAfterEffects & setWidth( const uint & );
	uint height() const;
	MappedJobAfterEffects & setHeight( const uint & );
	QString comp() const;
	MappedJobAfterEffects & setComp( const QString & );


	static MappedJobAfterEffectsList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobAfterEffects reload( bool lockForUpdate = false );







	static Table * table();
	//static JobAfterEffectsSchema * schema();
};


