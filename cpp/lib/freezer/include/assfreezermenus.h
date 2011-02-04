
#ifndef FREEZER_MENUS_H
#define FREEZER_MENUS_H

#include <qmenu.h>

#include "jobtask.h"
#include "joberror.h"

#include "afcommon.h"

class QAction;
class JobListWidget;
class HostListWidget;
class FreezerView;
class JobViewerPlugin;
class HostViewerPlugin;
class FrameViewerPlugin;

class FREEZER_EXPORT FreezerMenuPlugin
{
public:
	virtual void executeMenuPlugin( QMenu * )=0;
};

class FREEZER_EXPORT FreezerMenuFactory
{
public:
	static FreezerMenuFactory * instance();

	void registerMenuPlugin( FreezerMenuPlugin * plugin, const QString & menuName );
	QList<QAction*> aboutToShow( QMenu * menu, bool addPreSep = false, bool addPostSep = false );

	QMap<QString,QList<FreezerMenuPlugin*> > mPlugins;
};

class FREEZER_EXPORT FreezerMenu : public QMenu
{
Q_OBJECT
public:
	FreezerMenu( QWidget * parent, const QString & title = QString() );

public slots:
    virtual void slotCurrentViewChanged( FreezerView * );
	virtual void slotAboutToShow() = 0;
	virtual void slotActionTriggered( QAction * ) {}
};

class FREEZER_EXPORT JobListMenu : public FreezerMenu
{
public:
	JobListMenu(JobListWidget *, const QString & title = QString());
protected:
    void slotCurrentViewChanged( FreezerView * );
	JobListWidget * mJobList;
};

class FREEZER_EXPORT HostListMenu : public FreezerMenu
{
public:
	HostListMenu(HostListWidget *, const QString & title = QString());
protected:
    void slotCurrentViewChanged( FreezerView * );
	HostListWidget * mHostList;
};

class FREEZER_EXPORT StatusFilterMenu : public JobListMenu
{
public:
	StatusFilterMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
    void updateActionStates();

protected:
	bool mStatusActionsCreated;
	QAction * mStatusShowAll, * mStatusShowNone;
	QList<QAction*> mStatusActions;
};

class FREEZER_EXPORT ProjectFilterMenu : public JobListMenu
{
Q_OBJECT
public:
	ProjectFilterMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
    void updateActionStates();

protected:
	QAction * mProjectShowAll, * mProjectShowNone, * mProjectShowNonProject;
	QList<QAction*> mProjectActions;
	bool mProjectActionsCreated;
};

class FREEZER_EXPORT JobTypeFilterMenu : public JobListMenu
{
public:
	JobTypeFilterMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
    void updateActionStates();

protected:
	bool mJobTypeActionsCreated;
    QAction * mJobTypeShowAll, * mJobTypeShowNone;
	QList<QAction*> mJobTypeActions;
};

class FREEZER_EXPORT FreezerJobMenu : public JobListMenu
{
public:
	FreezerJobMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered( QAction * );
    void updateActionStates();

protected:
    void modifyFrameRange( Job );
	QAction * mRemoveDependencyAction;
	QAction * mShowHistoryAction;
	QAction * mSetJobKeyListAction;
	QAction * mClearJobKeyListAction;
	QAction * mModifyFrameRangeAction;
    QMap<QAction *, JobViewerPlugin *> mJobViewerActions;
};

class FREEZER_EXPORT HostServiceFilterMenu : public HostListMenu
{
public:
	HostServiceFilterMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
    void updateActionStates();

protected:
	bool mActionsCreated;
	QList<QAction*> mHostServiceJobTypeActions;
    QAction * mHostServiceShowAll, * mHostServiceShowNone;
    QList<QAction*> mHostServiceActions;
};

class FREEZER_EXPORT CannedBatchJobMenu : public HostListMenu
{
public:
	CannedBatchJobMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
};

class FREEZER_EXPORT TailServiceLogMenu : public HostListMenu
{
public:
	TailServiceLogMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);

protected:
};

class FREEZER_EXPORT FreezerHostMenu : public HostListMenu
{
public:
	FreezerHostMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
protected:
	QAction * mShowHistoryAction;
    QMap<QAction *, HostViewerPlugin *> mHostViewerActions;
};

class FREEZER_EXPORT FreezerTaskMenu : public JobListMenu
{
public:
	FreezerTaskMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
protected:
	QAction * mInfoAction, * mRerenderFramesAction, * mSuspendFramesAction, 
	        * mCancelFramesAction, * mShowLogAction, * mCopyCommandAction,
			* mSelectHostsAction, * mShowHistoryAction;
	JobTaskList mTasks;
    QMap<QAction *, JobViewerPlugin *> mJobViewerActions;
    QMap<QAction *, HostViewerPlugin *> mHostViewerActions;
    QMap<QAction *, FrameViewerPlugin *> mFrameViewerActions;
};

class FREEZER_EXPORT FreezerErrorMenu : public FreezerMenu
{
Q_OBJECT
public:
	FreezerErrorMenu(QWidget *, JobErrorList selection, JobErrorList all);

	void setErrors( JobErrorList selection, JobErrorList allErrors );	
	void slotAboutToShow();
	void slotActionTriggered(QAction*);

protected:
	JobErrorList mSelection, mAll;
	QAction 
	 * mClearSelected,
	 * mClearAll,
	 * mCopyText,
	 * mShowLog,
	 * mSelectHosts,
	 * mRemoveHosts,
	 * mClearHostErrorsAndOffline,
	 * mClearHostErrors,
	 * mShowErrorInfo;
    QMap<QAction *, HostViewerPlugin *> mHostViewerActions;
    QMap<QAction *, FrameViewerPlugin *> mFrameViewerActions;
};

#endif // FREEZER_MENUS_H
