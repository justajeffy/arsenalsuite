
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

#include <qregexp.h>
#include <qdatetime.h>
#include <vector>
#include <algorithm>

#include "blurqt.h"
#include "table.h"
#include "tableschema.h"
#include "recordlist.h"
#include "record.h"
#include "recordimp.h"
#include "recordlist_p.h"

RecordList::RecordList()
: d( 0 )
{
}

RecordList::RecordList( const RecordList & other, Table * table )
: d( other.d )
{
	if( d ){
		d->mCount.ref();
		if( table && table != other.table() ){
			for( ConstImpIter it = other.d->mList.begin(); it != other.d->mList.end(); ++it ) {
				Table * t = (*it)->table();
				if( t != table && !t->inherits().contains( table ) ){
					detach( table );
					break;
				}
			}
		}
	}
}

RecordList::RecordList( const RecordList & other )
: d( other.d )
{
	if( d ){
		d->mCount.ref();
	}
}

RecordList::RecordList( const ImpList & recs, Table * table )
: d( new Private )
{
	d->mList = recs;
	d->mCount.ref();
	TableList tl = table ? table->tableTree() : TableList();
	for( ImpIter it = d->mList.begin(); it != d->mList.end(); ){
		if( table ){
			Table * t = (*it)->table();
			if( !tl.contains( t ) ){
				it = d->mList.erase( it );
				continue;
			}
		}
		(*it)->ref();
		++it;
	}
}

RecordList::RecordList( const Record & rec, Table * table )
: d( new Private )
{
	d->mCount.ref();
	if( rec.imp() && (!table || table->tableTree().contains( rec.table() ) ) ){
		d->mList += rec.imp();
		rec.imp()->ref();
	}
}

RecordList::~RecordList()
{
	clear();
}

RecordList & RecordList::operator=( const RecordList & other )
{
	if( d == other.d )
		return *this;

	clear();
	d = other.d;
	if( d ){
		d->mCount.ref();
		Table * tab = table();
		if( tab ){
			TableList tl = tab->tableTree();
			for( ConstImpIter it = other.d->mList.begin(); it != other.d->mList.end(); ++it ) {
				if( !tl.contains( (*it)->table() ) ){
					detach( tab );
					break;
				}
			}
		}
	}
	return *this;
}

bool RecordList::operator==( const RecordList & other )
{
	bool lh = (d && !d->mList.isEmpty());
	bool rh = (other.d && !other.d->mList.isEmpty());
	if( !lh && !rh )
		return true;
	if( lh && rh )
		return d->mList==other.d->mList;
	return false;
}

Record RecordList::operator []( uint i ) const
{
	if( !d || (i >= (uint)d->mList.size()) )
		return Record();
	return Record( (RecordImp*)(d->mList[i]), false );
}

RecordList & RecordList::operator += ( RecordImp * imp )
{
	if( !imp ) {
		qWarning( "0 imp passed to RecordList += " );
		return *this;
	}

	detach();
	
	Table * tab = table();
	if( !tab || tab==imp->table() || imp->table()->inherits().contains( tab ) ){
		d->mList += imp;
		imp->ref();
	} else {
		LOG_1( "RecordList::operator+=: Non " + tab->schema()->tableName() + " imp passed to RecordList += " );
	}
	return *this;
}

RecordList & RecordList::operator += ( const Record & t )
{
	return this->operator+=( t.imp() );
}

RecordList & RecordList::operator += ( const RecordList & list )
{
	if( list.d ){
		detach();
		Table * tab = table();
		for( QList<RecordImp*>::ConstIterator it = list.d->mList.begin(); it != list.d->mList.end(); ++it ){
			Table * t = (*it)->table();
			if( !tab || t==tab || t->inherits().contains( tab ) ){
				d->mList += *it;
				(*it)->ref();
			}
		}
	}
	return *this;
}

RecordList RecordList::operator + ( const RecordList & other )
{
	RecordList copy( *this );
	return copy += other;
}

