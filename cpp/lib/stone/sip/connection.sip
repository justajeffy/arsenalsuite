

class Connection : QObject
{
%TypeHeaderCode
#include <connection.h>
#include <pgconnection.h>
%End
public:

%ConvertToSubClassCode
	sipClass = NULL;
	if( dynamic_cast<PGConnection*>(sipCpp) )
		sipClass = sipClass_PGConnection;
%End

	virtual ~Connection();

	static Connection * create( const QString & dbType );
	static Connection * createFromIni( IniConfig & , const QString & section );

	// Reads all options from the ini object
	virtual void setOptionsFromIni( const IniConfig & );

	QString type() const;

	QString host() const;
	int port() const;
	QString databaseName() const;
	QString userName() const;
	QString password() const;

	void setHost( const QString & host );
	void setPort( int port );
	void setDatabaseName( const QString & );
	void setUserName( const QString & userName );
	void setPassword( const QString & password );

	int reconnectDelay() const;
	void setReconnectDelay( int reconnectDelay );

	enum Capabilities {
		Cap_Inheritance = 		1,
		Cap_MultipleInsert = 	2,
		Cap_Returning = 		4,
		Cap_Transactions = 		8,
		Cap_CheckPoints = 		16,
		Cap_IndexCreation = 	32
	};

	virtual Connection::Capabilities capabilities() const = 0;

	virtual QString lastErrorText() const;

	virtual bool reconnect() = 0;
	
	virtual bool isConnected() = 0;

	virtual bool checkConnection();

	virtual QString connectString() = 0;

	virtual bool tableExists( TableSchema * schema ) = 0;

	virtual bool verifyTable( TableSchema * schema, bool createMissingColumns = false, QString * output=0 ) = 0;

	virtual bool createTable( TableSchema * schema, QString * output = 0 ) = 0;

	virtual TableSchema * importTableSchema() = 0;

	virtual Schema * importDatabaseSchema() = 0;

	virtual uint newPrimaryKey( TableSchema * ) = 0;

	virtual QSqlQuery exec( const QString & sql, const QList<QVariant> & vars = QList<QVariant>(), bool reExecLostConn = true, Table * table = 0 ) = 0 /PyName=exec_/;

	virtual bool exec( QSqlQuery & query, bool reExecLostConn = true, Table * table = 0 ) = 0 /PyName=exec_/;

	virtual RecordList selectOnly( Table *, const QString & where = QString::null, const QList<QVariant> & vars = QList<QVariant>() ) = 0;

	virtual bool insert( Table *, const RecordList & rl, bool newPrimaryKey = true ) = 0;

	virtual bool update( Table *, RecordImp * imp, Record * returnValues = 0 ) = 0;

	virtual int remove( Table *, const QStringList & keys ) = 0;

	virtual bool beginTransaction();
	virtual bool commitTransaction();
	virtual bool rollbackTransaction();

	virtual bool createIndex( IndexSchema * );

signals:
	void connectionLost();

	void connectionLost2();

	void connected();
};

class QSqlDbConnection : Connection
{
%TypeHeaderCode
#include <connection.h>
%End

public:
	QSqlDbConnection( const QString & driverName );
	~QSqlDbConnection();

	virtual void setOptionsFromIni( const IniConfig & );

	virtual Connection::Capabilities capabilities() const;

	QSqlDatabase db() const;

	virtual QSqlQuery exec( const QString & sql, const QList<QVariant> & vars = QList<QVariant>(), bool reExecLostConn = true, Table * table = 0 ) /PyName=exec_/;

	virtual bool exec( QSqlQuery & query, bool reExecLostConn = true, Table * table = 0 ) /PyName=exec_/;

	virtual bool beginTransaction();
	virtual bool commitTransaction();
	virtual bool rollbackTransaction();

	virtual bool reconnect();
	
	virtual bool isConnected();

	virtual bool checkConnection();

	virtual QString connectString();

	static bool isConnectionError( const QSqlError & e );
};
