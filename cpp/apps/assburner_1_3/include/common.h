
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of RenderLine.
 *
 * RenderLine is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * RenderLine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with RenderLine; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id: common.h 5401 2007-12-17 23:43:01Z brobison $
 */

#ifndef COMMON_H
#define COMMON_H

#include <qglobal.h>

#ifdef Q_OS_WIN
#include <windows.h>
#endif

extern const char * CLIENT_LOG;
extern bool QUIT_ON_DISABLE;
extern const char * LOG_COMMAND;
extern const char * AF_COMMAND;

extern void * hMutex;

///
/// \defgroup Assburner Assburner - Renderline Client


#endif // COMMON_H
