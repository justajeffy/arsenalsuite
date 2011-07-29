
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

#include <qapplication.h>
#include <qcursor.h>
#include <qdatetime.h>
#include <qsqldatabase.h>
#include <qsqlquery.h>
#include <qsqlerror.h>
#include <qtextstream.h>
#include <qstringlist.h>

#include "blurqt.h"
#include "connection.h"
#include "table.h"
#include "recordimp.h"
#include "updatemanager.h"
#include "database.h"
#include "freezercore.h"
#include "record.h"
#include "sqlerrorhandler.h"
#include "tableschema.h"
#include "indexschema.h"

namespace Stone {

Table::Table( Database * database, TableSchema * schema )
: mDatabase( database )
, mSchema( schema )
, mKeyIndex( 0 )
, mParent( 0 )
, mPreloaded( false )
, mImpCount( 0 )
, mEmptyImp( 0 )
{
	for( int i = 0; i < 4; i++ )
		mSqlElapsed[i] = 0;
	for( int i = 0; i < 5; i++ )
		mIndexElapsed[i] = 0;

	mEmptyImp = new RecordImp( this, 0 );
	mEmptyImp->mState = RecordImp::EMPTY_SHARED;
	mEmptyImp->ref();
}

void Table::setup()
{
	foreach( IndexSchema * is, mSchema->indexes() ) {
		Index * i = 0;
		if( is->field() && is->field()->flag(Field::PrimaryKey) )
			i = mKeyIndex = new KeyIndex( this, is );
		else
			i = new HashIndex( this, is );
		addIndex( i );
	}
	if( mSchema->parent() )
		mParent = mDatabase->tableFromSchema( mSchema->parent() );
	foreach( TableSchema * ts, mSchema->children() )
		mChildren += mDatabase->tableFromSchema( ts );
	foreach( Field * f, mSchema->columns() ) {
		if( !mKeyIndex && f->flag( Field::PrimaryKey ) )
			addIndex( mKeyIndex = new KeyIndex( this, f->index() ) );
		if( f->indexDeleteMode() ) {
			Table * fkey = mDatabase->tableFromSchema( f->foreignKeyTable() );
			if( !fkey ) {
				LOG_1( "Unable to find table for delete action: " + f->foreignKey() );
				continue;
			}
			mDatabase->tableFromSchema( f->foreignKeyTable() )->addDeleteAction( f );
		}
	}
}

Table::~Table()
{
	foreach( Index * i, indexes() )
		delete i;
	mKeyIndex = 0;
}

Connection * Table::connection() const
{
	return mDatabase->connection();
}

Table * Table::parent() const
{
	return mParent;
}

QList<Table*> Table::inherits()
{
	TableList ret;
	Table * t = mParent;
	while( t ) {
		ret.push_front( t );
		t = t->parent();
	}
	return ret;
}

QList<Table*> Table::children()
{
	return mChildren;
}

QList<Table*> Table::tableTree()
{
	TableList ret;
	ret += this;
	foreach( Table * t, mChildren )
		ret += t->tableTree();
	return ret;
}

Record Table::load( QVariant * v )
{
	return Record( new RecordImp( this, v ), false );
}

Record * Table::newObject()
{
	return new Record( new RecordImp( this ), false );
}

void Table::preload()
{
	if( schema()->isPreloadEnabled() && !mPreloaded )
		select("",VarList(), true, false, false);
}

bool Table::isPreloaded() const
{
	return mPreloaded;
}

void Table::preloadProject( uint pkey )
{
	mProjectPreload[pkey] = true;
	TableList tl = tableTree() + inherits();
	foreach( Table * t, tl )
		t->setCacheIncoming( true );
	if( mSchema->fieldPos( "fkeyProject" ) >= 0 )
		select("WHERE fkeyproject=" + QString::number( pkey ),VarList(), true, false, false);
	else
		select("INNER JOIN Element ON " + mSchema->tableName() + "." + mSchema->projectPreloadColumn() +
			"=Element.keyElement WHERE Element.fkeyProject=" + QString::number(pkey), VarList(), true, false, false);
	foreach( Table * t, tl )
		t->setCacheIncoming( false );
}
	
bool Table::isProjectPreloaded( uint fkeyElement, bool preloadNow )
{
	if( mSchema->isPreloadEnabled() ) {
		preload();
		return true;
	}
	
	if( mSchema->projectPreloadColumn().isEmpty() ){
		if( mParent )
			return mParent->isProjectPreloaded( fkeyElement );
		return false;
	}
	
	Table * elTable = mDatabase->tableByName( "Element" );
	if( !elTable )
		return false;

	Record r( elTable->record( fkeyElement, false ) );
	if( r.isRecord() ){
		uint projectKey = r.getValue( "fkeyProject" ).toUInt();
		if( projectKey ) {
			QMap<uint,bool>::Iterator it = mProjectPreload.find( projectKey );
			if( it==mProjectPreload.end() ) {
				if( preloadNow )
					preloadProject( projectKey );
				else
					return false;
			}
			return true;
		}
	}
	return false;
}

IndexList Table::indexes()
{
	return mIndexes;
}

Index * Table::indexFromSchema( IndexSchema * schema ) const
{
	QHash<IndexSchema*,Index*>::const_iterator it = mSchemaToIndex.find( schema );
	if( it == mSchemaToIndex.end() ) {
		if( mParent ) return mParent->indexFromSchema( schema );
		return 0;
	}
	return it.value();
}

Index * Table::indexFromField( const QString & name ) const
{
	Field * field = schema()->field(name);
	if( field && field->index() )
		return indexFromSchema( field->index() );
	return 0;
}

Index * Table::index( const QString & name ) const
{
	IndexSchema * is = mSchema->index(name);
	return is ? indexFromSchema(is) : 0;
}

KeyIndex * Table::keyIndex() const
{
	return mKeyIndex;
}

void Table::clearIndexes()
{
	foreach( Index * i, mIndexes )
		i->clear();
}

void Table::addIndex( Index * index )
{
	if( !mIndexes.contains( index ) ) {
		mIndexes += index;
		mSchemaToIndex.insert( index->schema(), index );
	}
}

void Table::removeIndex( Index * index, bool dontDelete )
{
	mIndexes.removeAll( index );
	mSchemaToIndex.remove( index->schema() );
	if( !dontDelete )
		delete index;
}

Record Table::record( uint key, bool doSelect, bool useCache, bool baseOnly )
{
	Record ret( this );

	if( key==0 )
		return ret;

	bool preloadCheck = false;
	while( useCache ) {
		foreach( Table * t, tableTree() ) {
			KeyIndex * ki = t->keyIndex();
			if( ki ) {
				bool found = false;
				ret = ki->record( key, &found );
				// Ignore empty entries for child tables
				if( found && (ret.isRecord() || t == this) )
					return ret;
			}
		}

		if( preloadCheck ) break;
		preload();
		preloadCheck = true;
	}

	if( doSelect ){
		VarList args;
		args += key;
		RecordList res = select( mSchema->primaryKey() + "=?", args, !baseOnly, true );
		if( res.size() )
			return res[0];
		// Since this record was never found, we don't want to waste time selecting again
		if( useCache && mKeyIndex )
			mKeyIndex->setEmptyEntry( args );
	}	
	return ret;
}

template<class T> static QList<T> unique( QList<T> list )
{
	return list.toSet().toList();
}

RecordList Table::records( QList<uint> keys, bool select, bool useCache )
{
	RecordList ret;
	if( keys.isEmpty() )
		return RecordList();

	// Make the list unique
	keys = unique(keys);

	QStringList strs;
	QList<uint> selecting;
	foreach( uint key, keys ) {
		if( key == 0 ) continue;
		if( useCache ) {
			Record r = record( key, false, true );
			if( r.isRecord() ) {
				ret += r;
				continue;
			}
		}
		strs += QString::number( key );
		selecting += key;
	}
	if( !strs.isEmpty() && select ) {
		RecordList tmp = records( strs.join( "," ) );
		// Set empty entries
		if( selecting.size() != static_cast<int>(tmp.size()) ) {
			foreach( uint key, selecting ) {
				if( mKeyIndex && tmp.filter( mSchema->primaryKey(), key ).isEmpty() )
					mKeyIndex->setEmptyEntry( VarList() += key );
			}
		}
		ret += tmp;
	}
	return ret;
}

// keystring is a comma seperated list of keys eg "1,2,999999,10202020202020"
RecordList Table::records( const QString & keystring )
{
	if( keystring.isEmpty() ) return RecordList();
	return select( "WHERE " + mSchema->primaryKey() + " IN (" + keystring + ")" );
}

void Table::setCacheIncoming( bool ci )
{
	foreach( Index * i, mIndexes )
		i->cacheIncoming( ci );
}

void Table::recordsAdded( RecordList recs, bool notifyIndexes )
{
	if( notifyIndexes ) {
		QTime time;
		time.start();
		foreach( Index * i, mIndexes )
			foreach( Record r, recs )
				i->recordAdded( r );
		addIndexTime( time.elapsed(), IndexAdded );

		// Call added on the parent after the current, so that
		// another select(project preload) doesn't load another
		// version of one of the records and put it in our key
		// cache before we can do it, causing two versions of
		// the same record
		if( mParent )
			mParent->recordsAdded( recs );
	}

	if( notifyIndexes && (QThread::currentThread() != qApp->thread() || mDatabase->queueRecordSignals()) ) {
		QMetaObject::invokeMethod( this, "recordsAdded", Qt::QueuedConnection, Q_ARG(RecordList, recs), Q_ARG(bool, false) );
		return;
	}
	
	emit added( recs );
}

void Table::recordsRemoved( RecordList recs, bool notifyIndexes )
{
	if( notifyIndexes ) {
		if( mParent )
			mParent->recordsRemoved( recs );
		
		QTime time;
		time.start();
		foreach( Index * i, mIndexes )
			foreach( Record r, recs )
				i->recordRemoved( r );
		addIndexTime( time.elapsed(), IndexRemoved );
	}

	if( notifyIndexes && (QThread::currentThread() != qApp->thread() || mDatabase->queueRecordSignals()) ) {
		QMetaObject::invokeMethod( this, "recordsRemoved", Qt::QueuedConnection, Q_ARG(RecordList, recs), Q_ARG(bool, false) );
		return;
	}

	emit removed( recs );
}

void Table::recordUpdated( const Record & current, const Record & upd, bool notifyIndexes )
{
	if( notifyIndexes ) {
		if( mParent )
			mParent->recordUpdated( current, upd );
			
		QTime time;
		time.start();
		foreach( Index * i, mIndexes )
			i->recordUpdated( current, upd );
		addIndexTime( time.elapsed(), IndexUpdated );
	}

	if( notifyIndexes && (QThread::currentThread() != qApp->thread() || mDatabase->queueRecordSignals()) ) {
		QMetaObject::invokeMethod( this, "recordUpdated", Qt::QueuedConnection, Q_ARG(Record, current), Q_ARG(Record, upd), Q_ARG(bool, false) );
		return;
	}

	emit updated( current, upd );
}

void Table::recordsIncoming( const RecordList & records, bool ci )
{
	if( mParent )
		mParent->recordsIncoming( records, ci );
	
	QTime time;
	time.start();
	foreach( Index * i, mIndexes )
		i->recordsIncoming( records, ci );
	addIndexTime( time.elapsed(), IndexIncoming );
}

RecordList Table::select( const QString & where, const VarList & args, bool selectChildren, bool expectSingle, bool needResults )
{
	RecordList ret;
	TableList mgl;
	QString w = where;
	bool cacheCandidate = where.simplified().isEmpty();

	// Fill mgl with tables to select from
	if( selectChildren )
		mgl = tableTree();
	else
		mgl += this;

	if( mgl.size() > 1 && (connection()->capabilities() & Connection::Cap_MultiTableSelect) ) {
		ret = selectMulti( mgl, w, args, QString(), VarList(), needResults, cacheCandidate );
	} else {
		for( TableIter it = mgl.begin(); ; ){
			Table * man = *it;
	
			//LOG_5( "Selecting from table: " + man->tableName() );
			// Perform the select
			RecordList res = man->selectOnly( w, args, needResults, cacheCandidate && (selectChildren || man->children().isEmpty()) );
	
			if( res.size() )
			{
				// Add results to return list
				ret += res;
			}
			
			++it;
	
			// Return if that was the last table or if we have enough results
			if( it == mgl.end() || (ret.size() && expectSingle) )
				break;
	
			// Massage where clause for next table
			w.replace( man->schema()->tableName() + ".", (*it)->schema()->tableName() + ".", Qt::CaseInsensitive);
		}
	}
	return ret;
}

/*
Table * Table::importSchema( const QString & tableName, Database * parent )
{
	QString out;
	QString info_query( "select att.attname, typ.typname from pg_class cla "
			"inner join pg_attribute att on att.attrelid=cla.oid "
			"inner join pg_type typ on att.atttypid=typ.oid "
			"where cla.relkind='r' AND cla.relnamespace=2200 AND att.attnum>0 AND cla.relname='" );
	
	info_query += tableName().lower() + "';";
	
	QSqlQuery q( info_query );
	if( !q.isActive() )
	{
		out += warnAndRet( "Unable to select table information for table: " + tableName() );
		out += warnAndRet( "Error was: " + q.lastError().text() );
		return 0;
	}

	Table * ret = new Table( parent );

	while( q.next() ) {
		QString fieldName = q.value(0).toString();
		QString type = q.value(1).toString();
		int ft = fieldTypeFromPgType( type );
		if( ft == Field::Invalid ) continue;
		new Field( ret, fieldName, false, ft );
	}
	
	return ret;
}
*/


RecordList Table::selectOnly( const QString & where, const VarList & args, bool needResults, bool cacheIncoming )
{
	RecordList ret;

	// No values in the table, only used as a base for inheritance
	if( mSchema->baseOnly() )
		return ret;

	// If this table is preloaded, and a parent table is filling some
	// caches, we need to return the records to fill the cache.
	// Returning all values from this table should work fine.
	// This could be slower in some situations if there is an index
	// on this select in the db and there are a lot of records in
	// this table, but usually one wouldn't use preload if there are
	// a lot of records.
	if( mPreloaded && mKeyIndex && (!needResults || where.isEmpty()) ) {
		//LOG_5( "Returning preloaded values" );
		return mKeyIndex->values();
	}
	
	if( where.toLower().contains( "for update" ) && !mDatabase->ensureInsideTransaction() )
		return ret;
	
	RecordList raw = connection()->selectOnly( this, where, args );

	if( mKeyIndex ) {
		foreach( Record r, raw )
			ret += checkForUpdate( r );
	} else
		ret = raw;

	recordsIncoming( ret, cacheIncoming );
	mDatabase->recordsIncoming( ret, cacheIncoming );

	// Don't select if where is empty and we already have the table contents
	if( where.isEmpty() && mSchema->isPreloadEnabled() )
		mPreloaded = true;

	return ret;
}

RecordList Table::selectMulti( TableList tables, const QString & innerWhere, const VarList & innerArgs, const QString & outerWhere, const VarList & outerArgs, bool needResults, bool cacheIncoming )
{
	RecordList ret;

	// If this table is preloaded, and a parent table is filling some
	// caches, we need to return the records to fill the cache.
	// Returning all values from this table should work fine.
	// This could be slower in some situations if there is an index
	// on this select in the db and there are a lot of records in
	// this table, but usually one wouldn't use preload if there are
	// a lot of records.
	if( mPreloaded && mKeyIndex && (!needResults || (innerWhere.isEmpty() && outerWhere.isEmpty())) ) {
		LOG_5( "Returning preloaded values" );
		return mKeyIndex->values();
	}
	
	if( innerWhere.toLower().contains( "for update" ) && !mDatabase->ensureInsideTransaction() )
		return ret;
	
	QMap<Table*,RecordList> resultsByTable = connection()->selectMulti( tables, innerWhere, innerArgs, outerWhere, outerArgs );

	for( QMap<Table*,RecordList>::iterator it = resultsByTable.begin(); it != resultsByTable.end(); ++it ) {
		Table * t = it.key();
		RecordList results = it.value();
		RecordList updated;
		foreach( Record r, results )
			updated += t->checkForUpdate( r );
		t->recordsIncoming( updated, cacheIncoming );
		mDatabase->recordsIncoming( updated, cacheIncoming );
		ret += updated;
	}

	// Don't select if where is empty and we already have the table contents
	if( innerWhere.isEmpty() && outerWhere.isEmpty() && mSchema->isPreloadEnabled() ) {
		foreach( Table * t, tables )
			t->mPreloaded = true;
	}

	return ret;
}

void Table::selectFields( RecordList records, FieldList fields )
{
    if( fields.isEmpty() || records.isEmpty() ) return;
    RecordList validRecords;
    foreach( Record r, records )
        if( r.table() == this )
            validRecords += r;
    FieldList validFields, myFields( schema()->columns() );
    foreach( Field * f, fields )
        if( myFields.contains( f ) )
            validFields += f;
    connection()->selectFields( this, validRecords, validFields );
}

bool Table::insert( const RecordList & rl, bool newPrimaryKey )
{
	if( !mDatabase->ensureInsideTransaction() )
		return false;

	mSchema->preInsert( rl );

	connection()->insert( this, rl, newPrimaryKey );
	//LOG_5( "postInsert" );
	mSchema->postInsert( rl );

	//LOG_5( "UpdateManager::recordsAdded" );
	UpdateManager::instance()->recordsAdded( this, rl );
	//LOG_5( "recordsAdded" );
	recordsAdded( rl );
	//LOG_5( "mDatabase->recordsAdded" );
	mDatabase->recordsAdded( rl, true );
	//LOG_5( "done" );
	return true;
}

bool Table::insert( const Record & rb, bool newPrimaryKey )
{
	return insert( RecordList() += rb, newPrimaryKey );
}

Record Table::checkForUpdate( Record rec )
{
	// If we can find the original record in our key cache,
	// than we will
	// 1. Create a temporary record with the old values
	// 2. Updated the original with the new values
	// 3. Call recordUpdated
	if( !mKeyIndex ) return rec;
	Record bu = mKeyIndex->record( rec.key(), 0 );
	if( bu.isRecord() ) {
		RecordImp * master = bu.imp();
		Record old( master->copy(), false );
		master->set( &(*rec.imp()->mValues)[0] );
		bool needsUpdateSignal = false;
		FieldList fl = mSchema->fields();
		foreach( Field * f, fl ) {
            // Don't do a comparison if the before-update record didn't have this column selected
            if( f->flag( Field::NoDefaultSelect ) && !bu.imp()->isColumnSelected( f->pos() ) )
                continue;
			QVariant v1 = bu.getValue( f->pos() );
			QVariant v2 = old.getValue( f->pos() );
			if( (v1.isNull() != v2.isNull()) || (v1 != v2) ) {
				//LOG_5( "Field " + f->name() + " updated from " + v2.toString() + " to " + v1.toString() );
				needsUpdateSignal = true;
				break;
			}
		}
		if( needsUpdateSignal ) {
			UpdateManager::instance()->recordUpdated( this, bu, old );
			recordUpdated( bu, old );
			mDatabase->recordUpdated( bu, old, true );
		}
		return bu;
	}
	return rec;
}

void Table::update( RecordImp * imp )
{
	// Must be a modified, committed record to be updated
	if( imp->mState != (RecordImp::MODIFIED|RecordImp::COMMITTED) ) {
		qWarning( "Table::update: Update on record that is not both committed and modified" );
		return;
	}
	
	bool nc = false, selectAfterUpdate = false;
	FieldList fields = mSchema->columns();
	
	mSchema->preUpdate( Record(imp,false), mKeyIndex ? mKeyIndex->record( imp->key(), 0 ) : Record() );

	foreach( Field * f, schema()->columns() )
		if( imp->isColumnLiteral( f->pos() ) ) {
			selectAfterUpdate = true;
			nc = true;
		} else if ( imp->isColumnModified( f->pos() ) )
			nc = true;
	
	// There were no columns to update
	if( !nc ) {
		//qWarning( "Table::update: Record had MODIFIED field set, but no modified columns" );
		return;
	}
		
	if( !mDatabase->ensureInsideTransaction() )
		return;
	
	Connection * c = connection();
	Record ret(imp,false);
	bool askForRet = selectAfterUpdate && (c->capabilities() & Connection::Cap_Returning);
	bool success = c->update( this, imp, askForRet ? &ret : 0 );
	if( success ) {
		mSchema->postUpdate( ret, mKeyIndex ? mKeyIndex->record( imp->key(), 0 ) : Record() );
		imp->clearModifiedBits();
		if( selectAfterUpdate && !askForRet )
			// Refresh the record from the database, to get any columns changed via triggers, etc.
			selectOnly( mSchema->primaryKey() + "=" + QString::number( imp->key() ), VarList(), true );
		else
			// Check to see if the original record exists in memory, if so, update it
			checkForUpdate( ret );
	}
}

int Table::remove( const Record & rb )
{
	return remove( RecordList() += Record( rb ) );
}

int Table::remove( const RecordList & const_list )
{
	RecordList rl( const_list );
	rl = gatherToRemove( const_list );
	QStringList keys;
	for( RecordIter it = rl.begin(); it != rl.end(); )
	{
		if( !(*it).key() || (it.imp()->mState & RecordImp::DELETED) ){
			it = rl.remove( it );
			continue;
		}
		keys += QString::number( (*it).key() );
		it.imp()->mState = RecordImp::DELETED;
		++it;
	}

	if( keys.isEmpty() )
		return 0;

	if( !mDatabase->ensureInsideTransaction() )
		return -1;

	mSchema->preRemove( rl );

	int result = connection()->remove( this, keys );
	if( result >= 0 ) {
		UpdateManager::instance()->recordsDeleted( this, rl );
		recordsRemoved( rl );
		mDatabase->recordsRemoved( rl, true );
		mSchema->postRemove(rl);
	}
	return result;
}

RecordList Table::gatherToRemove( const RecordList & toRemove )
{
	RecordList our_remove;
	FieldList das = deleteActions();
	for( RecordIter it = toRemove.begin(); it != toRemove.end(); ++it )
	{
		if( (*it).key() == 0 ) continue;
		if( mKeyIndex )
			our_remove += mKeyIndex->record( (*it).key(), 0 );
		else
			our_remove += *it;
		foreach( Field * f, das ) {
			int dm = f->indexDeleteMode();
			if( dm == Field::DoNothingOnDelete ) continue;
			Table * t = mDatabase->tableFromSchema( f->table() );
			Index * i = t->indexFromSchema( f->index() );
			RecordList fkeys = i->recordsByIndex( (*it).key() );
			if( dm == Field::UpdateOnDelete ) {
				for( RecordIter uit = fkeys.begin(); uit != fkeys.end(); ++uit )
					(*it).setValue( f->name(), QVariant( 0 ) );
				fkeys.commit();
			} else if( dm == Field::CascadeOnDelete ) {
				if( t == this )
					our_remove += gatherToRemove( fkeys );
				else
					fkeys.remove();
			}
		}
	}
	return our_remove;
}

FieldList Table::deleteActions() const
{
	FieldList ret = mDeleteActions;
	if( mParent ) ret += mParent->deleteActions();
	return ret;
}

void Table::addDeleteAction( Field * f )
{
	if( !mDeleteActions.contains( f ) ) {
		if( mDatabase->tableFromSchema( f->table() ) == this ) // A relation to the same table
			mDeleteActions.push_front( f );
		else
			mDeleteActions += f;
	}
}

void Table::removeDeleteAction( Field * f )
{
	mDeleteActions.removeAll( f );
}

void Table::addSqlTime( int ms, int action )
{
	if( action >= SqlInsert && action <= SqlDelete )
		mSqlElapsed[action] += ms;
}

int Table::elapsedSqlTime( int action ) const
{
	int ret = 0;
	for( int i = SqlInsert; i <= SqlDelete; ++i )
		if( action == i || action == SqlAll )
			ret += mSqlElapsed[i];
	return ret;
}

void Table::printStats()
{
	// Dont print stats for a table that has none
	if( elapsedIndexTime() + elapsedSqlTime() == 0 ) return;

	LOG_3( "'" + mSchema->tableName() + "'          Sql Time Elapsed" );
	LOG_3( "|   Select  |   Update  |  Insert  |  Delete  |  Total  |" );
	LOG_3( "-----------------------------------------------" );
	LOG_3( QString(	"|     %1    |     %2    |    %3    |    %4    |    %5   |\n")
						.arg( elapsedSqlTime( Table::SqlSelect ) )
						.arg( elapsedSqlTime( Table::SqlUpdate ) )
						.arg( elapsedSqlTime( Table::SqlInsert ) )
						.arg( elapsedSqlTime( Table::SqlDelete ) )
						.arg( elapsedSqlTime() )
	);
	LOG_3(	"                  Index Time Elapsed" );
	LOG_3(	"|   Added  |   Updated  |  Incoming  |  Deleted  |  Search  |  Total  |" );
	LOG_3( "-----------------------------------------------" );
	LOG_3( QString(	"|     %1     |     %2    |    %3    |    %4   |    %5    |   %6    |\n")
						.arg( elapsedIndexTime( Table::IndexAdded ) )
						.arg( elapsedIndexTime( Table::IndexUpdated ) )
						.arg( elapsedIndexTime( Table::IndexIncoming ) )
						.arg( elapsedIndexTime( Table::IndexRemoved ) )
						.arg( elapsedIndexTime( Table::IndexSearch ) )
						.arg( elapsedIndexTime() )
	);

	foreach( Index * i, mIndexes )
		i->printStats();
}

void Table::addIndexTime( int ms, int action )
{
	if( action >= IndexAdded && action <= IndexSearch )
		mIndexElapsed[action] += ms;
}

int Table::elapsedIndexTime( int action ) const
{
	int ret = 0;
	for( int i = IndexAdded; i <= IndexSearch; ++i )
		if( action == i || action == IndexAll )
			ret += mIndexElapsed[i];
	return ret;
}

bool Table::exists() const
{
	return connection()->tableExists( schema() );
}

bool Table::verifyTable( bool createMissingColumns, QString * output )
{
	return connection()->verifyTable( schema(), createMissingColumns, output );
}

bool Table::createTable( QString * output )
{
	return connection()->createTable( schema(), output );
}

RecordImp * Table::emptyImp()
{
	return mEmptyImp;
}

} //namespace

