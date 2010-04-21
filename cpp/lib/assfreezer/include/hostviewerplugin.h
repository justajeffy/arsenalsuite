
/* $Header$
 */

#ifndef HOST_VIEWER_PLUGIN_H
#define HOST_VIEWER_PLUGIN_H

class QAction;
class HostList;

class HostViewerPlugin
{
public:
    HostViewerPlugin(){}
	virtual ~HostViewerPlugin(){}
    virtual QString name(){return QString();};
    virtual QString icon(){return QString();};
    virtual void view(const HostList &){};
    virtual bool enabled(const HostList &){return true;};
};

#endif // HOST_VIEWER_PLUGIN_H
