
%MappedType MappedServerFileAction
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "serverfileactionlist.h"
#include "serverfileactiontable.h"
#define MappedServerFileAction ServerFileAction
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new ServerFileAction(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ServerFileActionSchema::instance() );
%End
};

class ServerFileAction : Record
{
%TypeHeaderCode
#include <serverfileaction.h>
#include "serverfileactionstatus.h"
#include "serverfileactiontype.h"
#include "host.h"

%End
public:
	ServerFileAction();

	ServerFileAction( uint key );

	ServerFileAction( const ServerFileAction & other );

	ServerFileAction( const Record & r );

	ServerFileAction( RecordImp * imp, bool checkType = true );
	
	MappedServerFileAction copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedServerFileActionStatus serverFileActionStatus() const;
	MappedServerFileAction & setServerFileActionStatus( const ServerFileActionStatus & );
	MappedServerFileActionType serverFileActionType() const;
	MappedServerFileAction & setServerFileActionType( const ServerFileActionType & );
	MappedHost host() const;
	MappedServerFileAction & setHost( const Host & );
	QString destPath() const;
	MappedServerFileAction & setDestPath( const QString & );
	QString errorMessage() const;
	MappedServerFileAction & setErrorMessage( const QString & );
	QString sourcePath() const;
	MappedServerFileAction & setSourcePath( const QString & );


	static MappedServerFileActionList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedServerFileAction reload( bool lockForUpdate = false );

	static MappedServerFileActionList recordsByHostAndStatus( const Host &fkeyhost, const ServerFileActionStatus &fkeyServerFileActionStatus );





	static ServerFileAction remove( const QString & path );

	static ServerFileAction move( const QString & source, const QString & dest );

	enum Status {
		New,
		Complete,
		Error
	};

	Status status();
	ServerFileAction & setStatus( Status status );

	enum Type {
		Delete,
		Move
	};

	Type type();
	ServerFileAction & setType( Type type );


	static Table * table();
	//static ServerFileActionSchema * schema();
};


