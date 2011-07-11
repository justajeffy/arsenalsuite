
#include <qtimer.h>
#include <qregexp.h>

#include "blurqt.h"
#include "modelgrouper.h"
#include "supermodel.h"

ModelGrouper::ModelGrouper( SuperModel * model )
: QObject( model )
, mModel( model )
, mStandardTranslator( 0 )
, mCustomTranslator( 0 )
, mGroupColumn( 0 )
, mIsGrouped( false )
, mInsertingGroupItems( false )
{
	model->setGrouper(this);
	connect( model, SIGNAL( rowsInserted(const QModelIndex &, int, int) ), SLOT( slotRowsInserted( const QModelIndex &, int, int) ) );
	connect( model, SIGNAL( rowsRemoved(const QModelIndex &, int, int) ), SLOT( slotRowsRemoved( const QModelIndex &, int, int) ) );
	connect( model, SIGNAL( dataChanged(const QModelIndex &, const QModelIndex &) ), SLOT( slotDataChanged(const QModelIndex &, const QModelIndex &) ) );
}

void ModelGrouper::setColumnGroupRegex( int column, const QRegExp & regEx )
{
	if( regEx.isValid() )
		mColumnRegexMap[column] = regEx;
	else
		mColumnRegexMap.remove(column);
}

QRegExp ModelGrouper::columnGroupRegex( int column ) const
{
	ColumnRegexMap::const_iterator it = mColumnRegexMap.find( column );
	if( it == mColumnRegexMap.end() ) return QRegExp();
	return it.value();
}

ModelDataTranslator * ModelGrouper::groupedItemTranslator() const
{
	if( !mCustomTranslator && !mStandardTranslator ) {
		// I could make it mutable, but what fun would that be?
		ModelGrouper * me = const_cast<ModelGrouper*>(this);
		me->mStandardTranslator = new StandardTranslator(model()->treeBuilder());
	}
	return mCustomTranslator ? mCustomTranslator : mStandardTranslator;
}

void ModelGrouper::setGroupedItemTranslator( ModelDataTranslator * trans )
{
	if( trans == groupedItemTranslator() ) return;
	bool grouped = mIsGrouped;
	if( grouped )
		ungroup();
	// Because all ModelDataTranslators are owned by the treeBuilder(mTranslators list),
	// we don't have to do any memory management here
	mStandardTranslator = 0;
	mCustomTranslator = trans;
	if( grouped )
		groupByColumn(mGroupColumn);
}

void ModelGrouper::groupByColumn( int column ) {
	// Single level grouping for now
	if( mIsGrouped ) ungroup();
	
	mGroupColumn = column;
	int count = model()->rowCount();
	if( count > 0 )
		groupRowsByColumn( mGroupColumn, 0, count - 1 );
	
	mIsGrouped = true;
}

QModelIndexList fromPersist( QList<QPersistentModelIndex> persist)
{
	QModelIndexList ret;
	foreach( QModelIndex idx, persist ) ret.append(idx);
	return ret;
}

QString indexToStr( const QModelIndex & idx )
{ return QString("(%1,%2,%3)").arg(idx.row()).arg(idx.column()).arg((qulonglong)idx.internalPointer(),0,16); }

QString indexListToStr( QModelIndexList list )
{
	QStringList rows;
	foreach( QModelIndex idx, list ) rows += indexToStr(idx);
	return rows.join(",");
}

