
class RecordImp
{
%TypeHeaderCode
#include <recordimp.h>
%End

public:
	RecordImp( Table * table, QVariant * toLoad=0 );
	RecordImp( Table * table, QSqlQuery & query );

	~RecordImp();
	
	void ref();
	void deref();

	int refCount() const;

	QVariant getColumn( int col ) const;
	RecordImp * setColumn( int col, const QVariant & v );

	QVariant getValue( const QString & column ) const;
	RecordImp * setValue( const QString & column, const QVariant & v );
	
	Table * table() const;

	RecordImp * copy();

	uint key() const;
	
	RecordImp * commit(bool newPrimaryKey=true,bool sync=true);

	void remove();

	void setColumnModified( uint col, bool modified );
	bool isColumnModified( uint col ) const;
	void clearModifiedBits();
	
	RecordImp * setColumnLiteral( uint col, bool modified );
	bool isColumnLiteral( uint col ) const;
	void clearColumnLiterals();
	
	enum {
		COMMITTED = 1,
		MODIFIED = 2,
		DELETED = 4
	};
	
};

