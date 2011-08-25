
// QList<RecordList> is implemented as a Python list of RecordLists.
%MappedType QList<RecordList>
{
%TypeHeaderCode
#include <qlist.h>
%End

%ConvertFromTypeCode
    // Create the list.
    PyObject *l;

    if ((l = PyList_New(sipCpp->size())) == NULL)
        return NULL;

    // Set the list elements.
    for (int i = 0; i < sipCpp->size(); ++i)
    {
		RecordList rl = sipCpp->value(i);

		PyList_SET_ITEM(l, i, sipConvertFromNewType( new RecordList(rl), sipType_RecordList, NULL ) );
    }

    return l;
%End

%ConvertToTypeCode
    SIP_SSIZE_T len;

    // Check the type if that is all that is required.
	if (sipIsErr == NULL)
	{
		if (!PySequence_Check(sipPy) || (len = PySequence_Size(sipPy)) < 0)
			return 0;

		for (SIP_SSIZE_T i = 0; i < len; ++i)
		{
			PyObject *itm = PySequence_ITEM(sipPy, i);
			bool ok = (itm && sipCanConvertToType(itm, sipType_RecordList, SIP_NOT_NONE));

			Py_XDECREF(itm);

			if (!ok)
				return 0;
		}

		return 1;
	}

	QList<RecordList> *ql = new QList<RecordList>;
	len = PySequence_Size(sipPy);

	for (SIP_SSIZE_T i = 0; i < len; ++i)
	{
		PyObject *itm = PySequence_ITEM(sipPy, i);
		int state;
		RecordList * t = reinterpret_cast<RecordList*>(sipConvertToType(itm, sipType_RecordList, sipTransferObj, SIP_NOT_NONE, &state, sipIsErr));

		Py_DECREF(itm);

		if (*sipIsErr)
		{
			sipReleaseType(t, sipType_RecordList, state);

			delete ql;
			return 0;
		}

		ql->append(*t);

		sipReleaseType(t, sipType_RecordList, state);
	}

	*sipCppPtr = ql;

	return sipGetState(sipTransferObj);
%End
};

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

	int maxConnectionAttempts() const;
	void setMaxConnectionAttempts( int maxConnectionAttempts );

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

	virtual RecordList selectFrom( Table * table, const QString & from, const QList<QVariant> & args ) = 0;

	virtual RecordList selectOnly( Table *, const QString & where = QString::null, const QList<QVariant> & vars = QList<QVariant>() ) = 0;
	virtual QList<RecordList> joinedSelect( const JoinedSelect &, QString where, QList<QVariant> vars ) = 0;

	virtual void selectFields( Table * table, RecordList, QList<Field*> ) = 0;

	virtual bool insert( Table *, const RecordList & rl, bool newPrimaryKey = true ) = 0;

	virtual bool update( Table *, RecordImp * imp, Record * returnValues = 0 ) = 0;

	virtual int remove( Table *, const QString &, QList<int> * rowsDeleted = 0 ) = 0;

	virtual bool beginTransaction();
	virtual bool commitTransaction();
	virtual bool rollbackTransaction();

	virtual bool createIndex( IndexSchema * );

signals:
	void connectionLost();

	void connectionLost2();

	void connected();
};

class QSqlDbConnection : Connection /Abstract/
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
