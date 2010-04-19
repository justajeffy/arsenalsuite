
#ifndef HOST_LIST_WIDGET_H
#define HOST_LIST_WIDGET_H

#include <qstring.h>

#include "service.h"

#include "assfreezerview.h"

class QAction;
class QMenu;

class AssFreezerWidget;
class RecordTreeView;

void clearHostErrorsAndSetOffline( HostList hosts, bool offline);
QString verifyKeyList( const QString & list, Table * table );

class ASSFREEZER_EXPORT HostListWidget : public AssfreezerView
{
Q_OBJECT
public:
	HostListWidget(QWidget * parent);
	~HostListWidget();

	virtual QString viewType() const;

	QAction* RefreshHostsAction;
	QAction* HostOnlineAction;
	QAction* HostOfflineAction;
	QAction* HostRestartAction;
	QAction* HostRestartWhenDoneAction;
	QAction* HostRebootAction;
	QAction* HostRebootWhenDoneAction;

	QAction* RestartAction;
	QAction* VNCHostsAction;
	QAction* ClientUpdateAction;

	QAction* SubmitBatchJobAction;
	QAction* ShowHostInfoAction;
	QAction* ClearHostErrorsSetOfflineAction;
	QAction* ClearHostErrorsAction;
	QAction* ShowHostErrorsAction;
	QAction* ShowJobsAction;

	virtual QToolBar * toolBar( QMainWindow * );
	virtual void populateViewMenu( QMenu * );

public slots:

	void hostListSelectionChanged();
	
	void setHostsStatus(const QString & status);
	/// selected hosts are told to start burning
	void setHostsOnline();
	/// selected hosts are told to stop burning
	void setHostsOffline();
	/// selected hosts are told to exit, and the process monitor is responsible for restarting Assburner
	void setHostsRestart();
	void setHostsRestartWhenDone();
	void setHostsReboot();
	void setHostsRebootWhenDone();
	/// selected hosts are told to update to the latest Assburner client
	void setHostsClientUpdate();
	/// opens vncviewer sessions to selected hosts
	void vncHosts();

	/// Opens a Job View and selects the jobs currently assigned to the selected hosts
	void showAssignedJobs();

	void showHostPopup(const QPoint &);

	void selectHosts( HostList );

	void applyOptions();

protected:
	/// refreshes the host list from the database
	void doRefresh();

	void save( IniConfig & ini );
	void restore( IniConfig & ini );

	void customEvent( QEvent * evt );

	RecordTreeView * mHostTree;

	QString mServiceFilter;

	// Static so that multiple instances of this view type can share this data
	static bool mStaticDataRetrieved;
	static ServiceList mServiceList;

	bool mHostTaskRunning;
	bool mQueuedHostRefresh;

	QToolBar * mToolBar;

public:
	QMenu * mHostMenu,
	 * mTailServiceLogMenu,
	 * mHostServiceFilterMenu,
	 * mCannedBatchJobMenu;

	friend class AssfreezerHostMenu;
	friend class AssFreezerWidget;
	friend class HostServiceFilterMenu;
	friend class CannedBatchJobMenu;
	friend class TailServiceLogMenu;
};

#endif // HOST_LIST_WIDGET_H
