
class Table : QObject
{
%TypeHeaderCode
#include <table.h>
%End
public:
	Table( Database * db /TransferThis/, TableSchema * schema );
	virtual ~Table();

	Database * database() const;
	
	TableSchema * schema() const;
	
	Connection * connection() const;

	QString tableName();

	Table * parent() const;
	QList<Table*> inherits();

	QList<Table*> children();

	QList<Table*> tableTree();

//	uint newPrimaryKey();

	QList<Index*> indexes();
	Index * indexFromSchema( IndexSchema * schema ) const;

	void addIndex( Index * index /Transfer/ );
	void removeIndex( Index * index, bool dontDelete = false );

	KeyIndex * keyIndex() const;

	void clearIndexes();

	void preload();
	bool isPreloaded() const;
	
	void preloadProject( uint fkeyProject );
	bool isProjectPreloaded( uint fkeyElement, bool preloadNow = false );
	
	MappedRecord load( QVariant * v = 0 );
	MappedRecord * newObject();

	MappedRecord record( uint key, bool select=true, bool useCache=true, bool baseOnly=false );
//	RecordList records( QList<uint> keys );
	MappedRecordList records( const QString & keystring );
	
	MappedRecordList select( 
		const QString & where = QString::null,
		const QList<QVariant> & args = QList<QVariant>(),
		bool selectChildren = true,
		bool expectSingle = false,
		bool needResults = true );
	
	MappedRecordList selectOnly( const QString & where, const QList<QVariant> & args = QList<QVariant>(), bool needResults = true );

	bool insert( const Record & rb, bool newPrimaryKey = true );
	bool insert( const RecordList & rb, bool newPrimaryKey = true );

	void update( RecordImp * r );
	int remove( const Record & rb );
	int remove( const RecordList & );

	bool exists() const;
	bool verifyTable( bool createMissingColumns = false, QString * output=0 );
	bool createTable( QString * output = 0 );

	void setCacheIncoming( bool ci );

	enum {
		SqlInsert,
		SqlSelect,
		SqlUpdate,
		SqlDelete,
		SqlAll
	};

	enum {
		IndexAdded,
		IndexRemoved,
		IndexUpdated,
		IndexIncoming,
		IndexSearch,
		IndexAll
	};

	void addSqlTime( int ms, int action );
	int elapsedSqlTime( int action = SqlAll ) const;

	void addIndexTime( int ms, int action );
	int elapsedIndexTime( int action = IndexAll ) const;

	void printStats();
	
	// returns BORROWED ref
	RecordImp * emptyImp();

signals:
	void added( RecordList );
	void removed( RecordList );
	void updated( Record, Record );

protected slots:
	virtual void recordsAdded( RecordList, bool notifyIndexes = true );
	virtual void recordsRemoved( RecordList, bool notifyIndexes = true );
	virtual void recordUpdated( const Record &, const Record &, bool notifyIndexes = true );
	
};