RecordList & RecordList::operator -= ( const RecordList & rl )
{
	detach();
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, rl )
		map[it.imp()] = true;
	for( RecordIter it = begin(); it != end(); )
		if( !map.contains( it.imp() ) )
			++it;
		else
			it = remove( it );
	return *this;
}

RecordList RecordList::operator - ( const RecordList & rl )
{
	RecordList ret;
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, rl )
		map[it.imp()] = true;
	st_foreach( RecordIter, it, (*this) )
		if( !map.contains( it.imp() ) )
			ret += *it;
	return ret;	
}

RecordList RecordList::operator & ( const RecordList & rl )
{
	RecordList ret;
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, rl )
		map[it.imp()] = true;
	st_foreach( RecordIter, it, (*this) )
		if( map.contains( it.imp() ) )
			ret += *it;
	return ret;
}

RecordList & RecordList::operator &= ( const RecordList & rl )
{
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, rl )
		map[it.imp()] = true;
	for( RecordIter it = begin(); it != end(); )
		if( map.contains( it.imp() ) )
			++it;
		else
			it = remove( it );
	return *this;
}

bool RecordList::operator && ( const RecordList & rl )
{
	return !(*this & rl).isEmpty();
}

RecordList RecordList::operator | ( const RecordList & rl )
{
	RecordList ret( rl );
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, rl )
		map[it.imp()] = true;
	st_foreach( RecordIter, it, (*this) )
		if( !map.contains( it.imp() ) )
			ret += *it;
	return ret;
}

RecordList & RecordList::operator |= ( const RecordList & rl )
{
	QMap<RecordImp*,bool> map;
	st_foreach( RecordIter, it, (*this) )
		map[it.imp()] = true;
	st_foreach( RecordIter, it, rl )
		if( !map.contains( it.imp() ) )
			(*this) += *it;
	return *this;
}

bool RecordList::operator || ( const RecordList & rl )
{
	return !rl.isEmpty() || !isEmpty();
}

RecordIter RecordList::at( uint pos ) const
{
	if( !d || pos >= (uint)d->mList.size() )
		return end();
	return RecordIter( d->mList.begin() + pos );
}

RecordImp * RecordList::imp( uint pos ) const
{
	if( !d )
		return 0;
	return (RecordImp*)(*d->mList.begin() + pos );
}

int RecordList::findIndex( const Record & r )
{
	if( d && r.imp() ){
		return d->mList.indexOf( r.imp() );
	}
	return -1;
}

RecordIter RecordList::find( const Record & val )
{
	if( !d || !val.imp() )
		return end();
	return RecordIter( d->mList.begin() + d->mList.indexOf( val.imp() ) );
}

void RecordList::append( const Record & t )
{
	if( t.imp() ) {
		detach();
		d->mList += t.imp();
		t.imp()->ref();
	}
}
	
void RecordList::insert( RecordIter it, const Record & r )
{
	if( r.imp() ) {
		detach();
		it.make_valid( *this );
		d->mList.insert( it.mIter, r.imp() );
		r.imp()->ref();
	}
}

bool RecordList::update( const Record & record )
{
	// No way to compare if the record doesn't have a primary key
	// and likely the update isn't needed because a copy wasnt made
	if( !record.isRecord() ) return false;

	detach();

	Table * table = record.table();
	uint key = record.key();
	for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ) {
		if( (*it)->table() == table && (*it)->key() == key && (*it) != record.imp() ) {
			(*it)->deref();
			(*it) = record.imp();
			(*it)->ref();
			return true;
		}
	}
	return false;
}

void RecordList::detach( Table * table )
{
	if( d && d->mCount > 1 ){
		Private * p = new Private;
		p->mCount.ref();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Table * t = (*it)->table();
			if( !table || t==table || t->inherits().contains( table ) ){
				p->mList += *it;
				(*it)->ref();
			}
		}
		d->mCount.deref();
		d = p;
	}
	if( !d ) {
		d = new Private;
		d->mCount.ref();
	}
}

