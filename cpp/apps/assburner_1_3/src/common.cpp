
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
 * $Id: common.cpp 7734 2009-02-26 18:24:01Z newellm $
 */

#include <qglobal.h>

#include "common.h"

void * hMutex = 0;

const char * CLIENT_LOG = "assburner.log";
bool QUIT_ON_DISABLE = false;

#ifdef Q_WS_WIN

// Windows config
const char * LOG_COMMAND = "c:/blur/assburner/Tail.exe %1";
const char * AF_COMMAND = "c:/blur/assfreezer/assfreezer.exe";

#else

// Linux config
const char * LOG_COMMAND = "konsole -e less %1";
const char * AF_COMMAND = "/usr/bin/assfreezer";

#endif // Q_WS_WIN

