
%MappedType MappedServerFileActionStatus
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactionstatuslist.h"
#include "serverfileactionstatustable.h"
#define MappedServerFileActionStatus ServerFileActionStatus
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ServerFileActionStatus(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ServerFileActionStatusSchema::instance() );
%End
};

class ServerFileActionStatus : Record
{
%TypeHeaderCode
#include <serverfileactionstatus.h>

%End
public:
	ServerFileActionStatus();

	ServerFileActionStatus( uint key );

	ServerFileActionStatus( const ServerFileActionStatus & other );

	ServerFileActionStatus( const Record & r );

	ServerFileActionStatus( RecordImp * imp, bool checkType = true );
	
	MappedServerFileActionStatus copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedServerFileActionStatus & setName( const QString & );


	static MappedServerFileActionStatusList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedServerFileActionStatus reload( bool lockForUpdate = false );

	static MappedServerFileActionStatus recordByName( const QString &name );






	static Table * table();
	//static ServerFileActionStatusSchema * schema();
};


