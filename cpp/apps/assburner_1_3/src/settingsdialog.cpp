
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
 * $Id: settingsdialog.cpp 5401 2007-12-17 23:43:01Z brobison $
 */

#include <qlineedit.h>
#include <qcheckbox.h>
#include <qpushbutton.h>

#include "settingsdialog.h"
#include "maindialog.h"
#include "blurqt.h"

SettingsDialog::SettingsDialog( QWidget * parent )
: QDialog( parent )
{
	setupUi( this );
	connect( DefaultsButton, SIGNAL( clicked() ), SLOT( applyDefaults() ) );
	readConfig();
}

void SettingsDialog::readConfig()
{
	IniConfig & c( config() );
	c.pushSection( "Assburner" );
	mClientLogFile->setText( c.readString("ClientLogFile", "assburner.log") );
	mLogCommand->setText( c.readString("LogCommand") );
	mAFPath->setText( c.readString("AFPath") );
	c.popSection();
}

void SettingsDialog::applyChanges()
{
	IniConfig & c( config() );
	c.pushSection( "Assburner" );
	c.writeString("ClientLogFile", mClientLogFile->text() );
	c.writeString("LogCommand", mLogCommand->text() );
	c.writeString("AFPath", mAFPath->text() );
	c.writeToFile();
	c.popSection();
}

void SettingsDialog::applyDefaults()
{
	IniConfig & c( config() );
	c.pushSection( "Assburner" );
	c.clear( true /* only clear this section */ );
	c.popSection();
	((MainDialog*)parent())->readConfig();
	readConfig();
}

