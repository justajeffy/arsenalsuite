
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
 * $LastChangedDate: 2010-03-25 12:18:02 +1100 (Thu, 25 Mar 2010) $
 * $Rev: 9589 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/settingsdialog.cpp $
 */

#include <qpushbutton.h>
#include <qlineedit.h>
#include <qfiledialog.h>
#include <qspinbox.h>

#include "settingsdialog.h"

extern Options options;

SettingsDialog::SettingsDialog( QWidget * parent )
: QDialog( parent )
, mChanges( false )
{
	setupUi( this );

	connect( ApplyButton, SIGNAL( clicked() ), SLOT( slotApply() ) );
	connect( OKButton, SIGNAL( clicked() ), SLOT( slotApply() ) );
	opts = options;

	mJobLimitSpin->setValue( opts.mLimit );
	mRefreshIntervalSpin->setValue( opts.mRefreshInterval );
	mAutoRefreshOnWindowActivationCheck->setChecked( opts.mAutoRefreshOnWindowActivation );
	mRefreshOnViewChangeCheck->setChecked( opts.mRefreshOnViewChange );

	connect( mJobLimitSpin, SIGNAL( valueChanged( int ) ), SLOT( changes() ) );
	connect( mRefreshIntervalSpin, SIGNAL( valueChanged( int ) ), SLOT( changes() ) );
	connect( mAutoRefreshOnWindowActivationCheck, SIGNAL( toggled(bool) ), SLOT( changes() ) );
	connect( mRefreshOnViewChangeCheck, SIGNAL( toggled(bool) ), SLOT( changes() ) );

	ApplyButton->setEnabled( false );
}

void SettingsDialog::slotApply()
{
	if( mChanges ){
		opts.mLimit = mJobLimitSpin->value();
		opts.mRefreshInterval = mRefreshIntervalSpin->value();
		opts.mAutoRefreshOnWindowActivation = mAutoRefreshOnWindowActivationCheck->isChecked();
		opts.mRefreshOnViewChange = mRefreshOnViewChangeCheck->isChecked();
		options = opts;
		mChanges = false;
		ApplyButton->setEnabled( false );
		emit apply();
	}
}

void SettingsDialog::changes()
{
	mChanges = true;
	ApplyButton->setEnabled( true );
}

