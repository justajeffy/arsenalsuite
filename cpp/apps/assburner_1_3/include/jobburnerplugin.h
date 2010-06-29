
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
 * $Id: jobburnerplugin.h 8233 2009-05-13 06:26:17Z newellm $
 */

#ifndef JOB_BURNER_PLUGIN_H
#define JOB_BURNER_PLUGIN_H

#include <qstring.h>
#include <qstringlist.h>

class Job;
class JobAssignment;
class JobBurner;
class Slave;

class JobBurnerPlugin
{
public:
	JobBurnerPlugin(){}
	virtual ~JobBurnerPlugin(){}
	virtual QStringList jobTypes()=0;
	virtual JobBurner * createBurner( const JobAssignment & jobAssignment, Slave * slave )=0;
};

#endif // JOB_BURNER_PLUGIN_H

