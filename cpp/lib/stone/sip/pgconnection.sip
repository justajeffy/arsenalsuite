
class PGConnection : QSqlDbConnection
{
%TypeHeaderCode
#include <pgconnection.h>
%End
public:
	PGConnection();
	
	virtual Capabilities capabilities() const;

	virtual bool tableExists( TableSchema * schema );
	virtual bool verifyTable( TableSchema * schema, bool createMissingColumns = false, QString * output=0 );
	virtual bool createTable( TableSchema * schema, QString * output = 0 );

	virtual TableSchema * importTableSchema() /TransferBack/;

	virtual Schema * importDatabaseSchema() /TransferBack/;

	virtual uint newPrimaryKey( TableSchema * );

	virtual MappedRecordList selectOnly( Table *, const QString & where = QString::null, const QList<QVariant> & vars = QList<QVariant>() );
	virtual QList<RecordList> joinedSelect( const JoinedSelect &, QString where, QList<QVariant> vars );

	virtual bool insert( Table *, const RecordList & rl, bool newPrimaryKey = true );

	virtual bool update( Table *, RecordImp * imp, Record * returnVals = 0 );

	virtual int remove( Table *, const QStringList & );

	virtual bool createIndex( IndexSchema * schema );
	
	bool checkVersion( int vMajor, int vMinor );
};
