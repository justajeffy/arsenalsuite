
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
 * $Id: stonegui.cpp 5411 2007-12-18 01:03:08Z brobison $
 */

#include <qsqldatabase.h>
#include <qsqlerror.h>
#include <qtimer.h>

#include "stonegui.h"
#include "database.h"
#include "connection.h"
#include "lostconnectiondialog.h"
#include "imagesequenceprovider.h"

static ConnectionWatcher * sWatcher = 0;

ConnectionWatcher::ConnectionWatcher()
: mDialog( 0 )
{
	Connection * c = Database::current()->connection();
	connect( c, SIGNAL( connectionLost2() ), SLOT( connectionLost() ) );
}

void ConnectionWatcher::connectionLost()
{
	if( mDialog == 0 ) {
		Connection * c = Database::current()->connection();
		mDialog = new LostConnectionDialog( c, c->lastErrorText() );
		mDialog->exec();
		delete mDialog;
		mDialog = 0;
	}
}


void ConnectionWatcher::connected()
{
}

void initStoneGui()
{
	if( !sWatcher )
		sWatcher = new ConnectionWatcher();
	registerBuiltinImageSequenceProviderPlugins();
}

