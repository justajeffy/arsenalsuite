
/* $Header$
 */

#ifndef HOST_VIEWER_FACTORY_H
#define HOST_VIEWER_FACTORY_H

#include <qmap.h>
#include <qstring.h>

class QWidget;
class HostViewerPlugin;

class HostViewerFactory
{
public:
	static void registerPlugin( HostViewerPlugin * );
	static QMap<QString,HostViewerPlugin*>  mHostViewerPlugins;
	static bool mPluginsLoaded;
};

#endif // HOST_VIEWER_FACTORY_H
