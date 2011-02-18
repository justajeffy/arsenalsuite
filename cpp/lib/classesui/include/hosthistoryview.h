
#ifndef HOST_HISTORY_VIEW_H
#define HOST_HISTORY_VIEW_H

#include <qmainwindow.h>

#include "host.h"
#include "job.h"
#include "jobtask.h"

#include "recordtreeview.h"

#include "classesui.h"

class RecordSuperModel;

class JobAssignmentItem;
typedef TemplateRecordDataTranslator<JobAssignmentItem> JobAssignmentTranslator;

//class JobTaskAssignmentItem;
//typedef TemplateRecordDataTranslator<JobTaskAssignmentItem> JobTaskTranslator;

class CLASSESUI_EXPORT HostHistoryView : public RecordTreeView
{
Q_OBJECT
public:
	HostHistoryView( QWidget * parent );

	Host hostFilter() const;

	Job jobFilter() const;

	JobTask taskFilter() const;

	int limit() const;

public slots:
	void refresh();

	void setHostFilter( const Host & );
	void setJobFilter( const Job & );
	void setTaskFilter( const JobTask & );
	void setLimit( int limit );

protected slots:
	void doRefresh();
	void slotDoubleClicked( const QModelIndex & );

protected:
	void clearFilters();

	RecordSuperModel * mModel;
	JobAssignmentTranslator * mTrans;
	bool mRefreshScheduled;
	Job mJobFilter;
	Host mHostFilter;
	JobTask mJobTaskFilter;
	int mLimit;
	RecordList mCache;
};

class CLASSESUI_EXPORT HostHistoryWindow : public QMainWindow
{
Q_OBJECT
public:
	HostHistoryWindow( QWidget * parent = 0 );
	
	HostHistoryView * view() const;

protected:
	void closeEvent( QCloseEvent * );

	HostHistoryView * mView;
	QAction * mCloseAction, * mRefreshAction;
};

#endif // HOST_HISTORY_VIEW_H
