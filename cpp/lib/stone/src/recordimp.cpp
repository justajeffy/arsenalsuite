
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

#include <stdio.h>
#include <assert.h>

#include <qsqlquery.h>

#include "blurqt.h"
#include "freezercore.h"
#include "index.h"
#include "interval.h"
#include "recordimp.h"
#include "table.h"
#include "tableschema.h"

namespace Stone {

static char * copyBitArray( char * ba, int size )
{
       if( !ba ) return 0;
       int stateSize = (size+7) / 8;
       char * ret = new char[stateSize];
       memcpy( ret, ba, stateSize );
       return ret;
}

static void clearBitArray( char * ba, int size )
{
       if( !ba ) return;
       int stateSize = (size+7) / 8;
       for( int i=0; i<stateSize; i++ )
               ba[i] = 0;
}

static char * newBitArray( int size )
{
       int stateSize = (size+7) / 8;
       char * ret = new char[stateSize];
       clearBitArray( ret, size );
       return ret;
}

static char * setBit( char * ba, int bit, bool value, int size )
{
       if( !ba )
               ba = newBitArray( size );
       int block = bit / 8;
       int shift = bit % 8;
       char c = ba[block];
       if( value )
               c = c | (1 << shift);
       else
               c = c ^ (1 << shift);
       ba[block] = c;
       return ba;
}

static void clearBit( char * ba, int bit )
{
       if( !ba ) return;
       ba[bit / 8] ^= 1 << (bit % 8);
}

static bool getBit( const char * ba, int bit )
{
       if( !ba ) return false;
       int block = bit / 8;
       int shift = bit % 8;
       char c = ba[block];
       return c & (1 << shift);
}

static int sRecordImpCount = 0;

// static
int RecordImp::totalCount()
{ return sRecordImpCount; }

RecordImp::RecordImp( Table * table, QVariant * toLoad )
: mState( 0 )
, mTable( table )
, mValues( 0 )
, mModifiedBits( 0 )
, mLiterals( 0 )
, mNotSelectedBits( 0 )
{
	sRecordImpCount++;
	if( table ) {
		table->mImpCount++;
		FieldList allFields = table->schema()->fields();
		int size = allFields.size();
		mValues = new VariantVector( size );
        if( toLoad ) {
            int i = 0;
            foreach( Field * f, allFields )
            (*mValues)[f->pos()] = f->coerce(toLoad[i++]);
			mState = COMMITTED;
		} else {
            foreach( Field * f, allFields )
                (*mValues)[f->pos()] = f->defaultValue();
			mState = NEWRECORD;
        }
//		printf( "NEW RecordImp %p Table: %s Key: %i Table Count: %i\n", this, qPrintable(mTable->tableName()), key(), mTable->mImpCount );
	}
}

RecordImp::RecordImp( Table * table, QSqlQuery & q, int queryPosOffset, FieldList * incomingFields )
: mState( 0 )
, mTable( table )
, mValues( 0 )
, mModifiedBits( 0 )
, mLiterals( 0 )
, mNotSelectedBits( 0 )
{
	sRecordImpCount++;
	if( table ) {
		table->mImpCount++;
		FieldList allFields = table->schema()->fields();
		int size = allFields.size();
		mValues = new VariantVector( size );
		int pos = queryPosOffset;
        foreach( Field * f, allFields ) {
            bool isIncoming = !f->flag(Field::LocalVariable) && ( (incomingFields && incomingFields->contains(f)) || !f->flag(Field::NoDefaultSelect) );
            if( isIncoming ) {
                if(f->flag(Field::Compress))
                    (*mValues)[f->pos()] = qCompress(f->coerce(q.value(pos++)).toString().toUtf8());
                else
                    (*mValues)[f->pos()] = f->coerce(q.value(pos++));
            } else {
                (*mValues)[f->pos()] = f->defaultValue();
                if( !f->flag(Field::LocalVariable) ) mNotSelectedBits = setBit( mNotSelectedBits, f->pos(), true, allFields.size() );
            }
        }
		mState = COMMITTED;
//		printf( "NEW RecordImp %p Table: %s Key: %i Table Count: %i\n", this, qPrintable(mTable->tableName()), key(), mTable->mImpCount );
	}
}

RecordImp::RecordImp( Table * table, QSqlQuery & q, int * queryColPos, FieldList * incomingFields )
: mState( 0 )
, mTable( table )
, mValues( 0 )
, mModifiedBits( 0 )
, mLiterals( 0 )
, mNotSelectedBits( 0 )
{
	sRecordImpCount++;
	if( table ) {
		table->mImpCount++;
		FieldList allFields = table->schema()->fields();
		int size = allFields.size();
		mValues = new VariantVector( size );
		int pos = 0;
        foreach( Field * f, allFields ) {
            bool isIncoming = !f->flag(Field::LocalVariable) && ( (incomingFields && incomingFields->contains(f)) || !f->flag(Field::NoDefaultSelect) );
            if( isIncoming ) {
                if(f->flag(Field::Compress))
                    (*mValues)[f->pos()] = qCompress(f->coerce(q.value(pos++)).toString().toUtf8());
                else
                    (*mValues)[f->pos()] = f->coerce(q.value(queryColPos[pos++]));
            } else {
                (*mValues)[f->pos()] = f->defaultValue();
                if( !f->flag(Field::LocalVariable) )
                    mNotSelectedBits = setBit( mNotSelectedBits, f->pos(), true, allFields.size() );
            }
        }
		mState = COMMITTED;
		//printf( "NEW RecordImp %p Table: %s Key: %i Table Count: %i\n", this, qPrintable(mTable->tableName()), key(), mTable->mImpCount );
	}
}

RecordImp::~RecordImp()
{
	sRecordImpCount--;
	if( mTable ) {
		mTable->mImpCount--;
		//printf( "DELETE RecordImp %p Table: %s Key: %i Table Count: %i\n", this, qPrintable(mTable->tableName()), key(), mTable->mImpCount );
	}
    mValues->clear();
	delete mValues;
	mValues = 0;
	delete [] mModifiedBits;
	mModifiedBits = 0;
	delete [] mLiterals;
	mLiterals = 0;
	delete [] mNotSelectedBits;
	mNotSelectedBits = 0;
	mTable = 0;
}


void RecordImp::ref()
{
	mRefCount.ref();
//	LOG_5("Record Ref: " + mTable->tableName() + " " + QString::number((uint)this) + " - " + QString::number( mRefCount ) );
}

void RecordImp::deref()
{
	bool neZero = mRefCount.deref();

	if( !neZero ) {
		if( mTable && mValues ) {
			uint myKey = key();
			Table * table = mTable;
			while( table ) {
				KeyIndex * ki = mTable->keyIndex();
				if( ki ) ki->expire( myKey, this );
				table = table->parent();
			}
		}
		delete this;
	}
}

void RecordImp::set( QVariant * v )
{
	if( !mTable ) return;
	int fc = mTable->schema()->fieldCount();
    for( int i=0; i<fc; i++ )
        (*mValues)[i] = v[i];
/*
	FieldList fields = mTable->schema()->fields();
	for( int i=0; i<fc; i++ ) {
        if(fields[i]->flag(Field::Compress))
            (*mValues)[i] = qCompress(v[i].toString().toUtf8());
        else
            (*mValues)[i] = v[i];
    }
*/
}

void RecordImp::get( QVariant * v )
{
	if( !mTable ) return;
	int fc = mTable->schema()->fieldCount();
	FieldList fields = mTable->schema()->fields();
	for( int i=0; i<fc; i++ ) {
        if(fields[i]->flag(Field::Compress))
            v[i] = QString::fromUtf8(qUncompress(mValues->at( i ).toByteArray()));
        else
            v[i] = mValues->at( i );
    }
}

QVariant RecordImp::getColumn( int col ) const
{
	if( !mTable || !mValues || col >= (int)mTable->schema()->fieldCount() || col < 0 )
		return QVariant();

    FieldList fields = mTable->schema()->fields();
    if(fields[col]->flag(Field::Compress))
        return QString::fromUtf8(qUncompress(mValues->at( col ).toByteArray()));
    else {
        if( getBit( mNotSelectedBits, col ) )
            mTable->selectFields( RecordList() += Record(const_cast<RecordImp*>(this)), FieldList() += mTable->schema()->field(col) );
        return mValues->at(col);
    }
}

QVariant RecordImp::getColumn( Field * f ) const
{
    if( !mTable || !mTable->schema()->fields().contains(f) )
        return QVariant();
    return getColumn( f->pos() );
}

RecordImp * RecordImp::setColumn( int col, const QVariant & v )
{
	FieldList fields = mTable->schema()->fields();
	if( !mTable || col >= (int)fields.size() || col < 0 ) {
		LOG_5( "RecordImp::setColumn: Column " + QString::number( col ) + " is out of range" );
		return this;
	}
	Field * f = fields[col];
	QVariant vnew(f->coerce(v));

    bool notSel = getBit( mNotSelectedBits, col );

    QVariant & vr = (*mValues)[col];
/*
    if(f->flag(Field::Compress)) {
        vnew = qCompress(vnew.toString().toUtf8());
    }
    //LOG_3( "RecordImp::setColumn: vnew value is " + vnew.toString() );

    QVariant & vr = (*mValues)[col];
    if(f->flag(Field::Compress)) {
        vr = qCompress(vr.toString().toUtf8());
    }
    //LOG_3( "RecordImp::setColumn: vr value is " + vr.toString() );
*/

    if( notSel || (vr.isNull() != vnew.isNull()) || (vr != vnew) ) {
		bool isVar = f->flag( Field::LocalVariable );

		if( (mState == EMPTY_SHARED) || (!isVar && (mState & COMMITTED) && !(mState & MODIFIED)) ) {
			RecordImp * ret = copy();
			ret->setColumn( col, v );
			ret->ref();
			deref();
			return ret;
		}
		vr = v;
		if( mState == NEWRECORD )
			mState = MODIFIED;
		if( !isVar )
			setColumnModified( col, true );
	}
//	LOG_5( "RecordImp::setColumn: Values are equal: " + QString( QVariant::typeToName( v.type() ) ) + ": " + v.toString() );
//	LOG_5( "RecordImp::setColumn: Values are equal: " + QString( QVariant::typeToName( vr.type() ) ) + ": " + vr.toString() );
	return this;
}

RecordImp * RecordImp::setColumn( Field * f, const QVariant & v )
{
    if( !mTable || !mTable->schema()->fields().contains(f) )
        return this;
    return setColumn( f->pos(), v );
}

void RecordImp::fillColumn( int col, const QVariant & v )
{
    FieldList fields = mTable->schema()->fields();
    if( !mTable || col >= (int)fields.size() || col < 0 ) {
        LOG_5( "RecordImp::fillColumn: Column " + QString::number( col ) + " is out of range" );
        return;
    }
    Field * f = fields[col];
    QVariant vnew(f->coerce(v));
    (*mValues)[col] = vnew;
    clearBit( mNotSelectedBits, col );
}

void RecordImp::setColumnModified( uint col, bool modified )
{
    if( !modified && !mModifiedBits )
        return;
    mModifiedBits = setBit( mModifiedBits, col, modified, mTable->schema()->fieldCount() );
}

bool RecordImp::isColumnModified( uint col ) const
{
    return getBit( mModifiedBits, col );
}

void RecordImp::clearModifiedBits()
{
    clearBitArray( mModifiedBits, mTable->schema()->fieldCount() );
}

RecordImp * RecordImp::setColumnLiteral( uint col, bool literal )
{
	if( !literal && !mLiterals )
		return this;
	if( (mState == EMPTY_SHARED) || ((mState & COMMITTED) && !(mState & MODIFIED)) ) {
		RecordImp * ret = copy();
		ret->setColumnLiteral( col, literal );
		ret->ref();
		deref();
		return ret;
	}
	if( mState == NEWRECORD )
		mState = MODIFIED;
	mLiterals = setBit( mLiterals, col, literal, mTable->schema()->fieldCount() );
	return this;
}

bool RecordImp::isColumnLiteral( uint col ) const
{
	return getBit( mLiterals, col );
}

void RecordImp::clearColumnLiterals()
{
	clearBitArray( mLiterals, mTable->schema()->fieldCount() );
}

QVariant RecordImp::getValue( const QString & column ) const
{
	return mTable ? getColumn( mTable->schema()->fieldPos( column ) ) : QVariant();
}

RecordImp * RecordImp::setValue( const QString & column, const QVariant & var )
{
	if( mTable )
		return setColumn( mTable->schema()->fieldPos( column ), var );
	LOG_5( "RecordImp::setValue: WTF? mTable is 0" );
	return this;
}

uint RecordImp::key() const
{
	return mTable ? getColumn( mTable->schema()->primaryKeyIndex() ).toUInt() : 0;
}

RecordImp * RecordImp::copy()
{
	RecordImp * t = new RecordImp( mTable, mValues ? mValues->data() : 0 );
	t->mState = (mState & COMMITTED) | MODIFIED;
	if( mTable ) {
		t->mModifiedBits = copyBitArray( mModifiedBits, mTable->schema()->fieldCount() );
		t->mLiterals = copyBitArray( mLiterals, mTable->schema()->fieldCount() );
	}
	return t;
}


class ThreadCommitter : public ThreadTask
{
public:
	ThreadCommitter(RecordImp * toCommit, bool npk)
	: ThreadTask()
	, mToCommit(toCommit)
	, mNewPrimaryKey(npk)
	{
		mToCommit->ref();
	}
	
