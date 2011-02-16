
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
 * $Id: sqlerrorhandler.cpp 8323 2009-05-22 19:55:04Z newellm $
 */

#include <qhostinfo.h>
#include <qcoreapplication.h>

#include "blurqt.h"
#include "iniconfig.h"
#include "sqlerrorhandler.h"

void SqlErrorHandler::handleError(const QString & error)
{
	QString hostName = QHostInfo::localHostName();
	IniConfig & ini = config();
	ini.pushSection("Database");
	QStringList dests = ini.readString("SqlErrorEmailList","newellm@blur.com").split(",");
	if( !dests.isEmpty() ) {
		sendEmail( dests, "Sql Error: " + hostName, 
			"Host: " + hostName + "\n" +
			"User: " + getUserName() + "\n" +
			"Application Name: " + QCoreApplication::instance()->applicationName() + "\n" +
			"Sql Error: " + error + "\n\n",
			ini.readString("SqlErrorSender","thePipe@blur.com") );
	}
	ini.popSection();
}

static SqlErrorHandler * sSqlErrorHandler = 0;

void SqlErrorHandler::setInstance(SqlErrorHandler * eh)
{
	if( sSqlErrorHandler )
		delete sSqlErrorHandler;
	sSqlErrorHandler = eh;
}

SqlErrorHandler * SqlErrorHandler::instance()
{
	if( !sSqlErrorHandler )
		sSqlErrorHandler = new SqlErrorHandler();
	return sSqlErrorHandler;
}

