
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

#ifndef JOBFUSIONSETTINGS_WIDGET_H
#define JOBFUSIONSETTINGS_WIDGET_H

#include "job.h"
#include "afcommon.h"

#include "jobsettingswidget.h"
#include "ui_jobfusionsettingswidgetui.h"
#include "ui_jobfusionvideomakersettingswidgetui.h"

class ASSFREEZER_EXPORT JobFusionSettingsWidget : public CustomJobSettingsWidget, public Ui::JobFusionSettingsWidgetUI
{
Q_OBJECT
public:
	JobFusionSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs );
	~JobFusionSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();
};

class ASSFREEZER_EXPORT JobFusionVideoMakerSettingsWidget : public CustomJobSettingsWidget, public Ui::JobFusionVideoMakerSettingsWidgetUI
{
Q_OBJECT
public:
	JobFusionVideoMakerSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs );
	~JobFusionVideoMakerSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();

	void updateOutputPath();
};


#endif // JOBFUSIONSETTINGS_WIDGET_H


