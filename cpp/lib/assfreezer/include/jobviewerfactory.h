
/* $Header$
 */

#ifndef JOB_VIEWER_FACTORY_H
#define JOB_VIEWER_FACTORY_H

#include <qmap.h>
#include <qstring.h>

class QWidget;
class JobViewerPlugin;

class JobViewerFactory
{
public:
	static void registerPlugin( JobViewerPlugin * );
	static QMap<QString,JobViewerPlugin*>  mJobViewerPlugins;
	static bool mPluginsLoaded;
};

#endif // JOB_VIEWER_FACTORY_H
