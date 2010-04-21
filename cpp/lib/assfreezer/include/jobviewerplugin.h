
/* $Header$
 */

#ifndef JOB_VIEWER_PLUGIN_H
#define JOB_VIEWER_PLUGIN_H

class QAction;
class JobList;

class JobViewerPlugin
{
public:
    JobViewerPlugin(){}
	virtual ~JobViewerPlugin(){}
    virtual QString name(){return QString();};
    virtual QString icon(){return QString();};
    virtual void view(const JobList &){};
    virtual bool enabled(const JobList &){return true;};
};

#endif // JOB_VIEWER_PLUGIN_H
