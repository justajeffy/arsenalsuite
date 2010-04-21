
/* $Header$
 */

#ifndef JOB_BATCH_SETTINGS_WIDGET_H
#define JOB_BATCH_SETTINGS_WIDGET_H

#include "job.h"

#include "jobsettingswidget.h"
#include "ui_jobbatchsettingswidgetui.h"

class Stone::RecordProxy;
using namespace Stone;

class ASSFREEZER_EXPORT JobBatchSettingsWidget : public CustomJobSettingsWidget, public Ui::JobBatchSettingsWidgetUI
{
Q_OBJECT
public:
	JobBatchSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs );
	~JobBatchSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();

protected:
	RecordProxy * mProxy;
};

#endif // JOB_BATCH_SETTINGS_WIDGET_H
