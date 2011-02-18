
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
 * $Id: table.h 8589 2009-07-16 00:09:30Z brobison $
 */

#ifndef TABLE_H
#define TABLE_H

#include <qobject.h>

#include "index.h"
#include "field.h"
#include "record.h"
#include "tableschema.h"

class QSqlError;
class Record;

namespace Stone {
class Database;
class Connection;
class RecordUndoOperation;
class UpdateManager;
class Field;
class Table;
}

typedef QList<QVariant> VarList;

namespace Stone {

typedef QList<Table*> TableList;
typedef QList<Table*>::iterator TableIter;

/**
 * This class manages the schema for a table, the relationship
 * to other tables, the database this table belongs to.  It
 * can select, update, and delete records from this table.
 * It provides updates(local, and remote via \ref UpateManager) to
 * the data stored in this table via the \ref added, \ref updated,
 * and \ref removed signals.
 *
 * It also manages the indexes for this table, and other cache
 * techniques such as preloading.
 * \ingroup Stone
 */
class STONE_EXPORT Table : public QObject
{
Q_OBJECT
public:
	Table( Database * db, TableSchema * schema );
	virtual ~Table();

	/// Returns the \ref Database this table belongs to.
	Database * database() const { return mDatabase; }
	
	TableSchema * schema() const { return mSchema; }
	
	Connection * connection() const;

	QString tableName() { return schema()->tableName(); }

	/// Returns the parent \ref Table of this table, or
	/// 0 if this table has no parent.
	Table * parent() const;

	/// Returns the list of tables that this parent inherits,
	/// the parent and each of it's parents recursivly.
	QList<Table*> inherits();

	/// Return the list of \ref Tables that directly inherit
	/// from this table.
	QList<Table*> children();

	/// Returns a list of \ref Tables including this table,
	/// and all tables that directly or indirectly inherit from
	/// this table.
	QList<Table*> tableTree();

	/// Returns a new(unique) primary key, returned
	/// from the primary key sequence in the database.
//	uint newPrimaryKey();

	/// Indexes
	///
	IndexList indexes();
	Index * indexFromSchema( IndexSchema * schema ) const;
	Index * indexFromField( const QString & name ) const;
	Index * index( const QString & name ) const;

	/// This does not need to be called when creating an
	/// index, because the index calls it itself
	void addIndex( Index * index );
	void removeIndex( Index * index, bool dontDelete = false );

	KeyIndex * keyIndex() const;

	void clearIndexes();

	//
	// Preload functions
	//
	void preload();
	bool isPreloaded() const;
	
	//
	// Project Preload Functions
	//
	void preloadProject( uint fkeyProject );
	bool isProjectPreloaded( uint fkeyElement, bool preloadNow = false );
	
	/// Creates a new record object for this table
	/// and fills it with the variant from the v array,
	/// if v is 0, the records are set to the defaults
	Record load( QVariant * v = 0 );

	Record * newObject();

	/// Functions to retrieve records by key
	///
	Record record( uint key, bool select=true, bool useCache=true, bool baseOnly=false );
	/// Selects all records
	RecordList records( QList<uint> keys, bool select=true, bool useCache=true );
	/// keystring is a comma seperated list of keys eg "1,2,3,4"
	RecordList records( const QString & keystring );
	
	/// Functions to retrieve records using a where statement
	///
	RecordList select( 
		const QString & where = QString::null,
		const VarList & args = VarList(),
		bool selectChildren = true,
		bool expectSingle = false,
		bool needResults = true );
	
	RecordList selectOnly( const QString & where, const VarList & args = VarList(), bool needResults = true, bool cacheIncoming = false );
	RecordList selectMulti( TableList tables, const QString & innerWhere, const VarList & innerArgs = VarList(),
			const QString & outerWhere = QString(), const VarList & outerArgs = VarList(), bool needResults = true, bool cacheIncoming = false );

	/**
	 * Inserts the record into the database
	 * This function will get an array of
	 * variants using RecordImp::set(QVariant*)
	 * It will then generate a sql statement and
	 * use QSqlQuery::addBindValue( QVariant & )
	 * to insert the values
	 *
	 * If newPrimaryKey is false, the record is inserted
	 * with the RecordImp->mKey as the primary key,
	 * otherwise it will use the tables sequence and
	 * set RecordImp->mKey.
	 *
	 *  @return false on failure
	 */
	bool insert( const Record & rb, bool newPrimaryKey = true );
	bool insert( const RecordList & rb, bool newPrimaryKey = true );

	void update( RecordImp * r );
	/**
	 * Removes the record from the indexes
	 * and deletes the object
	 **/
	int remove( const Record & rb );
	int remove( const RecordList & );

	/// Returns true if the table exists in the database, no schema verification is performed
	bool exists() const;
	/// Verify that the table and needed columns exist in the database
	bool verifyTable( bool createMissingColumns = false, QString * output=0 );
	/// Trys to create the table in the database
	bool createTable( QString * output = 0 );

	/**
	 * Called by the slaveresult object to return results
	 * of the executed select query
	 **/
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

	QMap<uint, bool> mProjectPreload;

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

protected:
	void setup();

	FieldList deleteActions() const;
	void addDeleteAction( Field * );
	void removeDeleteAction( Field * );

	RecordList gatherToRemove( const RecordList & toRemove );

	Record checkForUpdate( Record rec );
	
	void recordsIncoming( const RecordList &, bool ci=false );

	Database * mDatabase;

	TableSchema * mSchema;

	KeyIndex * mKeyIndex;

	QHash<IndexSchema*,Index*> mSchemaToIndex;

	Table * mParent;
	TableList mChildren;

	// These are the dependancies, that
	// are either deleted or updated on
	// delete of records from this table
	// We use the field's index to look
	// up records using our primary key
	FieldList mDeleteActions;
	
	IndexList mIndexes;
	bool mPreloaded;
	QString mWhere;

	int mSqlElapsed[4];
	int mIndexElapsed[5];
	
	bool mSqlGenerated;
	QString mSqlSelect;
	
	friend class Stone::UpdateManager;
	friend class Stone::RecordUndoOperation;
	friend class Stone::Database;
	friend class Stone::Field;
public:
	int mImpCount;
	RecordImp * mEmptyImp;
};

} //namespace

#endif // TABLE_H

