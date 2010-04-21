
/* $Header$
 */

#include "hostviewerfactory.h"
#include "hostviewerplugin.h"
#include <QAction>

bool HostViewerFactory::mPluginsLoaded = false;

QMap<QString,HostViewerPlugin*>  HostViewerFactory::mHostViewerPlugins;

void HostViewerFactory::registerPlugin( HostViewerPlugin * jvp )
{
    QString name = jvp->name();
    if( !mHostViewerPlugins.contains(name) ) {
        mHostViewerPlugins[name] = jvp;
        //LOG_3( "Registering HostViewerPlugin: " + name );
    }
}

