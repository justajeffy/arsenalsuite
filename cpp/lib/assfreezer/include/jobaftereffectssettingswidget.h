
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

#ifndef JOBAFTEREFFECTSSETTINGS_WIDGET_H
#define JOBAFTEREFFECTSSETTINGS_WIDGET_H

#include "job.h"

#include "jobsettingswidget.h"
#include "ui_jobaftereffectssettingswidgetui.h"

class Stone::RecordProxy;
using namespace Stone;

class ASSFREEZER_EXPORT JobAfterEffectsSettingsWidget : public CustomJobSettingsWidget, public Ui::JobAfterEffectsSettingsWidgetUI
{
Q_OBJECT
public:
	JobAfterEffectsSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs );
	~JobAfterEffectsSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();

protected:
	RecordProxy * mProxy;
};

#endif // JOBAFTEREFFECTSSETTINGS_WIDGET_H


