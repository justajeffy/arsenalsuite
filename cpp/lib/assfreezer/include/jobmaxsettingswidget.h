
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

#ifndef JOBMAXSETTINGS_WIDGET_H
#define JOBMAXSETTINGS_WIDGET_H

#include "job.h"
#include "jobservice.h"

#include "jobsettingswidget.h"
#include "ui_jobmaxsettingswidgetui.h"

class Stone::RecordProxy;
using namespace Stone;

class ASSFREEZER_EXPORT JobMaxUtils
{
public:
	JobMaxUtils( CustomJobSettingsWidget * );

	// Clears cached jobservice entries
	void clearCache();

	// Returns true if the service is a 64 bit version of max
	bool is64Service( JobService service );

	QString serviceCounterpartName( Service s );

	Service serviceCounterpart( Service s );

	// Returns true if the service has a 64 bit counterpart if it's 32 or vice-versa
	bool hasServiceCounterpart( Service s );

	// Modifies the jobservice record if needed to use 64 bit max according to use64
	JobService set64Service( JobService service, bool use64 );
	
	// Finds the max jobservice record for the job
	JobService findMaxService( const Job & job );

	void reset64BitCheckBox( JobList jobs, QCheckBox * cb );
	void apply64BitCheckBox( JobList jobs, QCheckBox * cb );

protected:
	CustomJobSettingsWidget * mCJSW;
	QMap<Job,JobService> mMaxServicesByJob;
};

class ASSFREEZER_EXPORT JobMaxSettingsWidget : public CustomJobSettingsWidget, public Ui::JobMaxSettingsWidgetUI, public JobMaxUtils
{
Q_OBJECT
public:
	JobMaxSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs);
	~JobMaxSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();

	void browseOutputPath();

	void changeFrameNthSettings();
protected:
	RecordProxy * mProxy;
	bool mFrameNthChanges;
	int mFrameNthStart, mFrameNthEnd, mFrameNth, mFrameNthMode;
};

#endif // JOBMAXSETTINGS_WIDGET_H


