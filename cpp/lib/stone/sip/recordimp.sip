
class RecordImp
{
%TypeHeaderCode
#include <recordimp.h>
%End

public:
	RecordImp( Table * table, QVariant * toLoad=0 ) /HoldGIL/;
	RecordImp( Table * table, QSqlQuery & q, int queryPosOffset = 0 ) /HoldGIL/;

    ~RecordImp() /HoldGIL/;

	void ref();
	void deref();

	int refCount() const;

	QVariant getColumn( int col ) const;
	RecordImp * setColumn( int col, const QVariant & v ) /HoldGIL/;

	QVariant getValue( const QString & column ) const;
	RecordImp * setValue( const QString & column, const QVariant & v ) /HoldGIL/;
	
	Table * table() const /HoldGIL/;

	RecordImp * copy() /HoldGIL/;

	uint key() const;
	
	RecordImp * commit(bool newPrimaryKey=true,bool sync=true) /HoldGIL/;

	void remove();

	void setColumnModified( uint col, bool modified );
	bool isColumnModified( uint col ) const;
	void clearModifiedBits();
	
	RecordImp * setColumnLiteral( uint col, bool modified ) /HoldGIL/;
	bool isColumnLiteral( uint col ) const;
	void clearColumnLiterals();
	
	enum {
		COMMITTED = 1,
		MODIFIED = 2,
		DELETED = 4
	};
	
};

