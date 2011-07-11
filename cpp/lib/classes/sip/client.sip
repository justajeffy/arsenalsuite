
%MappedType MappedClient
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "clientlist.h"
#include "clienttable.h"
#define MappedClient Client
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Client(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ClientSchema::instance() );
%End
};

class Client : Record
{
%TypeHeaderCode
#include <client.h>

%End
public:
	Client();

	Client( uint key );

	Client( const Client & other );

	Client( const Record & r );

	Client( RecordImp * imp, bool checkType = true );
	
	MappedClient copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedClient & setName( const QString & );
	QString textcard() const;
	MappedClient & setTextcard( const QString & );


	static MappedClientList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedClient reload( bool lockForUpdate = false );

	static MappedClient recordByName( const QString &client );






	static Table * table();
	//static ClientSchema * schema();
};


