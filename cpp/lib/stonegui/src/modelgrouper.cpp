
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
, mUpdateScheduled( false )
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
		groupRows( 0, count - 1 );
	
	mIsGrouped = true;
	emit grouped();
	emit groupingChanged( true );
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

QString ModelGrouper::groupValue( const QModelIndex & idx )
{
	QRegExp regEx = columnGroupRegex(mGroupColumn);
	QString strValue = model()->data( idx.column() == mGroupColumn ? idx : idx.sibling(idx.row(),mGroupColumn), Qt::DisplayRole ).toString();
	if( !regEx.isEmpty() && regEx.isValid() && strValue.contains(regEx) )
		strValue = regEx.cap(regEx.captureCount() > 1 ? 1 : 0);
	LOG_5( QString("Index %1 grouped with value %2").arg(indexToStr(idx)).arg(strValue) );
	return strValue;
}

void ModelGrouper::groupRows( int start, int end )
{
	// First group the top level indexes by the desired column
	GroupMap grouped;
	for( int i = start; i <= end; ++i ) {
		QModelIndex idx = model()->index( i, mGroupColumn );
		// Double check that this isn't a group item, even though it shouldn't be
		if( model()->translator(idx) != groupedItemTranslator() ) {
			grouped[groupValue(idx)] += idx;
		}
	}
	group( grouped );
}
	
void ModelGrouper::group( GroupMap & grouped )
{
	QList<QPersistentModelIndex> persistentGroupIndexes;
	
	// If we are already grouped, we need to insert items into existing groups before creating new ones
	if( mIsGrouped ) {
		// Get persistent indexes for each group item, because regular ones may be invalidated by 
		// the move call in the loop
		for( ModelIter it(model()); it.isValid(); ++it )
			persistentGroupIndexes.append( *it );
		foreach( QPersistentModelIndex idx, persistentGroupIndexes ) {
			if( model()->translator(idx) == groupedItemTranslator() ) {
				QString groupVal = idx.sibling( idx.row(), mGroupColumn ).data( Qt::DisplayRole ).toString();
				GroupMap::Iterator mapIt = grouped.find( groupVal );
				if( mapIt != grouped.end() ) {
					QModelIndexList toMove(fromPersist(mapIt.value()));
					LOG_5( QString("Moving indexes %1 to existing group item at index %2").arg(indexListToStr(toMove)).arg(indexToStr(idx)) );
					model()->move( toMove, idx );
					if( mUpdateScheduled ) {
						if( !mGroupItemsToUpdate.contains( idx ) )
							mGroupItemsToUpdate.append(idx);
					} else
						// Tell the group item to update itself based on the added children
						model()->setData( idx, QVariant(), GroupingUpdate );
					grouped.erase( mapIt );
				}
			}
		}
		// Remove any now-empty groups
		for( QList<QPersistentModelIndex>::Iterator it = persistentGroupIndexes.begin(); it != persistentGroupIndexes.end(); )
			if( model()->translator(*it) == groupedItemTranslator() && model()->rowCount(*it) == 0 )
				++it;
			else
				it = persistentGroupIndexes.erase( it );
		model()->remove( fromPersist( persistentGroupIndexes ) );
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
				mStandardTranslator->data(groupIndex).setModelData( groupIndex.sibling(groupIndex.row(), mGroupColumn), QVariant( it.key() ), Qt::DisplayRole );
			if( mCustomTranslator ) {
				model()->setData( groupIndex, QVariant(mGroupColumn), GroupingColumn );
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
	emit ungrouped();
	emit groupingChanged( false );
}

void ModelGrouper::slotRowsInserted( const QModelIndex & parent, int start, int end )
{
	// Move any new rows into their proper groups
	if( mIsGrouped && !parent.isValid() && !mInsertingGroupItems )
		groupRows( start, end );
}

void ModelGrouper::slotRowsRemoved( const QModelIndex & parent, int, int )
{
	if( mIsGrouped && parent.isValid() && model()->translator(parent) == groupedItemTranslator() ) {
		if( model()->rowCount(parent) == 0 )
			model()->remove( parent );
		else {
			if( !mGroupItemsToUpdate.contains( parent ) )
				mGroupItemsToUpdate += parent;
			scheduleUpdate();
		}
	}
}

void ModelGrouper::slotDataChanged( const QModelIndex & topLeft, const QModelIndex & bottomRight )
{
	LOG_5( "topLeft " + indexToStr(topLeft) + " bottomRight " + indexToStr(bottomRight) );
	QModelIndex parent = topLeft.parent();
	if( mIsGrouped && parent.isValid() && model()->translator(parent) == groupedItemTranslator() ) {
		if( !mGroupItemsToUpdate.contains( parent ) )
			mGroupItemsToUpdate += parent;
		scheduleUpdate();
		if( topLeft.column() <= mGroupColumn && bottomRight.column() >= mGroupColumn ) {
			QString parGroupValue = parent.sibling( parent.row(), mGroupColumn ).data( Qt::DisplayRole ).toString();
			QModelIndex it = topLeft, end = bottomRight;
			QList<QPersistentModelIndex> changed;
			while( it.isValid() && it.row() <= end.row() ) {
				if( groupValue(it) != parGroupValue ) {
					QPersistentModelIndex pit(it);
					if( !mItemsToRegroup.contains(pit) )
						mItemsToRegroup += pit;
				}
				it = it.sibling( it.row() + 1, it.column() );
			}
			// Somewhat inefficient way to regroup, put them toplevel then the slotRowsInserted trigger will
			// move them. Need to rearrange groupRowsByColumn to avoid this.
			if( mItemsToRegroup.size() )
				scheduleUpdate();
		}
	}
}

void ModelGrouper::slotUpdate()
{
	if( mItemsToRegroup.size() ) {
		// First group the top level indexes by the desired column
		GroupMap grouped;
		foreach( QModelIndex idx, mItemsToRegroup ) {
			// Double check that this isn't a group item, even though it shouldn't be
			if( model()->translator(idx) != groupedItemTranslator() )
				grouped[groupValue(idx)] += idx;
		}
		group( grouped );
		mItemsToRegroup.clear();
	}

	if( mGroupItemsToUpdate.size() ) {
		foreach( QModelIndex i, mGroupItemsToUpdate )
			if( i.isValid() )
				model()->setData( i, QVariant(), GroupingUpdate );
		mGroupItemsToUpdate.clear();
	}
	
	mUpdateScheduled = false;
}

void ModelGrouper::scheduleUpdate()
{
	if( !mUpdateScheduled ) {
		mUpdateScheduled = true;
		QTimer::singleShot( 0, this, SLOT( slotUpdate() ) );
	}
}
