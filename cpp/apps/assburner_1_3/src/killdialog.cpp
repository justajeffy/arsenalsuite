
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
 * $Id: killdialog.cpp 5401 2007-12-17 23:43:01Z brobison $
 */

#include <qtimer.h>
#include <qlistwidget.h>
#include <qpushbutton.h>
#include <qmessagebox.h>
#include <qmap.h>

#include "process.h"
#include "killdialog.h"

KillDialog::KillDialog( QStringList procNames, QWidget * parent )
: QDialog( parent )
, mProcessNames( procNames )
{
	setupUi( this );
	connect( mKillButton, SIGNAL( clicked() ), SLOT( kill() ) );

	mRefreshTimer = new QTimer( this );
	connect( mRefreshTimer, SIGNAL( timeout() ), SLOT( refresh() ) );
	mRefreshTimer->start( 10 );
}

void KillDialog::refresh()
{
	mProcessListWidget->clear();
	mPidMap.clear();
	foreach( QString procName, mProcessNames ) {
		QList<int> pids;
		pidsByName( procName, &pids );
		if( pids.size() > 0 )
			mPidMap[procName] = pids;
	}
	if( mPidMap.keys().size() == 0 ) {
		mRefreshTimer->stop();
		accept();
		return;
	}
	foreach( QString procName, mPidMap.keys() )
		foreach( int pid, mPidMap[procName] )
			mProcessListWidget->addItem( QString::number( pid ) + " - "+procName );
	mRefreshTimer->start( 1500 );
}

void KillDialog::kill()
{
	if(
		QMessageBox::critical( this,
			"Warning: Are you sure you want to kill these processes?",
			"Clicking yes will kill all processes listed.  Are you sure you want to continue?",
			"Yes", "Cancel","", 1, 1 ) == 0
	) {
		foreach( QString procName, mPidMap.keys() )
			foreach( int pid, mPidMap[procName] )
				killProcess( pid );
	}
}

