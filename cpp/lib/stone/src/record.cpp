
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

#include "connection.h"
#include "database.h"
#include "interval.h"
#include "record.h"
#include "recordimp.h"
#include "table.h"
#include "tableschema.h"

static int sRecordCount = 0;

static QVariant sNullVariant;

namespace Stone {

// static
int Record::totalRecordCount()
{ return sRecordCount; }

int Record::totalRecordImpCount()
{ return RecordImp::totalCount(); }

Record::Record( RecordImp * imp, bool )
: mImp( imp )
{
	sRecordCount++;
	if( mImp )
		mImp->ref();
}

Record::Record( Table * table )
: mImp( 0 )
{
	sRecordCount++;
	if( table ) {
		mImp = table->mEmptyImp;
		mImp->ref();
	}
}

Record::Record( const Record & r )
: mImp( r.mImp )
{
	sRecordCount++;
	if( mImp )
		mImp->ref();
}

Record::~Record()
{
	sRecordCount--;
	if( mImp )
		mImp->deref();
}

Record & Record::operator=( const Record & r )
{
	if( mImp != r.mImp ) {
		if( mImp ) mImp->deref();
		mImp = r.mImp;
		if( mImp ) mImp->ref();
	}
	return *this;
}

bool isChanged( const QString & a, const QString & b )
{
	bool ai = a.isNull() || a.isEmpty();
	bool bi = b.isNull() || b.isEmpty();
	if( ai && bi )
		return false;
	return (a!=b);
}

bool Record::operator==( const Record & other ) const
{
	return mImp==other.mImp ||
		(
			(mImp && other.mImp)
			&& (mImp->mTable && mImp->key() && mImp->mTable == other.mImp->mTable && mImp->key() == other.mImp->key())
		);
}

bool Record::operator!=( const Record & other ) const
{
	return !operator==(other);
}

bool Record::operator <( const Record & other ) const
{
	if( operator==(other) ) return false;
	if( mImp && other.mImp ) {
		if( mImp->mTable == other.mImp->mTable )
			return mImp->key() < other.mImp->key();
		return mImp->mTable < other.mImp->mTable;
	}
	return mImp < other.mImp;
}

bool Record::isRecord() const
{
	return (mImp && (mImp->mState & RecordImp::COMMITTED) && mImp->key());
}

uint Record::generateKey() const
{
	if( !mImp ) return 0;
	uint k = mImp->key();
	if( !k ) {
		Table * t = table();
		if( t ) {
			k = t->connection()->newPrimaryKey( t->schema() );
			mImp = mImp->setColumn( t->schema()->primaryKeyIndex(), k );
		}
	}
	return k;
}

const QVariant & Record::getValue( const QString & column ) const
{
	const QVariant & ret( mImp ? mImp->getValue( column ) : sNullVariant );
	if( ret.userType() == qMetaTypeId<Record>() ) {
		// We have to call getValue so we can return a const QVariant & of the key
		Record r = qvariant_cast<Record>(ret);
		Table * t = r.table();
		return t ? r.getValue(t->schema()->primaryKeyIndex()) : sNullVariant;
	}
	return ret;
}

Record & Record::setValue( const QString & column, const QVariant & value )
{
	if( !mImp ) return *this;
	if( value.userType() == qMetaTypeId<Record>() ) {
		setForeignKey( column, qvariant_cast<Record>(value) );
		return * this;
	}
	mImp = mImp->setValue( column, value );
	return *this;
}

const QVariant & Record::getValue( int column ) const
{
	return mImp ? mImp->getColumn( column ) : sNullVariant;
}

const QVariant & Record::getValue( Field * f ) const
{
	return mImp ? mImp->getColumn( f ) : sNullVariant;
}

Record & Record::setValue( int column, const QVariant & value )
{
	if( mImp )
		mImp = mImp->setColumn( column, value );
	return *this;
}

Record & Record::setValue( Field * f, const QVariant & value )
{
	if( mImp )
		mImp = mImp->setColumn( f, value );
	return *this;
}

Record Record::foreignKey( const QString & column ) const
{
	do {
		Table * t = table();
		if( !t ) break;
		Field * f = t->schema()->field( column );
		if( !f ) break;
		return foreignKey( f );
	} while( 0 );
	return Record();
}

Record Record::foreignKey( int column ) const
{
	do {
		Table * t = table();
		if( !t ) break;
		Field * f = t->schema()->field( column );
		if( !f ) break;
		return foreignKey( f );
	} while( 0 );
	return Record();
}

Record Record::foreignKey( Field * f ) const
{
	if( !f->flag( Field::ForeignKey ) || !mImp ) return Record();
	QVariant val = mImp->getColumn( f );
	Table * t = table();
	Table * fkt = t->database()->tableFromSchema( f->foreignKeyTable() );
	if( !fkt ) return Record();
	if( val.canConvert( QVariant::LongLong ) ) {
		qlonglong ll = val.toLongLong();
		return fkt->record( ll );
	}
	if( val.userType() == qMetaTypeId<Record>() ) {
		Record r = qvariant_cast<Record>(val);
		return r;
	}
	return Record();
}

Record & Record::setForeignKey( int column, const Record & other )
{
	Table * t = table();
	if( !t ) return *this;
	Field * f = t->schema()->field( column );
	if( !f ) return *this;
	if( f->type() == Field::UInt || f->type() == Field::ULongLong || f->type() == Field::Int ) {
		setValue( f, other.key() ? other.key() : qVariantFromValue<Record>(other) );
	}
	return *this;
}

Record & Record::setForeignKey( const QString & column, const Record & other )
{
	Table * t = table();
	if( !t ) return *this;
	Field * f = t->schema()->field( column );
	if( !f ) return *this;
	if( f->type() == Field::UInt || f->type() == Field::ULongLong || f->type() == Field::Int ) {
		setValue( f, other.key() ? other.key() : qVariantFromValue<Record>(other) );
	}
	return *this;
}

Record & Record::setForeignKey( Field * f, const Record & other )
{
	if( f->type() == Field::UInt || f->type() == Field::ULongLong || f->type() == Field::Int ) {
		setValue( f, other.key() ? other.key() : qVariantFromValue<Record>(other) );
	}
	return *this;
}

Record & Record::setColumnLiteral( const QString & column, const QString & literal )
{
	if( !mImp ) return *this;
	Table * t = mImp->table();
	if( t ) {
		int fp = t->schema()->fieldPos( column );
		mImp = mImp->setColumnLiteral( fp, true );
		mImp->setColumn( fp, QVariant( literal ) );
	}
	return *this;
}

QString Record::columnLiteral( const QString & column ) const
{
	if( mImp ) {
		Table * t = mImp->table();
		if( t ) {
			int fp = t->schema()->fieldPos( column );
			if( mImp->isColumnLiteral( fp ) )
				return mImp->getColumn( fp ).toString();
		}
	}
	return QString::null;
}

QString Record::stateString() const
{
	QStringList ret;
	if( mImp ) {
		if( mImp->mState & RecordImp::NEWRECORD )
			ret += "New Record";
		if( mImp->mState & RecordImp::COMMITTED )
			ret += "Committed";
		if( mImp->mState & RecordImp::MODIFIED )
			ret += "Modified";
		if( mImp->mState & RecordImp::DELETED )
			ret += "Deleted";
		if( mImp->mState & RecordImp::EMPTY_SHARED )
			ret += "Empty/Shared";
		if( mImp->mState & RecordImp::COMMIT_ALL_FIELDS )
			ret += "Commit All Fields";
	}
	return ret.join(" ");
}

	
QString Record::displayName() const
{
	Table * t = table();
	if( t ) {
		TableSchema * ts = t->schema();
		Field * field = 0;
		foreach( Field * f, ts->fields() )
			if( f->flag( Field::DisplayName ) ) {
				field = f;
				break;
			}
		if( !field ) field = ts->field("name",true);
		if( !field ) field = ts->field("displayname",true);
		if( !field ) field = ts->field(ts->className(),true);
		if( !field ) field = ts->field(ts->tableName(),true);
		
		if( field ) return getValue( field->pos() ).toString();
	}
	return QString();
}

static QString tabAlign( const QStringList & keylist, const QStringList & valueList, int tabSize = 8 )
{
	int max_w = 0;
	foreach( QString s, keylist )
		max_w = qMax( s.size(), max_w );
	max_w = qMin( tabSize * 6, max_w + tabSize - 1 );
	max_w /= tabSize;
	QStringList ret;
	QString tab("\t\t\t\t\t\t");
	for( int i = 0; i < qMin(keylist.size(),valueList.size()); i++ ) {
		QString k = keylist[i];
		k += tab.left( qMax(0,max_w - k.size() / tabSize) );
		ret << (k + ": " + valueList[i]);
	}
	return ret.join("\n");
}

QString Record::dump() const
{
	Table * t = table();
	QStringList keys, values;
	keys << (t ? t->tableName() : QString("Invalid Record")) + " @ 0x" + QString::number((quint64)mImp,16);
	values << stateString();
	if( t ) {
		QStringList fieldNames = t->schema()->fieldNames();
		fieldNames.sort();
		foreach( QString fieldName, fieldNames ) {
			Field * f = t->schema()->field(fieldName);
			QVariant v = imp()->isColumnSelected(f->pos()) ? getValue(f->pos()) : "NOT SELECTED";
			keys << f->name();
			if( f->type() == Field::Interval )
				values << v.value<Interval>().toString();
			else if( v.userType() == qMetaTypeId<Record>() && f->flag( Field::ForeignKey ) ) {
				Record r = v.value<Record>();
				if( r.isRecord() )
					values << QString::number(r.key());
				else
					values << "<Uncommitted " + r.table()->schema()->className() + " @ 0x" + QString::number((quint64)r.mImp,16) + ">";
			} else
				values << v.toString();
		}
	}
	return tabAlign(keys,values);
}

QString Record::changeString() const
{
	QString changeString;
	Record orig;
	if( mImp ) {
		Table * t = table();
		QStringList fieldNames = t->schema()->fieldNames();
		fieldNames.sort();
		foreach( QString fieldName, fieldNames ) {
			Field * f = t->schema()->field(fieldName);
			if( mImp->isColumnModified(f->pos()) ) {
				if( !orig.isRecord() ) {
					orig = t->record( key() );
					if( !orig.isRecord() ) break;
				}
				if( !changeString.isEmpty() )
					changeString += "\n";
                if( f->dbPrepare(orig.getValue(f->pos())).toString() != f->dbPrepare(getValue(f->pos())).toString() ) {
                    QString newString = f->dbPrepare(getValue(f->pos())).toString();
                    if( newString.size() > 1024 ) {
                        newString.truncate(1024);
                        newString += "...";
                    }
                    changeString += fieldName + " changed: " + f->dbPrepare(orig.getValue(f->pos())).toString() + "  to  " + newString;
                }
			}
		}
	}
	return changeString;
}

bool Record::isUpdated() const
{
	return (mImp && (mImp->mState & RecordImp::MODIFIED));
}

void Record::selectFields( FieldList fields, bool refreshExisting )
{
	if( isRecord() ) {
		if( !refreshExisting ) {
			if( fields.size() )
				fields = fields & mImp->notSelectedColumns();
			else
				fields = mImp->notSelectedColumns();
		}
		if( fields.size() )
			table()->selectFields( RecordList(*this), fields );
	}
}

Record & Record::reload( bool lockForUpdate )
{
	if( isRecord() ) {
		Record r;
		if( lockForUpdate ) {
			// isRecord() check above guarantees table() and schema() are valid pointers
			RecordList rl = table()->select( table()->schema()->primaryKey() + "=? FOR UPDATE", VarList() << key(), false, true );
			if( rl.size() == 1 )
				r = rl[0];
		} else
			r = imp()->table()->record( mImp->key(), true, false, true );
		if( r.imp() != imp() ) {
			mImp->deref();
			mImp = r.imp();
			if( mImp )
				mImp->ref();
		}
	}
	return *this;
}

int Record::remove()
{
	if( isValid() )
		return table()->remove( *this );
	return 0;
}

Record & Record::commit( bool sync )
{
	if( isValid() )
		mImp = mImp->commit(key()==0,sync);
	return *this;
}

Record Record::copy() const
{
	if( mImp && mImp->table() ) {
		RecordImp * imp = mImp->copy();
		// Make this a record with no primary key or COMMITTED flag
		imp->mState = RecordImp::MODIFIED;
		imp->setColumn( imp->table()->schema()->primaryKeyIndex(), QVariant( 0 ) );
		for( int i=mImp->table()->schema()->fieldCount()-1; i >= 0; i-- )
			imp->setColumnModified( i, true );
		return Record( imp, false );
	} else return Record();
}

void Record::checkImpType(TableSchema * ts)
{
	// Check against table, not schema, to make sure they belong to the same database
	if( mImp && (!mImp->table() || !mImp->table()->schema() || !ts->isDescendant( mImp->table()->schema() ) ) ) {
		mImp->deref();
		mImp = 0;
	}
	
	if( !mImp ) {
		mImp = ts->table()->mEmptyImp;
		mImp->ref();
	}
}

} // namespace

