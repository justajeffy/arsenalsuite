
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
 * $Id: recordtreeview.cpp 9071 2009-11-24 00:57:41Z brobison $
 */

#include <qapplication.h>
#include <qevent.h>
#include <qheaderview.h>
#include <qmenu.h>
#include <QPlastiqueStyle>
#include <qpainter.h>
#include <qtimer.h>

#include "iniconfig.h"

#include "recordtreeview.h"
#include "modeliter.h"
#include "supermodel.h"

int ExtTreeView::State_ShowGrid = 0x10000000;

ExtTreeView::ExtTreeView( QWidget * parent, ExtDelegate * delegate )
: QTreeView( parent )
, mDelegate( delegate )
, mColumnAutoResize( false )
, mShowBranches( true )
, mShowGrid( false )
, mAutoResizeScheduled( false )
{
	header()->setClickable( true );
	header()->setSortIndicatorShown( true );

	setContextMenuPolicy( Qt::CustomContextMenu );
	connect( this, SIGNAL( customContextMenuRequested( const QPoint & ) ), SLOT( slotCustomContextMenuRequested( const QPoint & ) ) );

	setSelectionMode( QAbstractItemView::ExtendedSelection );

#if QT_VERSION >= 0x040200
	setSortingEnabled( true );
#endif

	// QT4.1 specific stuff, leave out for now.
	//setAutoFillBackground( false );
	//viewport()->setAutoFillBackground( false );
	//setAttribute( Qt::WA_OpaquePaintEvent, true );
	//viewport()->setAttribute( Qt::WA_OpaquePaintEvent, true );

#if QT_VERSION <= 0x040202
//	setAttribute( Qt::WA_NoSystemBackground, true );
//	viewport()->setAttribute( Qt::WA_NoSystemBackground, true );
#endif
	setFrameStyle( QFrame::NoFrame );
	setRootIsDecorated( false );
	setAlternatingRowColors( true );
	
	if( !mDelegate )
		mDelegate = new ExtDelegate(this);
	setItemDelegate(mDelegate);
}

bool ExtTreeView::eventFilter( QObject * object, QEvent * event )
{
	bool headerChild = false;
	QObject * ob = object;
	while( ob ) {
		if( ob == header() ) {
			headerChild = true;
			break;
		}
		ob = ob->parent();
	}

	if( headerChild )
	{
		switch ( event->type() ) {
			case QEvent::ChildAdded:
			case QEvent::ChildPolished:
			{
				QChildEvent * ce = (QChildEvent*)event;
				ce->child()->installEventFilter(this);
				break;
			}
			default: break;
		}
	}

	if( headerChild && (event->type() == QEvent::MouseButtonPress || event->type() == QEvent::MouseButtonRelease) )
	{
		QMouseEvent * mouseEvent = (QMouseEvent*)event;
		if( mouseEvent->button() == Qt::RightButton && event->type() == QEvent::MouseButtonPress ) {
			showHeaderMenu( ((QMouseEvent*)event)->globalPos() );
			return true;
		}
		// Control-click on a header column moves it to the second place in the sort order list
		// Eat the press event to keep the QHeaderView from starting a move operation
		if( mouseEvent->button() == Qt::LeftButton && event->type() == QEvent::MouseButtonPress && (mouseEvent->modifiers() & Qt::ControlModifier) )
			return true;
		if( mouseEvent->button() == Qt::LeftButton && event->type() == QEvent::MouseButtonRelease && (mouseEvent->modifiers() & Qt::ControlModifier) ) {
			SuperModel * sm = dynamic_cast<SuperModel*>(model());
			if( sm ) {
				int section = header()->logicalIndexAt(mouseEvent->pos());
				QList<int> sortColumns = sm->sortColumns();
				sortColumns.removeAll( section );
				if( sortColumns.size() >= 1 )
					sortColumns.insert(1,section);
				else
					sortColumns.append(section);
				sm->setSortColumns(sortColumns, /*forceResort = */ true );
				return true;
			}
		}
	}
	return false;
}


