
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
 * $Id: recordpropvalmodel.cpp 9390 2010-02-25 00:23:53Z brobison $
 */

#include "recordpropvalmodel.h"
#include "table.h"

class PropValItem : public ItemBase
{
public:
	int column;
	int row;
	RecordList mRecords;
	bool mIsFkey;
	mutable Record fkey;
	QString mPropName;

	PropValItem();

	void setup( int c, const RecordList & recs, int r=-1 );

	QVariant modelData( const QModelIndex & i, int role ) const;

	bool setModelData( const QModelIndex & i, const QVariant & v, int role );

	Qt::ItemFlags modelFlags( const QModelIndex & i );

	Record getRecord() { return Record(); }
};

typedef TemplateDataTranslator<PropValItem> RecordPropValTranslator;

PropValItem::PropValItem()
: column( 0 )
, row( -1 )
, mIsFkey( false )
{}

void PropValItem::setup( int c, const RecordList & recs, int r )
{
	column = c;
	row = r;
	mRecords = recs;
	if( mRecords.isEmpty() )
        return;

    TableSchema * s = mRecords[0].table()->schema();
    if( s ) {
        Field * f = s->field(column);
        if( f ) {
            mPropName = f->displayName();
            TableSchema * fkt = f->foreignKeyTable();
            mIsFkey = fkt && fkt->field( "name" );
        }
    }
}

QVariant PropValItem::modelData( const QModelIndex & i, int role ) const
{
	if( mRecords.isEmpty() ) return QVariant();

	if( i.column() == 0 && role == Qt::DisplayRole ) {
		return mPropName;
	} else if( i.column() == 1 ) {
		if( role == Qt::DisplayRole || role == Qt::EditRole ) {
			if( (row >= 0 && row < (int)mRecords.size()) || mRecords.size() == 1 ) {
				Record r = mRecords[row >= 0 ? row : 0];

                // for values that point that are foreign keys that point to
                // another table, get the value from that table
				if( mIsFkey && role == Qt::DisplayRole ) {
					fkey = r.foreignKey(column);
					return fkey.getValue( "name" );
				}
				return r.getValue( column );
			} else if( row == -1 ) {
				QVariantList vals;
				if( mIsFkey )
					vals = mRecords.foreignKey(column).getValue("name");
				else
					vals = mRecords.getValue(column);
				QStringList strings;
				foreach( QVariant v, vals ) {
					QString s = v.toString();
					if( !s.isEmpty() && !strings.contains(s) )
						strings += s;
				}
				return strings.join(",");
			}
		}
	}
	return QVariant();
}

bool PropValItem::setModelData( const QModelIndex & i, const QVariant & v, int role )
{
	int col = i.column();
	if( col == 0 ) return false;
	if( col == 1 ) {
		if( role == Qt::EditRole ) {
			if( row == -1 ) {
				mRecords.setValue( column, v );
				mRecords.commit();
				return true;
			} else if( row >= 0 && row < (int)mRecords.size() ) {
				Record r = mRecords[row];
				r.setValue( column, v );
				r.commit();
				return true;
			}
		}
	}
	return false;
}

Qt::ItemFlags PropValItem::modelFlags( const QModelIndex & i )
{
	switch( i.column() ) {
		case 0:
			return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled );
		case 1:
		{
			const RecordPropValModel * rpvm = qobject_cast<const RecordPropValModel*>(i.model());
			// Only allow editting if the model is allowed to edit, and it is a single value
			Qt::ItemFlag editable = (rpvm->mMultiEdit || row < 0) && rpvm && rpvm->mEditable ? Qt::ItemIsEditable : Qt::ItemFlag(0);
			return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled | editable );
		}
	}
	return Qt::ItemFlags();
}

class RecordPropValTreeBuilder : public ModelTreeBuilder
{
public:
	RecordPropValTreeBuilder( SuperModel * model );

	bool hasChildren( const QModelIndex & parentIndex, SuperModel * model );
	void loadChildren( const QModelIndex & parentIndex, SuperModel * model );

	RecordList mRecords;
};

RecordPropValTreeBuilder::RecordPropValTreeBuilder( SuperModel * model )
: ModelTreeBuilder( model )
{
	new RecordPropValTranslator(this);
}

bool RecordPropValTreeBuilder::hasChildren( const QModelIndex & parentIndex, SuperModel * model )
{
	Q_UNUSED(model);

	if( RecordPropValTranslator::isType(parentIndex) ) {
		PropValItem & pvi = RecordPropValTranslator::data(parentIndex);
		return pvi.mRecords.size() > 1 && pvi.row == -1;
	}
	return false;
}

void RecordPropValTreeBuilder::loadChildren( const QModelIndex & parentIndex, SuperModel * model )
{
	if( mRecords.isEmpty() ) return;

    // TableSchema holds the list of Properties we show in the left column
	TableSchema * ts = mRecords[0].table()->schema();
	if( !ts ) return;
	int fieldCount = ts->fieldCount();

	model->clearChildren(parentIndex);
	model->append(parentIndex, fieldCount);
	for( int row=0; row<fieldCount; row++ ) {
		QModelIndex idx = model->index(row,0,parentIndex);
		RecordPropValTranslator::data(idx).setup(row, mRecords);

/*
		if( mRecords.size() > 1 ) {
			model->append(idx, mRecords.size());
			for( int r=0; r < (int)mRecords.size(); r++ )
				RecordPropValTranslator::data(idx.child(r,0)).setup(row,mRecords,r);
		}
        */
	}
	return;
}

RecordPropValModel::RecordPropValModel( QObject * parent )
: SuperModel( parent )
, mEditable( false )
, mMultiEdit( false )
{
	setTreeBuilder( new RecordPropValTreeBuilder(this) );
	setHeaderLabels( QStringList() << "Property" << "Value" );
}

void RecordPropValModel::setRecords( const RecordList & rl )
{
	mRecords = rl;
	((RecordPropValTreeBuilder*)treeBuilder())->mRecords = rl;
	treeBuilder()->loadChildren( QModelIndex(), this );
}

RecordList RecordPropValModel::records() const
{
	return mRecords;
}

void RecordPropValModel::setEditable( bool editable )
{
	mEditable = editable;
}

bool RecordPropValModel::editable() const
{
	return mEditable;
}

void RecordPropValModel::setMultiEdit( bool m )
{
	mMultiEdit = m;
}

bool RecordPropValModel::multiEdit() const
{
	return mMultiEdit;
}

RecordList RecordPropValModel::foreignKeyRecords( const QModelIndex & index )
{
	if( RecordPropValTranslator::isType(index) ) {
		PropValItem * item = &RecordPropValTranslator::data(index);
		RecordList records = item->mRecords;
		if( item->row >= 0 && item->row < (int)records.size() )
			return records[item->row].foreignKey(item->column);
		return records.foreignKey(item->column);
	}
	return RecordList();
}

