
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of Assburner.
 *
 * Assburner is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Assburner is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Blur; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Author$
 * $LastChangedDate: 2010-01-28 11:52:31 +1100 (Thu, 28 Jan 2010) $
 * $Rev: 9265 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/include/afcommon.h $
 */

#ifndef AFCOMMON_H
#define AFCOMMON_H

#include <qobject.h>

#ifdef ASSFREEZER_MAKE_DLL
#define ASSFREEZER_EXPORT Q_DECL_EXPORT
#else
#define ASSFREEZER_EXPORT Q_DECL_IMPORT
#endif

#include "iniconfig.h"
#include "element.h"

struct ViewColors;

extern ASSFREEZER_EXPORT const char 	* LOGO_PATH,
					* CONFIG_PATH,
					* FRAGMENT_SHADER_PATH,
					* ICON_PATH;

#ifdef Q_OS_WIN
ASSFREEZER_EXPORT extern const char * VNC_LINK;
#endif

struct ASSFREEZER_EXPORT Options
{
	Options() : mJobColors(0), mFrameColors(0), mErrorColors(0), mHostColors(0) {}
	ViewColors * mJobColors, * mFrameColors, * mErrorColors, * mHostColors;
	QFont appFont;
	QFont jobFont;
	QFont frameFont;
	QFont summaryFont;
	QString frameCyclerPath;
	QString frameCyclerArgs;
	int mLimit;
	int mRefreshInterval; // Minutes
	int mCounterRefreshInterval; // seconds
	bool mAutoRefreshOnWindowActivation, mRefreshOnViewChange;
};

ASSFREEZER_EXPORT extern Options options;

// This structure holds all of the job settings
// that we can edit

struct ASSFREEZER_EXPORT CounterState {
	int hostsTotal, hostsActive, hostsReady;
	int jobsTotal, jobsActive, jobsDone;
};

struct ASSFREEZER_EXPORT JobFilter {
	// status filters
	QStringList statusToShow;

	// List of users to show, empty list shows all
	QStringList userList;

	// List of projects to hide, comma separated keys
	QStringList hiddenProjects;
	bool showNonProjectJobs;

	// List of job types to show
	QStringList typeToShow;

	// Elements ( shots ) to show
	ElementList elementList;
	
	uint mLimit;

	QString mExtraFilters;
};

ASSFREEZER_EXPORT void loadPythonPlugins();

ASSFREEZER_EXPORT void loadPythonPlugins();

#endif // AFCOMMON_H

