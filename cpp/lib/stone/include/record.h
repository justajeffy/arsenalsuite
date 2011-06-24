
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

#ifndef RECORD_H
#define RECORD_H

#include <qstring.h>
#include <qvariant.h>

#include "recordimp.h"

namespace Stone {
class Table;
class RecordImp;
class TableSchema;
}
using namespace Stone;


STONE_EXPORT bool isChanged( const QString &, const QString & );

/**
 * \class Record
 * 
 * Record is the base class that all user-defined tables use.
 *
 * A Record is essentially a database row, with accessors to
 * set/get any column data.
 *
 * \ingroup Stone
 * @{
 */
class STONE_EXPORT Record
{
public:

	mutable RecordImp * mImp;
	
	Record( RecordImp * imp, bool notused = false );

	Record( Table * table = 0 );

	Record( const Record & r );
	
	~Record();

	Record & operator=( const Record & r );

	bool operator==( const Record & other ) const;
	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	/** Returns true if this object has a valid
	 * recordimp object, ie it can be written to
	 * and read from.  It does not matter
	 * whether the object is committed, deleted,
	 * modifed or brand new
	 *
	 * Use this method in derived record classes
	 * to check for inheritance:
	 *
	 *  void isUserRecord( const Record & r )
	 * {
	 *     return User(r).isValid();
	 * }
	 * This is the same as
	 * return r.table() ? r.table()->inherits( User::table() ) : false;
	 */
	bool isValid() const { return bool(mImp); }

	/// Returns true if this record is in the database
	bool isRecord() const;

	/// Returns this record's primary key
	uint key( bool generate = false ) const;

	/// Returns the value in column 'column'
	QVariant getValue( const QString & column ) const;

	/// Sets the value in 'column' to 'value'
	Record & setValue( const QString & column, const QVariant & value );

	Record & setForeignKey( const QString & column, const Record & other );
	Record & setForeignKey( int column, const Record & other );
    Record & setForeignKey( Field * field, const Record & other );

	Record foreignKey( const QString & column ) const;
	Record foreignKey( int column ) const;
    Record foreignKey( Field * field ) const;

	/// Sets the column to a literal SQL value that will be used for
	/// the next update/commit.  A null QString will clear the literal
	/// for this column.
	Record & setColumnLiteral( const QString & column, const QString & literal );

	/// Returns the literal value assigned to this column.
	/// Returns QString::null if there is none.
	QString columnLiteral( const QString & column ) const;

	/// Gets or sets the value in the column at position 'column'
	/// Column positions are not guaranteed to be in any
	/// particular order
	QVariant getValue( int column ) const;
    QVariant getValue( Field * field ) const;

	Record & setValue( int column, const QVariant & value );
    Record & setValue( Field * field, const QVariant & value );

	QString stateString() const;

	// human readable output
	QString dump() const;
	QString changeString() const;

    void selectFields( FieldList fields );

	/// Removes this record from the database and indexes
	/// return value of -1 indicates error. 0 indicates that
	/// the record was not in the database, 1 indicates the
	/// record was removed
	int remove();

	/// Reloads this record from the database
	Record & reload( bool lockForUpdate = false );

	/// Commits this record to the database
	///
	/// If sync is false and there is a worker thread
	/// running, then this record will be committed by
	/// the worker thread, and this function will
	/// return before the primary key has been
	/// set and before and recordsAdded/Updated signals
	/// have been emmitted.
	Record & commit( bool sync = true );

	RecordImp * imp() const { return mImp; }

	bool isUpdated() const;

	Table * table() const { return mImp ? mImp->table() : 0; }

	Record copy() const;

	/// Number of Record objects in existence
	static int totalRecordCount();

	/// Number of RecordImp objects in existence
	static int totalRecordImpCount();

	friend class Stone::RecordImp;

protected:
	void checkImpType(TableSchema * ts);
};

///@}

Q_DECLARE_METATYPE(Record)

#include "recordlist.h"

#endif // RECORD_H

