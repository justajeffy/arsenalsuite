
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
 * $Id: undotoolbutton.h 5411 2007-12-18 01:03:08Z brobison $
 */

#ifndef UNDO_TOOL_BUTTON_H
#define UNDO_TOOL_BUTTON_H

#include <qobject.h>
#include <qlist.h>
#include <qtoolbutton.h>
#include <undomanager.h>

#include "stonegui.h"
#include "record.h"
#include "recordlist.h"

class STONEGUI_EXPORT UndoRedoToolButton : public QToolButton
{
Q_OBJECT
public:
	UndoRedoToolButton( QWidget * parent, UndoManager *, bool isUndo );
	
	void updatePopup();
	
public slots:
	void undoRedoChange( bool, bool );
	void menuItemClicked( int );
	
protected:
	bool mIsUndo;
	UndoManager * mUndoManager;
};

#endif // UNDO_TOOL_BUTTON_H

