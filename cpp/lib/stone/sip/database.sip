class Database : QObject
{
%TypeHeaderCode
#include <database.h>
%End

public:
	Database( Schema * schema, Connection * conn /Transfer/ = 0 );
	~Database();

	void ref();
	void deref();

	static Database * current( Schema * s = 0 );
	static void setCurrent( Database * /Transfer/ );
	static QList<Database*> databases();

	Connection * connection() const;
	void setConnection( Connection * c /Transfer/ );

	/// These methods are simply forwarded to connection
	/// and documented there, only used to allow shorter code.
	QSqlQuery exec( const QString & sql, const QList<QVariant> & vars = QList<QVariant>(), bool reExecLostConn = true, Table * table = 0 ) /PyName=exec_/;
	bool exec( QSqlQuery & query, bool reExecLostConn = true, Table * table = 0 ) /PyName=exec_/;

	bool exec( QSqlQuery & query, bool reExecLostConn = true, Table * table = 0 );

	Schema * schema() const;

	Table * tableByName( const QString & tableName ) const;
	Table * tableByClass( const QString & className ) const;
	
	Table * tableFromSchema( TableSchema * table ) const;

	QList<Table*> tables();

	enum {
		EchoSelect=1,
		EchoUpdate=2,
		EchoInsert=4,
		EchoDelete=8
	};

	void setEchoMode( uint echoMode );

	uint echoMode() const;

	bool undoEnabled() const;

	void setUndoEnabled( bool enabled );

	int elapsedSqlTime( int action = Table::SqlAll );

	int elapsedIndexTime( int action = Table::IndexAll );

	void beginTransaction( const QString & title = QString::null );

	void commitTransaction();

	void rollbackTransaction();
	
	bool ensureInsideTransaction();

	void flushUpdateBuffer();

	bool insideTransaction();

	bool verifyTables( QString * output = 0 );

	bool createTables( QString * output = 0 );

	void addDeleteAction( Field * );
	void removeDeleteAction( Field * );

	void printStats();

	bool queueRecordSignals() const;

	bool setQueueRecordSignals( bool qrc );

	bool pushQueueRecordSignals( bool );

	bool popQueueRecordSignals();

signals:

	void recordsAddedSignal( const RecordList & );
	void recordsRemovedSignal( const RecordList & );
	void recordUpdatedSignal( const Record & current, const Record & updated );
	void recordsIncomingSignal( const RecordList & );

protected slots:
	void transactionTimeout();
};



