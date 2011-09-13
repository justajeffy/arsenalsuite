#ifndef JOB_FRAMES_TAB_WIDGET_FACTORY_H
#define JOB_FRAMES_TAB_WIDGET_FACTORY_H

#include <qmap.h>
#include <qstring.h>

class QWidget;
class JobFramesTabWidgetPlugin;

class JobFramesTabWidgetFactory
{
public:
	static void registerPlugin( JobFramesTabWidgetPlugin * );
	static QMap<QString,JobFramesTabWidgetPlugin*>  mJobFramesTabWidgetPlugins;
	static bool mPluginsLoaded;
};

#endif 
