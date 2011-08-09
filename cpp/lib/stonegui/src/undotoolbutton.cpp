
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
 * $Id: undotoolbutton.cpp 5411 2007-12-18 01:03:08Z brobison $
 */

#include <qmenu.h>

#include "blurqt.h"
#include "database.h"
#include "undomanager.h"
#include "undotoolbutton.h"
#include "recordimp.h"
#include "table.h"

UndoRedoToolButton::UndoRedoToolButton( QWidget * parent, UndoManager * um, bool isUndo )
: QToolButton( parent )
, mIsUndo( isUndo )
, mUndoManager( um )
{
	setToolTip( isUndo ? "Undo" : "Redo" );
	setIcon( QIcon( isUndo ? ":/images/undo.png" : ":/images/redo.png" ) );
	setIconSize( QSize( 22, 22 ) );
	connect( um, SIGNAL( undoRedoChange( bool, bool ) ), SLOT( undoRedoChange( bool, bool ) ) );
	connect( this, SIGNAL( clicked() ), um, isUndo ? SLOT( undo() ) : SLOT( redo() ) );
	setEnabled( isUndo ? um->canUndo() : um->canRedo() );
}

void UndoRedoToolButton::updatePopup()
{
	QMenu * pp = new QMenu( this );//popup();
	if( !pp ) {
		pp = new QMenu( this );
		connect( pp, SIGNAL( activated( int ) ), SLOT( menuItemClicked( int ) ) );
	}
	pp->clear();
	QStringList items = mIsUndo ? mUndoManager->undoTitles( 10 ) : mUndoManager->redoTitles( 10 );
	foreach( QString item, items )
		pp->addAction( item );
	setMenu( pp );
}

void UndoRedoToolButton::undoRedoChange( bool ua, bool ra )
{
	setEnabled( mIsUndo ? ua : ra );
	updatePopup();
}

void UndoRedoToolButton::menuItemClicked( int id )
{
	mIsUndo ? mUndoManager->undo( id ) : mUndoManager->redo( id );
}

