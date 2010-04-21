

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

/* $Header$
 */

#include <qmessagebox.h>

#include "recordproxy.h"

#include "jobtask.h"
#include "job.h"
#include "host.h"
#include "user.h"

#include "jobaftereffectssettingswidget.h"

JobAfterEffectsSettingsWidget::JobAfterEffectsSettingsWidget( QWidget * parent, JobSettingsWidget::Mode mode )
: CustomJobSettingsWidget( parent, mode )
{
	JobAfterEffectsSettingsWidget::setupUi( this );

	mProxy = new RecordProxy( this );

	/* Restart Settings connections */
	connect( mWidthSpin, SIGNAL( valueChanged(int,bool) ), SLOT( settingsChange() ) );
	connect( mHeightSpin, SIGNAL( valueChanged(int,bool) ), SLOT( settingsChange() ) );
	connect( mCompEdit, SIGNAL( textEdited(const QString &) ), SLOT( settingsChange() ) );

	mHeightSpin->setProxy( mProxy );
	mWidthSpin->setProxy( mProxy );
	mCompEdit->setProxy( mProxy );

	if( mode == JobSettingsWidget::ModifyJobs )
		mVerticalLayout->addLayout( mApplyResetLayout );
}

JobAfterEffectsSettingsWidget::~JobAfterEffectsSettingsWidget()
{
}

QStringList JobAfterEffectsSettingsWidget::supportedJobTypes()
{
	return jobTypes();
}

QStringList JobAfterEffectsSettingsWidget::jobTypes()
{
	return QStringList("AfterEffects");
}

template<class T> static QList<T> unique( QList<T> list )
{
	return list.toSet().toList();
}

template<class T> static Qt::CheckState listToCheckState( QList<T> list )
{
	list = unique(list);
	return list.size() == 1 ? (list[0] ? Qt::Checked : Qt::Unchecked) : Qt::PartiallyChecked;
}

template<class T> static void checkBoxApplyMultiple( QCheckBox * cb, QList<T> values )
{
	Qt::CheckState state = listToCheckState(values);
	cb->setTristate( state == Qt::PartiallyChecked );
	cb->setCheckState( state );
}

void JobAfterEffectsSettingsWidget::resetSettings()
{
	mProxy->setRecordList( mSelectedJobs, false, false );
	bool empty = mSelectedJobs.isEmpty();
	setEnabled( !empty );

	CustomJobSettingsWidget::resetSettings();
}

void JobAfterEffectsSettingsWidget::applySettings()
{
	if(
		QMessageBox::warning( this, "Warning: This will reset the job",
									"Applying the settings will reset the job.",
		 							QMessageBox::Ok, QMessageBox::Cancel, QMessageBox::NoButton)
		!= QMessageBox::Ok ){
		return;
	}
	// Apply changes from proxied widgets and get modified record list
	mProxy->applyChanges();
	mSelectedJobs = mProxy->records();

	if( mMode == JobSettingsWidget::ModifyJobs ) {
		mSelectedJobs.commit();

		Job::updateJobStatuses( mSelectedJobs, "new", true );
	}

	CustomJobSettingsWidget::applySettings();
}