void ExtTreeView::showHeaderMenu( const QPoint & pos )
{
	SuperModel * sm = dynamic_cast<SuperModel*>(model());

	QMenu * menu = new QMenu( this ), * columnVisibilityMenu = 0, * sortOrderMenu = 0;
	columnVisibilityMenu = menu->addMenu( "Column Visibility" );
	if( sm )
		sortOrderMenu = menu->addMenu( "Sort Order" );

	/* Column Visibility */
	QMap<QAction*,int> visibilityColumnMap, sortOrderColumnMap;
	QStringList hls;// = mModel->headerLabels();
	QAbstractItemModel * mdl = model();
	for( int i = 0; i < mdl->columnCount(); ++i )
		hls += mdl->headerData(i,Qt::Horizontal,Qt::DisplayRole).toString();
	int i=0;
	foreach( QString hl, hls ) {
		QAction * act = columnVisibilityMenu->addAction( hl );
		act->setCheckable(true);
		if( !isColumnHidden(i) && columnWidth(i) > 0 )
			act->setChecked(true);
		visibilityColumnMap[act] = i++;
	}

	/* Sort order */
	if( sortOrderMenu && sm ) {
		QList<int> sortOrder = sm->sortColumns();
		foreach( int column, sortOrder ) {
			QAction * act = sortOrderMenu->addAction( hls[column] );
			sortOrderColumnMap[act] = column;
		}
	}
	
	QAction * ret = menu->exec( pos );
	delete menu;

	if( visibilityColumnMap.contains( ret ) ) {
		int ci = visibilityColumnMap[ret];
		bool currentlyHidden = isColumnHidden( ci ) || columnWidth( ci ) == 0;
		setColumnHidden( ci, !currentlyHidden );
		if( currentlyHidden && (columnAutoResize(ci) || columnWidth(ci) < 10) )
			resizeColumnToContents(ci);
		emit columnVisibilityChanged( ci, currentlyHidden );
	}
	else if( sortOrderColumnMap.contains( ret ) ) {
		int column = sortOrderColumnMap[ret];
		QList<int> sortOrder = sm->sortColumns();
		sortOrder.removeAll( column );
		sortOrder.push_front( column );
		sm->setSortColumns( sortOrder, /* forceResort = */ true );
	}
}

void ExtTreeView::setColumnAutoResize( int column, bool acr )
{
	if( acr && !mColumnAutoResize ) {
		mColumnAutoResize = true;
		doAutoColumnConnections();
	}
	if( column == -1 ) {
		int cnt = model()->columnCount();
		mAutoResizeColumns.resize( cnt );
		for( int i=0; i<cnt; i++ )
			mAutoResizeColumns.setBit(i,acr);
		return;
	}
	if( acr ) {
		if( column >= mAutoResizeColumns.size() )
			mAutoResizeColumns.resize(column+1);
		mAutoResizeColumns.setBit(column);
	} else
		mAutoResizeColumns.setBit(column,false);
}


void ExtTreeView::doAutoColumnConnections()
{
	connect( model(), SIGNAL( dataChanged ( const QModelIndex &, const QModelIndex & ) ), SLOT( scheduleResizeAutoColumns() ) );
	connect( model(), SIGNAL( layoutChanged() ), SLOT( scheduleResizeAutoColumns() ) );
	connect( model(), SIGNAL( modelReset() ) , SLOT( scheduleResizeAutoColumns() ) );
}

void ExtTreeView::setShowGrid( bool showGrid )
{
	mShowGrid = showGrid;
}

bool ExtTreeView::showGrid() const
{
	return mShowGrid;
}

void ExtTreeView::setGridColors( const QColor & gridColor, const QColor & gridHighlightColor )
{
	mGridColor = gridColor;
	mGridColorHighlight = gridHighlightColor;
}