int RecordList::remove( const Record & t )
{
	return remove( t.imp() );
}

int RecordList::remove( RecordImp * imp )
{
	if( d && imp ){
		int pos = d->mList.indexOf( imp );
		if( pos >= 0 ) {
			detach();
			ImpIter it = d->mList.begin() + pos;
			d->mList.erase( it );
			if( imp )
				imp->deref();
			return pos;
		}
	}
	return -1;
}

RecordIter RecordList::remove( const RecordIter & it )
{
	if( d && it.mIter != d->mList.end() ){
		detach();
		RecordIter torem = find( *it );
		(*it.mIter)->deref();
		return RecordIter( d->mList.erase( torem.mIter ) );
	}
	return end();
}

bool RecordList::contains( const Record & t ) const
{
	return (d && d->mList.contains( t.imp() ));
}

bool RecordList::contains( RecordImp * ri ) const
{
	return (d && d->mList.contains( ri ) );
}

uint RecordList::size() const
{
	return d ? d->mList.size() : 0;
}

uint RecordList::count() const
{
	return d ? d->mList.count() : 0;
}

bool RecordList::isEmpty() const
{
	return (!d || d->mList.isEmpty());
}

void RecordList::clear()
{
	if( d ){
		d->mCount.deref();
		if( d->mCount == 0 ){
			for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it )
				(*it)->deref();
			delete d;
		}
		d = 0;
	}
}

void RecordList::selectFields( FieldList fields, bool refreshExisting )
{
	LOG_5( "size: " + QString::number(size()) );
	bool selectAllNeeded = fields.isEmpty() && !refreshExisting;
	if( fields.isEmpty() && refreshExisting ) return;
	
	typedef QMap<Table*,QPair<RecordList,FieldList> > TableRecordFieldMap;
	TableRecordFieldMap byTable;
	for( RecordIter it = begin(); it != end(); ++it ) {
		Record r(*it);
		Table * table = r.table();
		FieldList fieldsByTable;
		
		if( byTable.contains( table ) ) {
			fieldsByTable = byTable[table].second;
			if( selectAllNeeded )
				fieldsByTable = fieldsByTable | r.imp()->notSelectedColumns();
			else if( !refreshExisting )
				fieldsByTable = fieldsByTable | (r.imp()->notSelectedColumns() & fields);
		} else {
			if( selectAllNeeded )
				fieldsByTable = r.imp()->notSelectedColumns();
			else {
				fieldsByTable = fields & table->schema()->fields();
				if( !refreshExisting )
					fieldsByTable = fieldsByTable & r.imp()->notSelectedColumns();
			}
		}
		LOG_5( "fieldsByTable.size(): " + QString::number(fieldsByTable.size()) );
		byTable[table].first += r;
		byTable[table].second = fieldsByTable;
	}
	for( TableRecordFieldMap::Iterator it = byTable.begin(); it != byTable.end(); ++it )
		it.key()->selectFields( it.value().first, it.value().second );
}

void RecordList::commit(bool newPrimaryKey, bool sync)
{
	QMap<Table*,QList<RecordImp*> > byTable;
	for( RecordIter it = begin(); it != end(); ++it )
		byTable[(*it).imp()->table()] += (*it).imp();
	for( QMap<Table*,QList<RecordImp*> >::Iterator it = byTable.begin(); it != byTable.end(); ++it ) {
		Table * table = it.key();
		QList<RecordImp*> imps = it.value();
		RecordList toInsert;
		foreach( RecordImp * imp, imps ) {
			if( sync && !(imp->mState & RecordImp::COMMITTED) && !(imp->mState & RecordImp::DELETED) )
				toInsert += imp;
			else {
				RecordImp * ret = imp->commit(newPrimaryKey,sync);
				if( ret != imp ) {
					int pos = d->mList.indexOf( imp );
					if( pos >= 0 )
						d->mList.replace( pos, ret );
				}
			}
		}
		if( toInsert.size() )
			table->insert( toInsert, newPrimaryKey );
	}
}

