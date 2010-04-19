
%MappedType MappedSysLogRealm
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "syslogrealmlist.h"
#include "syslogrealmtable.h"
#define MappedSysLogRealm SysLogRealm
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new SysLogRealm(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, SysLogRealmSchema::instance() );
%End
};

class SysLogRealm : Record
{
%TypeHeaderCode
#include <syslogrealm.h>

%End
public:
	SysLogRealm();

	SysLogRealm( uint key );

	SysLogRealm( const SysLogRealm & other );

	SysLogRealm( const Record & r );

	SysLogRealm( RecordImp * imp, bool checkType = true );
	
	MappedSysLogRealm copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString realm() const;
	MappedSysLogRealm & setRealm( const QString & );


	static MappedSysLogRealmList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedSysLogRealm reload( bool lockForUpdate = false );







	static Table * table();
	//static SysLogRealmSchema * schema();
};