void ExtTreeView::getGridColors( QColor & gridColor, QColor & gridHighlightColor )
{
	gridColor = mGridColor;
	gridHighlightColor = mGridColorHighlight;
}

QModelIndexList ExtTreeView::selectedRows()
{
	QModelIndexList ret;
	QItemSelection sel = selectionModel()->selection();
	foreach( QItemSelectionRange range, sel ) {
		QModelIndex topLeft = range.topLeft();
		while(1) {
			ret += topLeft;
			if( topLeft.row() >= range.bottom() ) break;
			topLeft = topLeft.sibling(topLeft.row()+1,topLeft.column());
		}
	}
	return ret;
}

void ExtTreeView::selectionChanged(const QItemSelection &selected, const QItemSelection &deselected)
{
	if( !mShowGrid ) {
		QTreeView::selectionChanged(selected,deselected);
		return;
	}
	QRect rect = visualRegionForSelection(deselected).boundingRect();
	setDirtyRegion( QRegion( rect.adjusted(0,-1,0,0) ) );
	rect = visualRegionForSelection(selected).boundingRect();
	setDirtyRegion( QRegion( rect.adjusted(0,-1,0,0) ) );
}

void ExtTreeView::setModel( QAbstractItemModel * model )
{
	QTreeView::setModel( model );
	if( mColumnAutoResize )
		doAutoColumnConnections();
	header()->viewport()->installEventFilter( this );
	header()->installEventFilter( this );
}

bool ExtTreeView::columnAutoResize( int col ) const
{
	return col < mAutoResizeColumns.size() && col >= 0 && mAutoResizeColumns.at(col);
}

void ExtTreeView::scheduleResizeAutoColumns()
{
    if ( !mAutoResizeScheduled ) {
        mAutoResizeScheduled = true;
        QTimer::singleShot( 0, this, SLOT( resizeAutoColumns() ) );
    }
}

void ExtTreeView::resizeAutoColumns()
{
    mAutoResizeScheduled = false;
	for( int i=0; i< qMin(model()->columnCount(),mAutoResizeColumns.size()); i++ ) {
		//LOG_5( "ExtTreeView::resizeAutoColumns: Checking column " + QString::number(i) );
		if( mAutoResizeColumns.at(i) ) {
			//LOG_5( "ExtTreeView::resizeAutoColumns: Resizing column " + QString::number(i) );
			resizeColumnToContents(i);
		}
	}
}

void ExtTreeView::expandRecursive( const QModelIndex & index, int levels )
{
	if( levels == 0 ) return;
	int rows = model()->rowCount(index);
	for( int i = 0; i < rows; i++ ) {
		QModelIndex child = model()->index( i,0,index );
		if( child.isValid() ) {
			setExpanded( child, true );
			if( levels > 1 || levels < 0 )
				expandRecursive( child, levels > 0 ? levels - 1 : -1 );
		}
	}
}

int ExtTreeView::sizeHintForColumn( int column ) const
{
	QStyleOptionViewItem option = viewOptions();
	QAbstractItemDelegate *delegate = itemDelegate();
	QModelIndex index;
	QSize size;
	int w = 0;

	ModelIter it( model(), ModelIter::Filter(ModelIter::Recursive | ModelIter::DescendOpenOnly), 0, const_cast<ExtTreeView*>(this) );
	for( ; it.isValid(); ++it ) {
		index = (*it).sibling((*it).row(), column);
		size = delegate->sizeHint(option, index);
		w = qMax(w, size.width() + (column == 0 ? indentation() * it.depth() : 0));
	}
	
	return w;
}

bool ExtTreeView::showBranches() const
{
	return mShowBranches;
}

void ExtTreeView::setShowBranches( bool showBranches )
{
	mShowBranches = showBranches;
	update();
}

QStyleOptionViewItem ExtTreeView::viewOptions() const
{
	QStyleOptionViewItem ret = QTreeView::viewOptions();
	if( !mShowGrid ) return ret;
	ret.state |= QStyle::StateFlag(State_ShowGrid);
	ret.palette.setColor( QPalette::Dark, mGridColor );
	ret.palette.setColor( QPalette::Light, mGridColorHighlight );
	return ret;
}

