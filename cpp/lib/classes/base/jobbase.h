
/*
 *
 * Copyright 2008 Blur Studio Inc.
 *
 * This file is part of the Resin software package.
 *
 * Resin is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Resin is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Resin; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#ifdef HEADER_FILES
#include "joboutput.h"
#endif

#ifdef CLASS_FUNCTIONS
	static bool updateJobStatuses( JobList jobs, const QString & jobStatus, bool resetTasks = false );

	void changeFrameRange( QList<int>, JobOutput output = JobOutput(), bool changeCancelledToNew = true );

	void changePreassignedTaskList( HostList hosts, bool changeCancelledToNew = true );

	void addHistory( const QString & message );

#endif

#ifdef TABLE_FUNCTIONS
	virtual void preUpdate( const Record &, const Record & );
	virtual void postUpdate( const Record & updated, const Record & old );
#endif
