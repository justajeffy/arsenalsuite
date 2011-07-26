

#ifndef JOB_LIST_WIDGET_H
#define JOB_LIST_WIDGET_H

#include "ui_joblistwidgetui.h"

#include "job.h"
#include "project.h"
#include "element.h"
#include "joberror.h"
#include "jobtask.h"
#include "jobtype.h"
#include "service.h"

#include "assfreezerview.h"

class QAction;
class QWebView;

class FreezerWidget;
class FreezerJobMenu;
class FreezerErrorMenu;
class FrameListTask;
class ImageView;
class PartialFrameListTask;
class TabToolBar;
class BusyWidget;

class FREEZER_EXPORT JobListWidget : public FreezerView, public Ui::JobListWidgetUI
{
Q_OBJECT
public:
	JobListWidget( QWidget * parent );
	~JobListWidget();

	virtual QString viewType() const;

	/// access to the GL widget where image playback occurs
	ImageView * imageView() const;

	JobSettingsWidget * jobSettingsWidget() const { return mJobSettingsWidget; }

	const JobFilter & jobFilter() { return mJobFilter; }
	void setJobFilter( const JobFilter & );

	// If this view is set to show a specific list of jobs with setJobList
	// this will return those jobs until clearJobList is called.
	// Job filters are ignored while this list is not empty
	JobList jobList() const { return mJobList; }

	/// don't show jobs with fkeyProject in hiddenProjects
	void setHiddenProjects( ProjectList hiddenProjects );
	
	/// show jobs with fkeyElement in ElementList
	void setElementList( ElementList );
	
	/// show jobs with status in the list
	void setStatusToShow( QStringList );

    QWebView* mGraphs;

	QAction* RefreshAction;
	QAction* RestartAction;
	QAction* KillAction;
	QAction* PauseAction;
	QAction* ResumeAction;
	QAction* ShowOutputAction;
	QAction* FilterAction;
	QAction* FilterClearAction;
	QAction* ShowMineAction;
	QAction* ClearErrorsAction;
	QAction* DependencyTreeEnabledAction;
	QAction* NewViewFromSelectionAction;
	QAction* ShowClearedErrorsAction;

	ProjectList activeProjects();

	bool isDependencyTreeEnabled() const;

	Job currentJob() const { return mCurrentJob; }

	virtual QToolBar * toolBar( QMainWindow * );
	virtual void populateViewMenu( QMenu * );

public slots:
	/// show these jobs
	void setJobList( JobList );

	/// called to populate the tab according to the selected jobs
	void currentTabChanged();
	/// called to populate the tab according to the selected jobs
	void refreshCurrentTab();

	void setDependencyTreeEnabled( bool dependencyTreeEnabled, bool allowRefresh = true );

	/// refreshes the frame list from the database
	/// @param jobChange - set to true to clear the ImageView's cache
	void refreshFrameList( bool jobChange = true );
    void refreshErrorList();

	void currentJobChanged();
	void jobListSelectionChanged();

	void frameListSelectionChanged();
	void frameSelected(const Record &);

	/// selected jobs are told to re-render all frames
	void restartJobs();

	/// selected jobs are told to resume burning
	void resumeJobs();

	/// selected jobs are told to stop burning, all running tasks stop immediately
	void pauseJobs();

	/// selected jobs are told to stop burning, all running tasks stop immediately, job is deleted
	void deleteJobs();
    void updateSelectedJobs(const QString & jobStatus, bool resetTasks);

	/// toggles whether to only show jobs owned by current user
	void showMine(bool);

	/// selected jobs have all errors cleared
	void clearErrors();
	void jobFilterChanged( const QString & );

	/// shot output of selected jobs in file browser
	void outputPathExplorer();

	/// should select frameNumber in the frame list, currently does nothing
	/// @param frameNumber
	void changeFrameSelection(int);

	/// Used to refresh view when services column visibility goes from false to true
	void jobTreeColumnVisibilityChanged( int column, bool visible );

	void showJobPopup(const QPoint &);
	void showFramePopup(const QPoint &);
	void showErrorPopup(const QPoint &);

	void showJobInfo();
	void showJobStatistics();
	void clearJobList();
	void setJobPriority();
	void saveCannedBatchJob();

	void createNewViewFromSelection();

    void toggleFilter(bool);
    void clearFilters();

	void setFrameCacheStatus(int,int);

	void setLimit();

	void applyOptions();

protected:
	/// refreshes the job list from the database
	void doRefresh();

	void save( IniConfig & ini );
	void restore( IniConfig & ini );

	void customEvent( QEvent * evt );
	bool event( QEvent * evt );

    void clearChildrenToolTip( const QModelIndex & parent );
    void setChildrenToolTip( const QModelIndex & parent, const QMap<QString,QString> & userToolTips, const QMap<QString,QString> & projectToolTips );

    void initializeViews();

	QToolBar * mToolBar;
	TabToolBar * mTabToolBar;

    bool mViewsInitialized;
	bool mJobTaskRunning;
	bool mQueuedJobRefresh;
    bool mShowClearedErrors;

	FrameListTask * mFrameTask;
	PartialFrameListTask * mPartialFrameTask;

	JobList mSelectedJobs;
	Job mCurrentJob;

	JobList mJobList;
	JobFilter mJobFilter;

	bool mStaticDataRetrieved;

	// Static so that multiple instances of this view type can share this data
	static JobTypeList mJobTypeList;
	static ProjectList mProjectList;

public:
	QMenu * mJobMenu,
	 * mStatusFilterMenu,
	 * mProjectFilterMenu,
	 * mJobTypeFilterMenu,
	 * mTaskMenu;
	FreezerErrorMenu * mErrorMenu;

	friend class FreezerJobMenu;
	friend class FreezerWidget;
	friend class JobTypeFilterMenu;
	friend class ProjectFilterMenu;
	friend class StatusFilterMenu;
};

#endif // JOB_LIST_WIDGET_H
