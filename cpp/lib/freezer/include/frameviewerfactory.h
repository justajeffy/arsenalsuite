#ifndef FRAME_VIEWER_FACTORY_H
#define FRAME_VIEWER_FACTORY_H

#include <qmap.h>
#include <qstring.h>

class QWidget;
class FrameViewerPlugin;

class FrameViewerFactory
{
public:
	static void registerPlugin( FrameViewerPlugin * );
	static QMap<QString, FrameViewerPlugin*>  mFrameViewerPlugins;
	static bool mPluginsLoaded;
};

#endif // FRAME_VIEWER_FACTORY_H
