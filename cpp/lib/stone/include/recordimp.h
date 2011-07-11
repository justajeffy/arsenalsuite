
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of libstone.
 *
 * libstone is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * libstone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with libstone; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id$
 */

#ifndef RECORD_BASE_H
#define RECORD_BASE_H

#include <qbasicatomic.h>
#include <qstring.h>
#include <qvector.h>

#include "blurqt.h"

class QVariant;
class QSqlQuery;

class Record;

typedef QVector<QVariant> VariantVector;
template <class T> class QList;

namespace Stone {

class KeyIndex;
class Field;
typedef QList<Field *> FieldList;
class Table;

/**
 *  This class stores data for a single record in the layout
 *  determined by a \ref Table.  This class is wrapped by
 *  \ref Record, and is only used internally.
 *  \ingroup Stone
 */
class STONE_EXPORT RecordImp
{
public:
    // Loads mValues with the values in toLoad.  There needs to be table->fields().size() values in the array
    // If toLoad=0 then constructs a new record with empty values. If table is specified
    // then each value is filled with the corrosponding field->defaultValue()
    RecordImp( Table * table, QVariant * toLoad = 0 );

    // Loads mValues with the data in the sql query, starting with queryPosOffset.
    // If fields is 0, then q should have data for every non-local field that doesn't have NoDefaultSelect set
    // otherwise fields should contain the full list of fields contained in q
    RecordImp( Table * table, QSqlQuery & q, int queryPosOffset = 0, FieldList * fields = 0 );

    // Loads mValues with the data in the sql query, indexed by the entries in the queryColPos array
    // If fields is 0, then q should have data for every non-local field that doesn't have NoDefaultSelect set
    // otherwise fields should contain the full list of fields contained in q
    RecordImp( Table * table, QSqlQuery & q, int * queryColPos, FieldList * fields = 0 );


    ~RecordImp();

	/// Adds 1 to the reference count
	void ref();

	/// Subtracts 1 from the reference count
	/// delete this if the reference count falls to 0
	void deref();

	/// Returns the current reference count.
	int refCount() const { return mRefCount; }

	///  Fills the array of QVariants pointed to by \param v
	///  with the values in this record.  \param v must
	///  point to an array with as many values as this
	///  RecordImp's table has columns.
	void get( QVariant * v );

	/// Fills the QVariant array pointed to by \param v with the values
	/// in this object.     \param v must
	///  point to an array with as many values as this
	///  RecordImp's table has columns.
	void set( QVariant * v );

	///  Returns the QVariant value at the position \param col
	QVariant getColumn( int col ) const;
    QVariant getColumn( Field * f ) const;

	/// Sets the QVariant value at the position \param col
	RecordImp * setColumn( int col, const QVariant & v );
    RecordImp * setColumn( Field * f, const QVariant & v );

    /// Sets the QVariant value at position \param col
    /// This function does not modify mState, it does clear mNotSelectedBits
    void fillColumn( int col, const QVariant & v );

	/// Returns the QVariant value at \param column
	QVariant getValue( const QString & column ) const;

	/// Sets the QVariant value at \param column
	/// May return a newly allocated and referenced RecordImp, if so
	/// will dereference this
	RecordImp * setValue( const QString & column, const QVariant & v );

	/// Returns the table this recordimp belongs to
	Table * table() const { return mTable; }

	/// Creates a copy of this RecordImp
	RecordImp * copy();

	/// Returns the primary key for this record
	uint key() const;
	
	/// Commits this record to the database.
	/// If \param newPrimaryKey is true, a new primary key
	/// is generated, else the existing key is used.
	/// If sync is false, the sql will be executed in the
	/// background thread.
	/// May return a different referenced RecordImp, if so
	/// will dereference this
	RecordImp * commit(bool newPrimaryKey=true,bool sync=true);

	/// Removes the record from the database.
	void remove();

	void setColumnModified( uint col, bool modified );
	bool isColumnModified( uint col ) const;
	void clearModifiedBits();

    bool isColumnSelected( uint col );
    FieldList notSelectedColumns();

	RecordImp * setColumnLiteral( uint col, bool modified );
	bool isColumnLiteral( uint col ) const;
	void clearColumnLiterals();

	enum {
		NEWRECORD = 0,
		COMMITTED = 1,
		MODIFIED = 2,
		DELETED = 4,
		// This is to prevent allocations for "empty" records
		// Each table instance will have it's own empty recordimp
		// essentially it would be like Record keeping mImp = 0, except
		// that you still have a pointer to the table.
		EMPTY_SHARED = 8,
		// This is used (primarily by undo manager) to commit all fields
		// without having to mark each as modified.
		COMMIT_ALL_FIELDS = 16
	};

	QString debugString();

	int mState;

	VariantVector * values() { return mValues; }

	static int totalCount();
protected:
	QAtomicInt mRefCount;
	Table * mTable;
	VariantVector * mValues;
    char * mModifiedBits;
	char * mLiterals;
    char * mNotSelectedBits;
	friend class ::Record;
	friend class Table;
	friend class KeyIndex;
};

} //namespace

#endif // RECORD_BASE_H

