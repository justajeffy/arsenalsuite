
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
 * $Id: index.h 8504 2009-06-24 07:54:11Z brobison $
 */

#ifndef INDEX_H
#define INDEX_H

#include <qlist.h>
#include <qvariant.h>
#include <qmutex.h>
#include <qhash.h>

#include "field.h"
#include "indexschema.h"
#include "record.h"

class RecordList;
class Record;

typedef QHash<QVariant, void*> VarHash;
typedef QHash<QVariant, void*>::iterator VarHashIter;

namespace Stone {
class RecordImp;
class Table;

/**
 * \ingroup Stone
 * @{
 */
class STONE_EXPORT Index
{
public:
	Index( Table * table, IndexSchema * schema, bool useCache = false );
	virtual ~Index();

	enum {
		NoInfo,
		RecordsFound
	};
	IndexSchema * schema() const { return mSchema; }
	Table * table() const { return mTable; }

	// Setting this to false will clear all cached values
	void setCacheEnabled( bool cacheEnabled );
	bool cacheEnabled() const;

	// Set whether this index should be caching incoming values
	void cacheIncoming( bool ci ) { mCacheIncoming = ci; }

	// This returns results for multiple index entries at once.
	// The size of args must be a multiple of the number of columns
	// used in this index.
	RecordList recordsByIndexMulti( const QList<QVariant> & args );

	// Returns the records in the index that match args, will select
	// from database if the records dont exist in the index
	RecordList recordsByIndex( const QList<QVariant> & args );
	RecordList recordsByIndex( const QVariant & arg );
	RecordList recordsByIndex( const QVariant & arg1, const QVariant & arg2 );
	RecordList recordsByIndex( const QVariant & arg1, const QVariant & arg2, const QVariant & arg3 );

	Record recordByIndex( const QVariant & arg );
	Record recordByIndex( const QVariant & arg1, const QVariant & arg2 );
	Record recordByIndex( const QVariant & arg1, const QVariant & arg2, const QVariant & arg3 );

	virtual RecordList records( QList<QVariant> vars, int & status )=0;
	virtual void setEmptyEntry( QList<QVariant> vars )=0;

	virtual void recordAdded( const Record & )=0;
	virtual void recordRemoved( const Record & )=0;
	virtual void recordUpdated( const Record &, const Record & )=0;
	virtual void recordsIncoming( const RecordList &, bool ci = false )=0;
	virtual void clear()=0;
	void printStats();

protected:
	IndexSchema * mSchema;
	Table * mTable;
	bool mCacheIncoming, mUseCache;
private:
	Index(const Index &) {}

public:
	uint mTime;
	QMutex mMutex;
};

class STONE_EXPORT HashIndex : public Index
{
public:
	HashIndex( Table * parent, IndexSchema * );
	~HashIndex();

	virtual RecordList records( QList<QVariant> vars, int & status );
	virtual void setEmptyEntry( QList<QVariant> vars );

	virtual void recordAdded( const Record & );
	virtual void recordRemoved( const Record & );
	virtual void recordUpdated( const Record &, const Record & );
	virtual void recordsIncoming( const RecordList &, bool ci = false );
	virtual void clear();

protected:

	void recordIncomingNode( VarHash *, int fieldIndex , RecordImp * );
	void recordRemovedNode( VarHash * node, int fieldIndex, RecordImp * record, RecordImp * vals );
	void clearNode( VarHash * node, int fieldIndex );

	VarHash* mRoot;
	int mHashSize;
};

class STONE_EXPORT KeyIndex : public Index
{
public:
	KeyIndex( Table * parent, IndexSchema * schema );
	virtual ~KeyIndex();

	Record record( uint key, bool * foundEntry );

	virtual RecordList records( QList<QVariant> vars, int & status );
	virtual void setEmptyEntry( QList<QVariant> vars );
	
	virtual void recordAdded( const Record & );
	virtual void recordRemoved( const Record & );
	virtual void recordUpdated( const Record &, const Record & );
	virtual void recordsIncoming( const RecordList &, bool ci = false );
	virtual void clear();
	void expire( uint recordKey, RecordImp * imp );

	RecordList values();
	
protected:

	QHash<uint, RecordImp*> mDict;
	uint mPrimaryKeyColumn;
};

} //namespace

typedef QList<Index*> IndexList;
typedef QList<Index*>::Iterator IndexIter;

/// @}

#endif // INDEX_H

