
#ifndef ASSFREEZER_MENUS_H
#define ASSFREEZER_MENUS_H

#include <qmenu.h>

#include "jobtask.h"
#include "joberror.h"

#include "afcommon.h"

class QAction;
class JobListWidget;
class HostListWidget;
class AssfreezerView;
class JobViewerPlugin;
class HostViewerPlugin;

class ASSFREEZER_EXPORT AssfreezerMenu : public QMenu
{
Q_OBJECT
public:
	AssfreezerMenu( QWidget * parent, const QString & title = QString() );

public slots:
    virtual void slotCurrentViewChanged( AssfreezerView * );
	virtual void slotAboutToShow() = 0;
	virtual void slotActionTriggered( QAction * ) {}
};

class ASSFREEZER_EXPORT JobListMenu : public AssfreezerMenu
{
public:
	JobListMenu(JobListWidget *, const QString & title = QString());
protected:
    void slotCurrentViewChanged( AssfreezerView * );
	JobListWidget * mJobList;
};

class ASSFREEZER_EXPORT HostListMenu : public AssfreezerMenu
{
public:
	HostListMenu(HostListWidget *, const QString & title = QString());
protected:
    void slotCurrentViewChanged( AssfreezerView * );
	HostListWidget * mHostList;
};

class ASSFREEZER_EXPORT StatusFilterMenu : public JobListMenu
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

class ASSFREEZER_EXPORT ProjectFilterMenu : public JobListMenu
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

class ASSFREEZER_EXPORT JobTypeFilterMenu : public JobListMenu
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

class ASSFREEZER_EXPORT AssfreezerJobMenu : public JobListMenu
{
public:
	AssfreezerJobMenu(JobListWidget *);

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

class ASSFREEZER_EXPORT HostServiceFilterMenu : public HostListMenu
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

class ASSFREEZER_EXPORT CannedBatchJobMenu : public HostListMenu
{
public:
	CannedBatchJobMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
};

class ASSFREEZER_EXPORT TailServiceLogMenu : public HostListMenu
{
public:
	TailServiceLogMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);

protected:
};

class ASSFREEZER_EXPORT AssfreezerHostMenu : public HostListMenu
{
public:
	AssfreezerHostMenu(HostListWidget * hostList);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
protected:
	QAction * mShowHistoryAction;
    QMap<QAction *, HostViewerPlugin *> mHostViewerActions;
};

class ASSFREEZER_EXPORT AssfreezerTaskMenu : public JobListMenu
{
public:
	AssfreezerTaskMenu(JobListWidget *);

	void slotAboutToShow();
	void slotActionTriggered(QAction*);
protected:
	QAction * mInfoAction, * mRerenderFramesAction, * mSuspendFramesAction, 
	        * mCancelFramesAction, * mShowLogAction, * mCopyCommandAction,
			* mSelectHostsAction, * mShowHistoryAction;
	JobTaskList mTasks;
    QMap<QAction *, JobViewerPlugin *> mJobViewerActions;
    QMap<QAction *, HostViewerPlugin *> mHostViewerActions;
};

class ASSFREEZER_EXPORT AssfreezerErrorMenu : public AssfreezerMenu
{
Q_OBJECT
public:
	AssfreezerErrorMenu(QWidget *, JobErrorList selection, JobErrorList all);

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
};

#endif // ASSFREEZER_MENUS_H