int RecordList::remove()
{
	/// TODO: Use savepoints to insure all REMOVES are successfull
	/// or all are rolled back
	RecordList recs_to_del;
	recs_to_del = *this;

	Table * currentTable=0;
	RecordList queue;

	bool hasError = false;
	int result = 0;

	for( RecordIter it = recs_to_del.begin(); ; ++it )
	{
		Table * table = 0;

		if( it != recs_to_del.end() )
			table = it.imp()->table();

		if( currentTable && currentTable!=table ){
			int res = currentTable->remove( queue );
			queue.clear();
			if( res < 0 ) hasError = true;
			else result += res;
		}

		if( it == recs_to_del.end() )
			break;

		currentTable = table;
		queue += *it;
	}
	return hasError ? -1 : result;
}

RecordIter RecordList::begin() const
{
	return RecordIter( *this );
}

RecordIter RecordList::end() const
{
	return RecordIter( *this, true );
}

Table * RecordList::table() const
{
	return 0;
}

QList<QVariant> RecordList::getValue( const QString & column ) const
{
	QList<QVariant> ret;
	if( d )
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it )
			ret += Record( *it, false ).getValue( column );
	return ret;
}

void RecordList::setValue( const QString & column, const QVariant & value )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setValue( column, value );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
}

QList<QVariant> RecordList::getValue( int column ) const
{
	QList<QVariant> ret;
	if( d )
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it )
			ret += Record( *it, false ).getValue( column );
	return ret;
}

QList<QVariant> RecordList::getValue( Field * f ) const
{
	QList<QVariant> ret;
	if( d )
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it )
			ret += Record( *it, false ).getValue( f );
	return ret;
}

void RecordList::setValue( int column, const QVariant & value )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setValue( column, value );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
}

void RecordList::setValue( Field * f, const QVariant & value )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setValue( f, value );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
}

RecordList RecordList::foreignKey( int column ) const
{
	QMap<TableSchema *, QList<uint> > fkeysByTable;
	RecordList ret;
	st_foreach( RecordIter, it, (*this) ) {
		QVariant val = (*it).getValue( column );
		if( val.userType() == qMetaTypeId<Record>() )
			ret += qvariant_cast<Record>(val);
		else if( val.toInt() > 0 ) {
			TableSchema * ts = (*it).table()->schema()->field(column)->foreignKeyTable();
			fkeysByTable[ts] += val.toInt();
		}
	}
	for( QMap<TableSchema *, QList<uint> >::iterator it = fkeysByTable.begin(); it != fkeysByTable.end(); ++it ) {
		ret += it.key()->table()->records( it.value() );
	}
	return ret;
}

RecordList RecordList::foreignKey( Field * f ) const
{
	QMap<TableSchema *, QList<uint> > fkeysByTable;
	RecordList ret;
	st_foreach( RecordIter, it, (*this) ) {
		QVariant val = (*it).getValue( f );
		if( val.userType() == qMetaTypeId<Record>() )
			ret += qvariant_cast<Record>(val);
		else if( val.toInt() > 0 ) {
			TableSchema * ts = f->foreignKeyTable();
			fkeysByTable[ts] += val.toInt();
		}
	}
	for( QMap<TableSchema *, QList<uint> >::iterator it = fkeysByTable.begin(); it != fkeysByTable.end(); ++it ) {
		ret += it.key()->table()->records( it.value() );
	}
	return ret;
}

