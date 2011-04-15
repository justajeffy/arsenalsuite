
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
 * $Id: stonegui.h 5411 2007-12-18 01:03:08Z brobison $
 */

#ifndef STONE_GUI_H
#define STONE_GUI_H

#include <qobject.h>

#ifdef STONEGUI_MAKE_DLL
#define STONEGUI_EXPORT Q_DECL_EXPORT
#else
#define STONEGUI_EXPORT Q_DECL_IMPORT
#endif

class LostConnectionDialog;

class STONEGUI_EXPORT ConnectionWatcher : public QObject
{
Q_OBJECT
public:
	ConnectionWatcher();

public slots:
	void connectionLost();
	void connected();

protected:
	LostConnectionDialog * mDialog;
};

STONEGUI_EXPORT void initStoneGui();

#endif // STONE_GUI_H

