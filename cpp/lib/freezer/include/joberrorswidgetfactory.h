#ifndef JOB_ERRORS_WIDGET_FACTORY_H
#define JOB_ERRORS_WIDGET_FACTORY_H

#include <qmap.h>
#include <qstring.h>

class QWidget;
class JobErrorsWidgetPlugin;

class JobErrorsWidgetFactory
{
public:
	static void registerPlugin( JobErrorsWidgetPlugin * );
	static QMap<QString,JobErrorsWidgetPlugin*>  mJobErrorsWidgetPlugins;
	static bool mPluginsLoaded;
};

#endif 
