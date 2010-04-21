
/* $Header$
 */

#ifndef JOB_SETTINGS_WIDGET_PLUGIN_H
#define JOB_SETTINGS_WIDGET_PLUGIN_H

#include <qmap.h>
#include <qstring.h>

#include "afcommon.h"
#include "jobsettingswidget.h"

class QWidget;
class CustomJobSettingsWidget;

class ASSFREEZER_EXPORT CustomJobSettingsWidgetPlugin
{
public:
	virtual ~CustomJobSettingsWidgetPlugin(){}
	virtual QStringList jobTypes()=0;
	virtual CustomJobSettingsWidget * createCustomJobSettingsWidget( const QString & jobType, QWidget * parent, JobSettingsWidget::Mode )=0;
};

ASSFREEZER_EXPORT void registerBuiltinCustomJobSettingsWidgets();

class ASSFREEZER_EXPORT CustomJobSettingsWidgetsFactory
{
public:
	static bool supportsJobType( const QString & );
	static CustomJobSettingsWidget * createCustomJobSettingsWidget( const QString & jobType, QWidget * parent, JobSettingsWidget::Mode );
	static void registerPlugin( CustomJobSettingsWidgetPlugin * bp );
	static QMap<QString,CustomJobSettingsWidgetPlugin*>  mCustomJobSettingsWidgetsPlugins;
	static bool mPluginsLoaded;
};

#endif // JOB_SETTINGS_WIDGET_PLUGIN_H