void ExtTreeView::startDrag ( Qt::DropActions supportedActions )
{
	QModelIndexList indexes = selectedIndexes();
	if (indexes.count() > 0) {
		QMimeData *data = model()->mimeData(indexes);
		if (!data)
			return;
		QRect rect;
		QDrag *drag = new QDrag(this);
		drag->setMimeData(data);
		drag->start(supportedActions);
	}
}

void ExtTreeView::drawBranches ( QPainter * p, const QRect & rect, const QModelIndex & index ) const
{
	const int indent = indentation();
	const int outer = rootIsDecorated() ? 0 : 1;

	QStyle::State extraFlags = QStyle::State_None;
	if (isEnabled())
		extraFlags |= QStyle::State_Enabled;
	if (window()->isActiveWindow())
		extraFlags |= QStyle::State_Active;

	QModelIndex parent = index.parent();
	int level = 0;
	{
		QModelIndex i = index.parent();
		while( i.isValid() ) {
			i = i.parent();
			level++;
		}
	}


	//RecordTreeView * rtc = const_cast<RecordTreeView*>(this);
	if( !mShowBranches )
	{
		if( level < outer || !model()->hasChildren(index) ) return;
		QRect primitive(rect.right() - indent, rect.top(), indent, rect.height());
		QStyleOption so(0);
		so.rect = primitive;
		so.state = QStyle::State_Item | extraFlags | QStyle::State_Children
			| (isExpanded(index) ? QStyle::State_Open : QStyle::State_None);
		QApplication::style()->drawPrimitive(QStyle::PE_IndicatorBranch, &so, p, this);
		return;
	}

	QPlastiqueStyle * ps = qobject_cast<QPlastiqueStyle*>(QApplication::style());
	if( ps ) {
		QRect primitive(rect.right(), rect.top(), indent, rect.height());
	
		QModelIndex current = parent;
		QModelIndex ancestor = current.parent();
	
		QColor bc( 185, 195, 185 );

		//int origLevel = level;
		if (level >= outer) {
			// start with the innermost branch
			primitive.moveLeft(primitive.left() - indent);
	
			const bool expanded = isExpanded(index);
			const bool children = model()->hasChildren(index); // not layed out yet, so we don't know
			bool hasSiblingBelow = model()->rowCount(parent) - 1 > index.row();
			if( children ) {
				QStyleOption so(0);
				so.rect = primitive;
				so.state = QStyle::State_Item | extraFlags
                    | (hasSiblingBelow ? QStyle::State_Sibling : QStyle::State_None)
                    | (children ? QStyle::State_Children : QStyle::State_None)
                    | (expanded ? QStyle::State_Open : QStyle::State_None);
		        ps->drawPrimitive(QStyle::PE_IndicatorBranch, &so, p, this);
			} else {
				int h = primitive.top() + primitive.height()/2;
				int x = primitive.left() + primitive.width()/2;
				p->setPen( bc );
				p->drawLine( x, primitive.top(), x, hasSiblingBelow ? primitive.bottom() : h );
				p->drawLine( x, h, primitive.right(), h );
			}
		}
		// then go out level by level
		for (--level; level >= outer; --level) { // we have already drawn the innermost branch
			primitive.moveLeft(primitive.left() - indent);
			bool hasSiblingBelow = model()->rowCount(ancestor) - 1 > current.row();
			current = ancestor;
			ancestor = current.parent();
			//int h = primitive.top() + primitive.height()/2;
			int x = primitive.left() + primitive.width()/2;
			//int fade = 170;//20 + (origLevel-level)*20;
			p->setPen( bc );
			if( hasSiblingBelow )
				p->drawLine( x, primitive.top(), x, primitive.bottom() );
		}
		return;
	}
	QTreeView::drawBranches( p, rect, index );
}