RecordList RecordList::foreignKey( const QString & column ) const
{
	QMap<TableSchema *, QList<uint> > fkeysByTable;
	RecordList ret;
	st_foreach( RecordIter, it, (*this) ) {
		QVariant val = (*it).getValue( column );
		if( val.userType() == qMetaTypeId<Record>() )
			ret += qvariant_cast<Record>(val);
		else if( val.toInt() > 0 ) {
			TableSchema * ts = (*it).table()->schema()->field(column)->foreignKeyTable();
			fkeysByTable[ts] += val.toInt();
		}
	}
	for( QMap<TableSchema *, QList<uint> >::iterator it = fkeysByTable.begin(); it != fkeysByTable.end(); ++it ) {
		ret += it.key()->table()->records( it.value() );
	}
	return ret;
}

RecordList & RecordList::setForeignKey( int column, const Record & fkey )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setForeignKey( column, fkey );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
	return *this;
}

RecordList & RecordList::setForeignKey( Field * f, const Record & fkey )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setForeignKey( f, fkey );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
	return *this;
}

RecordList & RecordList::setForeignKey( const QString & column, const Record & fkey )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setForeignKey( column, fkey );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
	return *this;
}

void RecordList::setColumnLiteral( const QString & column, const QString & value )
{
	if( d ) {
		detach();
		for( QList<RecordImp*>::Iterator it = d->mList.begin(); it != d->mList.end(); ++it ){
			Record r( *it, false );
			r.setColumnLiteral( column, value );
			if( *it != r.imp() ) {
				(*it)->deref();
				*it = r.imp();
				(*it)->ref();
			}
		}
	}
}

QList<uint> RecordList::keys( int idx ) const
{
	QList<uint> ret;
	st_foreach( RecordIter, it, (*this) ) {
		uint val = 0;
		if( idx == -1 )
			val = (*it).key();
		else
			val = (*it).getValue( idx ).toInt();
		if( val > 0 )
			ret += val;
	}
	return ret;
}

QString RecordList::keyString() const
{
	QStringList keys;
	st_foreach( RecordIter, it, (*this) )
		if( (*it).key() > 0 )
			keys += QString::number( (*it).key() );
	return keys.join(",");
}

RecordList RecordList::filter( const QString & column, const QVariant & value, bool keepMatches ) const
{
	RecordList ret;
	st_foreach( RecordIter, it, (*this) ) {
		if( ((*it).getValue( column ) == value) == keepMatches )
			ret += *it;
	}
	return ret;
}

RecordList RecordList::filter( const QString & column, const QRegExp & re, bool keepMatches ) const
{
	RecordList ret;
	st_foreach( RecordIter, it, (*this) ) {
		if( (*it).getValue( column ).toString().contains( re ) == keepMatches )
			ret += *it;
	}
	return ret;
}

QMap<QString,RecordList> RecordList::groupedBy( const QString & column ) const
{
	QMap<QString,RecordList> ret;
	st_foreach( RecordIter, it, (*this) )
		ret[(*it).getValue(column).toString()] += *it;
	return ret;
}

struct RecordSorter
{
	RecordSorter( const QString & col, bool asc ) : mCol( col ), mAsc( asc ) {}
	bool operator()( const Record & r1, const Record & r2 ) {
		const QVariant & v1 = r1.getValue( mCol );
		const QVariant & v2 = r2.getValue( mCol );
		QVariant::Type t1 = v1.type();
		QVariant::Type t2 = v2.type();
		if( t1 != t2 ) return (&v1 > &v2) ^ mAsc;
		bool ret = false;
		switch( t1 ) {
			case QVariant::Bool:
				ret = v1.toBool() < v2.toBool();
				break;
			case QVariant::Date:
				ret = v1.toDate() < v2.toDate();
				break;
			case QVariant::DateTime:
				ret = v1.toDateTime() < v2.toDateTime();
				break;
			case QVariant::Double:
				ret = v1.toDouble() < v2.toDouble();
				break;
			case QVariant::Int:
				ret = v1.toInt() < v2.toInt();
				break;
			case QVariant::UInt:
				ret = v1.toUInt() < v2.toUInt();
				break;
			case QVariant::LongLong:
				ret = v1.toLongLong() < v2.toLongLong();
				break;
			case QVariant::ULongLong:
				ret = v1.toULongLong() < v2.toULongLong();
				break;
			case QVariant::String:
				return (QString::localeAwareCompare( v1.toString(), v2.toString() ) < 0);
				break;
			case QVariant::Time:
				ret = v1.toTime() < v2.toTime();
				break;
			default: break;
		}
		return mAsc ? ret : !ret;;
	}
	QString mCol;
	bool mAsc;
};

