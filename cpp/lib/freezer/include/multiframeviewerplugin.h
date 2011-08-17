#ifndef MULTI_FRAME_VIEWER_PLUGIN_H
#define MULTI_FRAME_VIEWER_PLUGIN_H

#include "jobtask.h"

class QAction;
class JobTaskList;

class MultiFrameViewerPlugin
{
public:
    MultiFrameViewerPlugin(){}
	virtual ~MultiFrameViewerPlugin(){}
    virtual QString name(){return QString();};
    virtual QString icon(){return QString();};
    virtual void view(JobTaskList){};
    virtual bool enabled(JobTaskList){return true;};
};

#endif // MULTI_FRAME_VIEWER_PLUGIN_H