	~ThreadCommitter()
	{ mToCommit->deref(); }

	void run()
	{
		mToCommit = mToCommit->commit(mNewPrimaryKey,true);
	}

	RecordImp * mToCommit;
	bool mNewPrimaryKey;
};

RecordImp * RecordImp::commit(bool newPrimaryKey,bool sync)
{
	if( !mTable )
		return this;

	if( mState == EMPTY_SHARED )
		return this;

	if( !sync ) {
		FreezerCore::addTask( new ThreadCommitter(this,newPrimaryKey) );
		if( mState == (COMMITTED|MODIFIED) ) {
			RecordImp * ret = mTable->record(key(),false/*select*/).mImp;
			if( ret ) {
				ret->ref();
				deref();
				return ret;
			}
		}
		return this;
	}

	if( mState == (COMMITTED|MODIFIED) ){
		mTable->update( this );
		RecordImp * ret = mTable->record(key(),false/*select*/).mImp;
		if( ret ) {
			ret->ref();
			deref();
			return ret;
		}
	// Don't automatically recommit a deleted record.
	// The user needs to either call copy, or manually
	// clear the DELETED flag.
	} else if( !(mState & COMMITTED) && !(mState & DELETED) ) {
		mTable->insert( Record(this,false), newPrimaryKey );
	}
	return this;
}

void RecordImp::remove()
{
	if( mTable )
		mTable->remove( Record(this,false) );
}

QString RecordImp::debugString()
{
	QString ret("Record Dump:  Table: ");
	if( table() )
		ret += table()->schema()->tableName();
	ret += " Key: " + QString::number( key() );
	ret += " State: " + QString::number( mState );
	char buffer[30];
	snprintf(buffer,30,"%p", this);
	ret += " Address: " + QString::fromAscii(buffer);
	return ret;
}

} //namespace

