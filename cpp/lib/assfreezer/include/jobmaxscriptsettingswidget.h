
/* $Header$
 */

#ifndef JOB_MAX_SCRIPT_SETTINGS_WIDGET_H
#define JOB_MAX_SCRIPT_SETTINGS_WIDGET_H

#include "job.h"

#include "jobsettingswidget.h"
#include "jobmaxsettingswidget.h"
#include "ui_jobmaxscriptsettingswidgetui.h"

class Stone::RecordProxy;
using namespace Stone;

class ASSFREEZER_EXPORT JobMaxScriptSettingsWidget : public CustomJobSettingsWidget, public Ui::JobMaxScriptSettingsWidgetUI, public JobMaxUtils
{
Q_OBJECT
public:
	JobMaxScriptSettingsWidget(QWidget * parent=0, JobSettingsWidget::Mode mode = JobSettingsWidget::ModifyJobs );
	~JobMaxScriptSettingsWidget();
	
	QStringList supportedJobTypes();
	static QStringList jobTypes();

public slots:
	void resetSettings();
	void applySettings();

protected:
	RecordProxy * mSelectedJobsProxy;
	bool mIgnoreChanges;
};

#endif // JOB_MAX_SCRIPT_SETTINGS_WIDGET_H