void ExtTreeView::slotCustomContextMenuRequested( const QPoint & p )
{
	QModelIndex under = indexAt( p );
	emit showMenu( viewport()->mapToGlobal(p), under );
}

void ExtTreeView::setupColumns( IniConfig & ini, const ColumnStruct columns [] )
{
	QHeaderView * hdr = header();
	int cnt = 0;
	QStringList labels;
	for( cnt=0; columns[cnt].name; ++cnt );
	QVector<int> indexVec(cnt);
	for( int i=0; i<cnt; i++ ) {
		labels << QString::fromLatin1(columns[i].name);
		indexVec[i] = ini.readInt( columns[i].iniName + QString("Index"), columns[i].defaultPos );
	}
	SuperModel * sm = dynamic_cast<SuperModel*>(model());
	if( sm )
		sm->setHeaderLabels( labels );
	hdr->setStretchLastSection(false);
	for( int n=0; n<cnt; n++ ) {
		for( int i=0; i<cnt; i++ )
			if( indexVec[i] == n )
				hdr->moveSection( hdr->visualIndex(i), n );
	}
	hdr->resizeSections(QHeaderView::Stretch);
	for( int n=0; n<cnt; n++ ) {
		int size = ini.readInt( columns[n].iniName + QString("Size"), columns[n].defaultSize );
		hdr->resizeSection( n, size );
	}
	for( int n=0; n<cnt; n++ ) {
		bool hidden = ini.readBool( columns[n].iniName + QString("Hidden"), columns[n].defaultHidden );
		hdr->setSectionHidden( n, hidden );
	}
	hdr->setResizeMode( QHeaderView::Interactive );
}

void ExtTreeView::saveColumns( IniConfig & ini, const ColumnStruct columns [] )
{
	QHeaderView * hdr = header();
	for( int i=0; columns[i].name; i++ )
		ini.writeInt( columns[i].iniName + QString("Size"), hdr->sectionSize( i ) );
	for( int i=0; columns[i].name; i++ )
		ini.writeInt( columns[i].iniName + QString("Index"), hdr->visualIndex( i ) );
	for( int i=0; columns[i].name; i++ )
		ini.writeBool( columns[i].iniName + QString("Hidden"), hdr->isSectionHidden( i ) );
}

void ExtTreeView::setupTreeView( IniConfig & ini, const ColumnStruct columns [] )
{
	setupColumns( ini, columns );
	SuperModel * sm = dynamic_cast<SuperModel*>(model());
	int sc = -1;
	if( sm ) {
		QList<int> scl = ini.readIntList( "SortColumnOrder" );
		sm->setSortColumns( scl );
		sc = scl.isEmpty() ? 0 : scl[0];
	} else
		sc = ini.readInt("SortColumn", 0);
	Qt::SortOrder order(Qt::SortOrder(ini.readInt("SortOrder",Qt::AscendingOrder)));
	header()->setSortIndicator(sc,order);
	model()->sort(sc,order);
}

void ExtTreeView::setupTreeView( const QString & group, const QString & key, const ColumnStruct columns [] )
{
	Q_UNUSED(key);

	IniConfig & cfg = userConfig();
	cfg.pushSection( group );
	setupTreeView(cfg,columns);
	cfg.popSection();
}

void ExtTreeView::saveTreeView( IniConfig & ini, const ColumnStruct columns [] )
{
	saveColumns( ini, columns );
	SuperModel * sm = dynamic_cast<SuperModel*>(model());
	if( sm )
		ini.writeIntList( "SortColumnOrder", sm->sortColumns() );
	else
		ini.writeInt( "SortColumn", header()->sortIndicatorSection() );
	ini.writeInt( "SortOrder", header()->sortIndicatorOrder() );
}

void ExtTreeView::saveTreeView( const QString & group, const QString & key, const ColumnStruct columns [] )
{
	Q_UNUSED(columns);

	IniConfig & cfg = userConfig();
	cfg.pushSection( group + ":" + key );
	cfg.popSection();
}