void ModelGrouper::groupRowsByColumn( int column, int start, int end )
{
	// First group the top level indexes by the desired column
	typedef QMap<QString,QList<QPersistentModelIndex> > GroupMap;
	GroupMap grouped;
	QModelIndexList topLevel;
	for( int i = start; i <= end; ++i ) {
		QModelIndex idx = model()->index( i, column );
		// Double check that this isn't a group item, even though it shouldn't be
		if( model()->translator(idx) != groupedItemTranslator() ) {
			topLevel += idx;
			QRegExp regEx = columnGroupRegex(column);
			QString strValue = model()->data( idx, Qt::DisplayRole ).toString();
			if( !regEx.isEmpty() && regEx.isValid() && strValue.contains(regEx) )
				strValue = regEx.cap(regEx.captureCount() > 1 ? 1 : 0);
			grouped[strValue] += idx;
			LOG_5( QString("Index %1 grouped with value %2").arg(indexToStr(idx)).arg(strValue) );
		}
	}
		
	QList<QPersistentModelIndex> persistentGroupIndexes;
	
	// If we are already grouped, we need to insert items into existing groups before creating new ones
	if( mIsGrouped ) {
		// Get persistent indexes for each group item, because regular ones may be invalidated by 
		// the move call in the loop
		for( ModelIter it(model()); it.isValid(); ++it )
			persistentGroupIndexes.append( *it );
		foreach( QPersistentModelIndex idx, persistentGroupIndexes ) {
			if( model()->translator(idx) == groupedItemTranslator() ) {
				QString groupVal = idx.sibling( idx.row(), column ).data( Qt::DisplayRole ).toString();
				GroupMap::Iterator mapIt = grouped.find( groupVal );
				if( mapIt != grouped.end() ) {
					QModelIndexList toMove(fromPersist(mapIt.value()));
					LOG_5( QString("Moving indexes %1 to existing group item at index %2").arg(indexListToStr(toMove)).arg(indexToStr(idx)) );
					model()->move( toMove, idx );
					// Tell the group item to update itself based on the added children
					model()->setData( idx, QVariant(), GroupingUpdate );
					grouped.erase( mapIt );
				}
			}
		}
		persistentGroupIndexes.clear();
	}
	
	if( grouped.size() ) {
		// Append the group items, yet to be filled with data and have the children copied
		{
			mInsertingGroupItems = true;
			QModelIndexList groupIndexes = model()->insert( QModelIndex(), model()->rowCount(), grouped.size(), groupedItemTranslator() );
			LOG_5( QString("Created %1 new group items at indexes %2").arg(grouped.size()).arg(indexListToStr(groupIndexes)) );
			mInsertingGroupItems = false;
			foreach( QModelIndex idx, groupIndexes ) persistentGroupIndexes.append(idx);
		}
		
		// Set the group column data, and copy the children
		int i = 0;
		for( QMap<QString, QList<QPersistentModelIndex> >::Iterator it = grouped.begin(); it != grouped.end(); ++it, ++i ) {
			QModelIndex groupIndex = persistentGroupIndexes[i];
			QModelIndexList toMove(fromPersist(it.value()));
			LOG_5( QString("Moving indexes %1 to existing group item at index %2").arg(indexListToStr(toMove)).arg(indexToStr(groupIndex)) );
			model()->move( toMove, groupIndex );
		}
		
		i = 0;
		for( QMap<QString, QList<QPersistentModelIndex> >::Iterator it = grouped.begin(); it != grouped.end(); ++it, ++i ) {
			QModelIndex groupIndex = persistentGroupIndexes[i];
			if( mStandardTranslator )
				mStandardTranslator->data(groupIndex).setModelData( groupIndex.sibling(groupIndex.row(), column), QVariant( it.key() ), Qt::DisplayRole );
			if( mCustomTranslator ) {
				model()->setData( groupIndex, QVariant(column), GroupingColumn );
				model()->setData( groupIndex, QVariant(it.key()), GroupingValue );
				model()->setData( groupIndex, QVariant(), GroupingUpdate );
			}
		}
	}
}

void ModelGrouper::ungroup()
{
	// If we disable auto sort, we can ensure that the group indexes wont change
	// because the new indexes will be appended
	bool autoSort = model()->autoSort();
	model()->setAutoSort( false );

	// Clear this here so that when we start moving the items back to root level
	// the slotRowsInserted doesn't try to regroup them
	mIsGrouped = false;
	
	// Collect a list the top level(group) items, and the second level items
	QModelIndexList topLevel;
	QModelIndexList children;
	for( ModelIter it(model()); it.isValid(); ++it ) {
		if( model()->translator(*it) == groupedItemTranslator() ) {
			topLevel += *it;
			children += ModelIter::collect( (*it).child(0,0) );
		}
	}
	// Copy the second level items to root level
	model()->move( children, QModelIndex() );
	
	// Remove the group items
	model()->remove( topLevel );

	if( autoSort ) {
		model()->setAutoSort( true );
		model()->resort();
	}

	mGroupColumn = 0;
}

void ModelGrouper::slotRowsInserted( const QModelIndex & parent, int start, int end )
{
	// Move any new rows into their proper groups
	if( mIsGrouped && !parent.isValid() && !mInsertingGroupItems )
		groupRowsByColumn( mGroupColumn, start, end );
}

void ModelGrouper::slotRowsRemoved( const QModelIndex & parent, int, int )
{
	if( mIsGrouped && parent.isValid() && model()->translator(parent) == groupedItemTranslator() ) {
		if( model()->rowCount(parent) == 0 )
			model()->remove( parent );
		else
			scheduleUpdate( parent );
	}
}

void ModelGrouper::slotDataChanged( const QModelIndex & topLeft, const QModelIndex & )
{
	QModelIndex parent = topLeft.parent();
	if( mIsGrouped && parent.isValid() && model()->translator(parent) == groupedItemTranslator() )
		scheduleUpdate(parent);
}

void ModelGrouper::slotUpdateGroupItems()
{
	foreach( QModelIndex i, mGroupItemsToUpdate )
		if( i.isValid() )
			model()->setData( i, QVariant(), GroupingUpdate );
	mUpdateScheduled = false;
	mGroupItemsToUpdate.clear();
}

void ModelGrouper::scheduleUpdate( const QModelIndex & toUpdate )
{
	if( !mGroupItemsToUpdate.contains( toUpdate ) )
		mGroupItemsToUpdate += toUpdate;
	if( !mUpdateScheduled ) {
		mUpdateScheduled = true;
		QTimer::singleShot( 0, this, SLOT( slotUpdateGroupItems() ) );
	}
}
