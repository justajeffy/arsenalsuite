
/* $Header$
 */

#include "jobviewerfactory.h"
#include "jobviewerplugin.h"
#include <QAction>

bool JobViewerFactory::mPluginsLoaded = false;

QMap<QString,JobViewerPlugin*>  JobViewerFactory::mJobViewerPlugins;

void JobViewerFactory::registerPlugin( JobViewerPlugin * jvp )
{
    QString name = jvp->name();
    if( !mJobViewerPlugins.contains(name) ) {
        mJobViewerPlugins[name] = jvp;
        //LOG_3( "Registering JobViewerPlugin: " + name );
    }
}