RecordTreeView::RecordTreeView( QWidget * parent )
: ExtTreeView( parent, 0 )
{
	setContextMenuPolicy( Qt::CustomContextMenu );

	connect( this, SIGNAL( clicked( const QModelIndex & ) ), SLOT( slotClicked( const QModelIndex & ) ) );

	mDelegate = new RecordDelegate(this);
	setItemDelegate( mDelegate );
}

void RecordTreeView::setModel( QAbstractItemModel * model )
{
	ExtTreeView::setModel(model);
	QItemSelectionModel * sm = selectionModel();
	connect( sm, SIGNAL( currentChanged( const QModelIndex &, const QModelIndex & ) ),
		SLOT( slotCurrentChanged( const QModelIndex &, const QModelIndex & ) ) );
	connect( sm, SIGNAL( selectionChanged( const QItemSelection &, const QItemSelection & ) ),
		SLOT( slotSelectionChanged( const QItemSelection &, const QItemSelection & ) ) );
}

QModelIndex RecordTreeView::findIndex( const Record & r, bool recursive, const QModelIndex & parent, bool loadChildren )
{
	RecordSuperModel * rsm = model();
	if( rsm )
		return rsm->findIndex( r, recursive, parent, loadChildren );
	return QModelIndex();
}

QModelIndexList RecordTreeView::findIndexes( RecordList rl, bool recursive, const QModelIndex & parent, bool loadChildren )
{
	RecordSuperModel * rsm = model();
	if( rsm )
		return rsm->findIndexes( rl, recursive, parent, loadChildren );
	return QModelIndexList();
}
	
Record RecordTreeView::getRecord(const QModelIndex & i)
{
	RecordSuperModel * rsm = model();
	if( rsm )
		return rsm->getRecord( i );
	return Record();
}

Record RecordTreeView::current()
{
	QModelIndex idx = selectionModel()->currentIndex();
	return idx.isValid() ? getRecord(idx) : Record();
}

RecordList RecordTreeView::selection()
{
	RecordSuperModel * rsm = model();
	if( rsm )
		return rsm->listFromIS( selectionModel()->selection() );
	return RecordList();
}

void RecordTreeView::setSelection( const RecordList & rl )
{
	QItemSelectionModel * sm = selectionModel();
	sm->clear();
	QModelIndexList il = findIndexes(rl,true);
	int lc = model()->columnCount()-1;
	foreach( QModelIndex i, il )
		sm->select( QItemSelection(i,i.sibling(i.row(),lc)), QItemSelectionModel::Select );
}

void RecordTreeView::setCurrent( const Record & r )
{
	QModelIndex i = findIndex( r );
	if( i.isValid() )
		selectionModel()->setCurrentIndex( i, QItemSelectionModel::NoUpdate );
}

void RecordTreeView::slotCurrentChanged( const QModelIndex & i, const QModelIndex & )
{
	emit currentChanged( getRecord(i) );
}

void RecordTreeView::slotSelectionChanged( const QItemSelection &, const QItemSelection & )
{
	emit selectionChanged( selection() );
}

void RecordTreeView::slotClicked( const QModelIndex & index )
{
	emit clicked( getRecord(index) );
}

void RecordTreeView::slotCustomContextMenuRequested( const QPoint & p )
{
	QModelIndex under = indexAt( p );
	RecordList sel = selection();
	emit showMenu( 
		viewport()->mapToGlobal(p),
		under.isValid() ? getRecord(under) : Record(),
		sel.isEmpty() ? RecordList( current() ) : sel
	);
	ExtTreeView::slotCustomContextMenuRequested(p);
}

void RecordTreeView::scrollTo( const Record & r )
{
	scrollTo( model()->findIndex( r ) );
}

void RecordTreeView::scrollTo( RecordList rl )
{
	scrollTo( model()->findFirstIndex( rl ) );
}