RecordList RecordList::sorted( const QString & column, bool asc ) const
{
	std::vector<Record> vec;
	st_foreach( RecordIter, it, (*this) )
		vec.push_back( *it );
	std::sort( vec.begin(), vec.end(), RecordSorter( column, asc ) );
	RecordList ret;
	for( std::vector<Record>::iterator it = vec.begin(); it != vec.end(); ++it )
		ret += *it;
	return ret;
}

RecordList RecordList::unique() const
{
	QMap<RecordImp*,bool> em;
	st_foreach( RecordIter, it, (*this) )
		if( !em.contains( it.imp() ) )
			em[it.imp()] = true;
	RecordList ret;
	for( QMap<RecordImp*,bool>::Iterator it = em.begin(); it != em.end(); ++it )
		ret += Record( it.key(), false );
	return ret;
}

RecordList RecordList::reversed() const
{
	RecordList ret;
	for( int i=size()-1; i>=0; --i )
		ret += (*this)[i];
	return ret;
}

void RecordList::reload()
{
	st_foreach( RecordIter, it, (*this) )
		(*it).reload();
}

RecordList RecordList::reloaded() const
{
	RecordList ret(*this);
	ret.reload();
	return ret;
}

QString RecordList::dump() const
{
	QStringList ret;
	foreach( Record r, (*this) )
		ret += r.dump();
	return ret.join("\n\n");
}

RecordList RecordList::copy( bool updateCopiedRelations )
{
	RecordList ret;
	foreach( Record r, (*this) )
		ret += r.copy();
	if( updateCopiedRelations ) {
		foreach( Record r, ret ) {
			TableSchema * ts = r.table()->schema();
			foreach( Field * field, ts->fields() ) {
				if( field->type() & Field::ForeignKey ) {
					Record fkey = r.foreignKey( field->pos() );
					if( fkey.isValid() ) {
						int pos = findIndex(fkey);
						if( pos >= 0 )
							r.setForeignKey( field->pos(), ret[pos] );
					}
				}
			}
		}
	}
	return ret;
}

ImpList RecordList::sEmptyList = ImpList();

RecordIter::RecordIter()
{
}

RecordIter::RecordIter( const ImpIter & it )
{
	mIter = it;
}

RecordIter::RecordIter( const RecordList & list, bool end )
{
	if( !list.d )
		mIter = RecordList::sEmptyList.begin();
	else if( end )
		mIter = list.d->mList.end();
	else
		mIter = list.d->mList.begin();
}

RecordImp* RecordIter::imp()
{
	return (RecordImp*)(*mIter);
}

Record RecordIter::operator*() const
{
	return Record( (RecordImp*)(*mIter), false );
}

void RecordIter::operator++()
{
	++mIter;
}

void RecordIter::operator--()
{
	--mIter;
}

RecordIter & RecordIter::operator=(const RecordIter & iter )
{
	mIter = iter.mIter;
	return *this;
}

RecordIter & RecordIter::operator=(const Record & r)
{
	r.imp()->ref();
	(*mIter)->deref();
	*mIter = r.imp();
	return *this;
}

bool RecordIter::operator==( const RecordIter & other )
{
	return mIter == other.mIter;
}

bool RecordIter::operator!=( const RecordIter & other )
{
	return mIter != other.mIter;
}
	
void RecordIter::make_valid( RecordList rl )
{
	if( mIter == RecordList::sEmptyList.begin() && rl.d )
		mIter = rl.d->mList.begin();
}

