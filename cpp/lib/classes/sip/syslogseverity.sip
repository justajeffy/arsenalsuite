
%MappedType MappedSysLogSeverity
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "syslogseveritylist.h"
#include "syslogseveritytable.h"
#define MappedSysLogSeverity SysLogSeverity
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new SysLogSeverity(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, SysLogSeveritySchema::instance() );
%End
};

class SysLogSeverity : Record
{
%TypeHeaderCode
#include <syslogseverity.h>

%End
public:
	SysLogSeverity();

	SysLogSeverity( uint key );

	SysLogSeverity( const SysLogSeverity & other );

	SysLogSeverity( const Record & r );

	SysLogSeverity( RecordImp * imp, bool checkType = true );
	
	MappedSysLogSeverity copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString sysLogSeverity() const;
	MappedSysLogSeverity & setSysLogSeverity( const QString & );
	int severity() const;
	MappedSysLogSeverity & setSeverity( const int & );


	static MappedSysLogSeverityList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedSysLogSeverity reload( bool lockForUpdate = false );







	static Table * table();
	//static SysLogSeveritySchema * schema();
};


