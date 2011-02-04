
%MappedType MappedServerFileActionType
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactiontypelist.h"
#include "serverfileactiontypetable.h"
#define MappedServerFileActionType ServerFileActionType
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ServerFileActionType(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ServerFileActionTypeSchema::instance() );
%End
};

class ServerFileActionType : Record
{
%TypeHeaderCode
#include <serverfileactiontype.h>

%End
public:
	ServerFileActionType();

	ServerFileActionType( uint key );

	ServerFileActionType( const ServerFileActionType & other );

	ServerFileActionType( const Record & r );

	ServerFileActionType( RecordImp * imp, bool checkType = true );
	
	MappedServerFileActionType copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedServerFileActionType & setName( const QString & );


	static MappedServerFileActionTypeList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedServerFileActionType reload( bool lockForUpdate = false );

	static MappedServerFileActionType recordByName( const QString &type );






	static Table * table();
	//static ServerFileActionTypeSchema * schema();
};


