

#include <qclipboard.h>
#include <qfileinfo.h>
#include <qinputdialog.h>
#include <qmessagebox.h>
#include <qprocess.h>

#include "path.h"
#include "process.h"

#include "host.h"
#include "hostlistwidget.h"
#include "hosthistory.h"
#include "hostservice.h"
#include "jobassignment.h"
#include "jobcannedbatch.h"
#include "jobbatch.h"
#include "jobdep.h"
#include "jobhistory.h"
#include "jobhistorytype.h"
#include "jobassignmentstatus.h"
#include "jobtaskassignment.h"

#include "jobviewerfactory.h"
#include "jobviewerplugin.h"
#include "hostviewerfactory.h"
#include "hostviewerplugin.h"

#include "recordpropvaltree.h"
#include "remotetailwindow.h"
#include "hosthistoryview.h"

#include "assfreezermenus.h"
#include "batchsubmitdialog.h"
#include "hosterrorwindow.h"
#include "jobcommandhistorywindow.h"
#include "joblistwidget.h"
#include "mainwindow.h"

AssfreezerMenu::AssfreezerMenu( QWidget * parent, const QString & title)
: QMenu( title, parent )
{
	connect( this, SIGNAL( aboutToShow() ), SLOT( slotAboutToShow() ) );
	connect( this, SIGNAL( triggered( QAction * ) ), SLOT( slotActionTriggered( QAction * ) ) );
}

JobListMenu::JobListMenu(JobListWidget * jobList, const QString & title )
: AssfreezerMenu(jobList, title)
, mJobList(jobList)
{}

HostListMenu::HostListMenu(HostListWidget * hostList, const QString & title)
: AssfreezerMenu(hostList, title)
, mHostList(hostList)
{}

ProjectFilterMenu::ProjectFilterMenu(JobListWidget * jobList)
: JobListMenu( jobList, "Project Filter" )
, mProjectShowAll( 0 )
, mProjectShowNone( 0 )
, mProjectShowNonProject( 0 )
, mProjectActionsCreated( false )
{
	setTearOffEnabled( true );
}

void ProjectFilterMenu::slotAboutToShow()
{
	if( !mProjectActionsCreated ) {
		mProjectActionsCreated = true;

		mProjectShowAll = new QAction( "Show All", this );
		mProjectShowNone = new QAction( "Show None", this );
		mProjectShowNonProject = new QAction( "Non-Project Jobs", this );
		mProjectShowNonProject->setCheckable( true );
		mProjectShowNonProject->setChecked( mJobList->mJobFilter.showNonProjectJobs );
		ProjectList projectList = mJobList->activeProjects().sorted( "name" );
		foreach( Project p, projectList ) {
			QAction * act = new QAction( p.name(), this );
			act->setCheckable( true );
			act->setChecked( !mJobList->mJobFilter.hiddenProjects.contains( QString::number( p.key() ) ) );
			mProjectActions.append( act );
		}

		addAction( mProjectShowAll );
		addAction( mProjectShowNone );
		addSeparator();
		addAction( mProjectShowNonProject );
		addActions( mProjectActions );
	}
}

void ProjectFilterMenu::slotActionTriggered( QAction * act )
{
	bool refresh = false, updateActions = false, all = false;
	if( act == mProjectShowAll ) {
		mJobList->mJobFilter.hiddenProjects.clear();
		mJobList->mJobFilter.showNonProjectJobs = true;
		refresh = updateActions = all = true;
	} else if( act == mProjectShowNone ) {
		mJobList->mJobFilter.hiddenProjects.clear();
		ProjectList projectList = mJobList->activeProjects();
		foreach( Project p, projectList )
			mJobList->mJobFilter.hiddenProjects += QString::number(p.key());
		mJobList->mJobFilter.showNonProjectJobs = false;
		refresh = updateActions = true;
	} else if( act == mProjectShowNonProject ) {
		mJobList->mJobFilter.showNonProjectJobs = act->isChecked();
		refresh = true;
	} else {
		Project p = Project::recordByName( act->text() );
		if( p.isRecord() ) {
			QString project= QString::number(p.key());
			int i = mJobList->mJobFilter.hiddenProjects.indexOf( project );
			if( i < 0 )
				mJobList->mJobFilter.hiddenProjects += project;
			else
				mJobList->mJobFilter.hiddenProjects.removeAt(i);
			refresh = true;
		}
	}
	if( updateActions ) {
		foreach( QAction * act, mProjectActions )
			act->setChecked( all );
		mProjectShowNonProject->setChecked( all );
	}
	if( refresh )
		mJobList->refresh();
}

StatusFilterMenu::StatusFilterMenu(JobListWidget * jobList)
: JobListMenu( jobList, "Status Filter" )
, mStatusActionsCreated( false )
, mStatusShowAll( 0 )
, mStatusShowNone( 0 )
{
	setTearOffEnabled( true );
	setWindowTitle( "Status Filter" );
}

const char * stats[] = { "Submit", "Verify", "Ready", "Holding", "Started", "Suspended", "Done", "Deleted", 0 };

void StatusFilterMenu::slotAboutToShow()
{
	if( !mStatusActionsCreated )
	{
		mStatusActionsCreated = true;
		mStatusShowAll = new QAction( "Show All", this );
		mStatusShowNone = new QAction( "Show None", this );
		for(int i=0;stats[i]; i++){
			QString stat(stats[i]);
			QAction * act = new QAction( stat, this );
			act->setCheckable( true );
			if( mJobList->mJobFilter.statusToShow.contains(stat.toLower()) )
				act->setChecked(true);
			mStatusActions.append( act );
		}
		addAction( mStatusShowAll );
		addAction( mStatusShowNone );
		addSeparator();
		addActions( mStatusActions );
	}
}

void StatusFilterMenu::slotActionTriggered( QAction * act )
{
	QString txt = act->text();
	bool refresh = false, all = false, updateActions = false;
	if( txt == "Show All" ) {
		mJobList->mJobFilter.statusToShow.clear();
		for( int i=0; stats[i]; i++ )
			mJobList->mJobFilter.statusToShow += QString(stats[i]).toLower();
		refresh = all = updateActions = true;
	} else if( txt == "Show None" ) {
		mJobList->mJobFilter.statusToShow.clear();
		refresh = updateActions = true;
	} else {
		int i = 0;
		for( ; stats[i]; i++ )
			if( stats[i] == txt )
				break;
		if( stats[i] ) {
			QString stat = QString( stats[i] ).toLower();
			int i = mJobList->mJobFilter.statusToShow.indexOf( stat );
			LOG_5( "Status " + stat + " changed to " + (act->isChecked() ? "true" : "false") + " pos is " + QString::number(i) );
			if( i >= 0 )
				mJobList->mJobFilter.statusToShow.removeAt( i );
			else
				mJobList->mJobFilter.statusToShow += stat;
			refresh = true;
		}
	}
	if( updateActions ) {
		foreach( QAction * act, mStatusActions )
			act->setChecked( all );
	}
	if( refresh )
		mJobList->refresh();
}

JobTypeFilterMenu::JobTypeFilterMenu(JobListWidget * jobList)
: JobListMenu( jobList, "Job Type Filter" )
, mJobTypeActionsCreated( false )
{
	setTearOffEnabled( true );
}

void JobTypeFilterMenu::slotAboutToShow()
{
	if( !mJobTypeActionsCreated ) {
		mJobTypeActionsCreated = true;

		QAction * jobTypeShowAll = new QAction( "Show All", this );
		QAction * jobTypeShowNone = new QAction( "Show None", this );
		JobTypeList jtl = mJobList->mJobTypeList.sorted( "jobType" );
		foreach( JobType jt, jtl )
		{
			QImage img = jt.icon();
			QAction * act = new QAction( img.isNull() ? QIcon() : QPixmap::fromImage(jt.icon()), jt.name(), this );
			act->setCheckable( true );
			if( mJobList->mJobFilter.typeToShow.contains(QString::number(jt.key())) )
				act->setChecked( true );
			mJobTypeActions.append( act );
		}

		addAction( jobTypeShowAll );
		addAction( jobTypeShowNone );
		addSeparator();
		addActions( mJobTypeActions );
	}
}

void JobTypeFilterMenu::slotActionTriggered( QAction * act )
{
	QString txt = act->text();
	bool refresh = false, updateActions = false, all = false;
	if( txt == "Show All" ) {
		mJobList->mJobFilter.typeToShow.clear();
		foreach( JobType jt, mJobList->mJobTypeList )
			mJobList->mJobFilter.typeToShow += QString::number( jt.key() );
		refresh = updateActions = all = true;
	} else if( txt == "Show None" ) {
		mJobList->mJobFilter.typeToShow.clear();
		refresh = updateActions = true;
	} else {
		JobType jt = JobType::recordByName( txt );
		if( jt.isRecord() ) {
			QString jtk= QString::number(jt.key());
			int i = mJobList->mJobFilter.typeToShow.indexOf( jtk );
			if( i < 0 )
				mJobList->mJobFilter.typeToShow += jtk;
			else
				mJobList->mJobFilter.typeToShow.removeAt(i);
			refresh = true;
		}
	}
	if( updateActions )
		foreach( QAction * act, mJobTypeActions )
			act->setChecked( all );
	if( refresh )
		mJobList->refresh();
}

AssfreezerJobMenu::AssfreezerJobMenu(JobListWidget * jobList)
: JobListMenu( jobList )
, mRemoveDependencyAction( 0 )
, mShowHistoryAction( 0 )
, mModifyFrameRangeAction( 0 )
{
}

void AssfreezerJobMenu::slotAboutToShow()
{
	clear();

	addAction( mJobList->RefreshAction );

	QMenu * filtersMenu = addMenu( "View Filters" );

	filtersMenu->addAction( mJobList->ShowMineAction );
	filtersMenu->addMenu( mJobList->mProjectFilterMenu );
	filtersMenu->addMenu( mJobList->mStatusFilterMenu);
	filtersMenu->addMenu( mJobList->mJobTypeFilterMenu );
	filtersMenu->addSeparator();

/*
//	if( mAssfreezer->mAdminEnabled ) {
	mSetJobKeyListAction = filtersMenu->addAction( "Set Job Key List");
	mClearJobKeyListAction = filtersMenu->addAction( "Clear Job Key List");
//	}
*/
	filtersMenu->addAction("Set Limit...", mJobList, SLOT(setLimit()) );

	addSeparator();
    QMenu * openWithMenu = addMenu("Open with..");

    // replace with plugins driven system
    foreach( JobViewerPlugin * jvp, JobViewerFactory::mJobViewerPlugins.values() ) {
        QAction * action = new QAction( jvp->name(), this );
        action->setIcon( QIcon(jvp->icon()) );
        openWithMenu->addAction( action );
        mJobViewerActions[action] = jvp;
    }
	addSeparator();

	addAction( mJobList->ShowOutputAction );

	JobList jobs = mJobList->mJobTree->selection();

    // debugging actions
	addSeparator();
	bool jobOwner = mJobList->currentJob().user() == User::currentUser();
	if( User::hasPerms( "Job", false ) || jobOwner )
		addAction("Job Info...", mJobList, SLOT(showJobInfo()) );

	addAction("Job Statistics...", mJobList, SLOT(showJobStatistics()) );

    mShowHistoryAction = addAction("Job History...");
    mShowHistoryAction->setEnabled( jobs.size() == 1 );

	addSeparator();

    // wrangler actions
    mModifyFrameRangeAction = addAction( "Modify frame range..." );
    mModifyFrameRangeAction->setEnabled((User::hasPerms( "Job", true ) || jobOwner ));

	addAction("Set Job(s) Priority...", mJobList, SLOT(setJobPriority()) );
	addAction( mJobList->ClearErrorsAction );

	bool allDeps = !jobs.isEmpty();

	QItemSelection itemSelection = mJobList->mJobTree->selectionModel()->selection();
	foreach( QItemSelectionRange sr, itemSelection ) {
		if( !sr.parent().isValid() ) {
			allDeps = false;
			break;
		}
	}

	if( allDeps ) {
		mRemoveDependencyAction = addAction( "Remove Dependency" );
		addSeparator();
	} else
		mRemoveDependencyAction = 0;

    // job control
	addSeparator();
	addAction( mJobList->ResumeAction );
	addAction( mJobList->PauseAction );
	addAction( mJobList->KillAction );
	addAction( mJobList->RestartAction );
	addSeparator();

    // low frequency use, put at bottom of menu
	if( jobs.size() == 1 && JobBatch(jobs[0]).isRecord() )
		addAction( "Save As Canned Batch Job...", mJobList, SLOT(saveCannedBatchJob()) );
}

void AssfreezerJobMenu::slotActionTriggered( QAction * action )
{
    if( !action ) return;
	if( action == mRemoveDependencyAction ) {
		QItemSelection itemSelection = mJobList->mJobTree->selectionModel()->selection();
		JobDepList toRemove;
		QModelIndexList indexesToRemove;
		foreach( QItemSelectionRange sr, itemSelection ) {
			Job job = mJobList->mJobTree->model()->getRecord( sr.parent() );
			if( job.isRecord() ) {
				QModelIndex i = sr.topLeft();
				do {
					Job dep = mJobList->mJobTree->model()->getRecord(i);
					toRemove += JobDep::recordByJobAndDep(job,dep);

					LOG_5( "Job " + job.name() + " remove dependency on " + dep.name() );
                    JobHistory jh;
                    jh.setMessage( QString("Remove dependency on %1 key %2").arg(dep.name()).arg(dep.key()) );
                    jh.setUser( User::currentUser() );
                    jh.setHost( Host::currentHost() );
                    jh.setColumnLiteral( "created", "NOW()" );
                    jh.setJob( job );
                    jh.setType( JobHistoryType::recordByName( "info" ) );
                    jh.commit();

					i = i.sibling( i.row() + 1, 0 );
				} while( sr.contains(i) );
			}
		}
		// Remove the dependency links
		toRemove.remove();
	} else if ( action == mShowHistoryAction ) {
		HostHistoryWindow * hhw = new HostHistoryWindow();
		hhw->setWindowTitle( "Job Execution History" );
		hhw->view()->setJobFilter( mJobList->mJobTree->selection()[0] );
		hhw->show();
	} else if( action == mSetJobKeyListAction ) {
		bool okay = false;
		QString jobKeyList = QInputDialog::getText(mJobList,"Set Job List by job keys","Set Job List by job keys, comma or space separated", QLineEdit::Normal, mJobList->jobList().keyString(), &okay );
		if( okay ) {
			JobList jobs;
			foreach( QString jobKey, jobKeyList.split(QRegExp("[\\s,]+")) ) {
				Job j(jobKey.toInt());
				if( j.isRecord() ) jobs += j;
			}
			mJobList->setJobList(jobs);
		}
	} else if( action == mClearJobKeyListAction ) {
		mJobList->clearJobList();
	} else if( action == mModifyFrameRangeAction ) {
        foreach( Job job, mJobList->mJobTree->selection() )
            modifyFrameRange( job );
	} else if( mJobViewerActions.contains(action) ) {
        mJobViewerActions[action]->view(mJobList->mJobTree->selection());
	}
}

void AssfreezerJobMenu::modifyFrameRange( Job j )
{
    JobTaskList tasks = j.jobTasks();
    if( j.packetType() == "preassigned" ) {
        HostSelector * hs = new HostSelector( mJobList );
        hs->setHostList( tasks.filter( "status", "cancelled", false ).hosts() );
        if( hs->exec() == QDialog::Accepted ) {
            j.changePreassignedTaskList( hs->hostList() );
        }
        delete hs;
    } else {
        QMap<JobOutput,JobTaskList> tasksByOutput = tasks.groupedBy<JobOutput,JobTaskList,uint,JobOutput>("fkeyjoboutput");
        if( tasksByOutput.size() != 1 ) {
            QMessageBox::critical( mJobList, "Operation not supported", "Freezer is currently unable to modify frame ranges for job that have multiple outputs." );
        } else {
            QString frameRange = compactNumberList(tasks.filter( "status", "cancelled", false ).frameNumbers());
            do {
                bool valid = false;
                frameRange = QInputDialog::getText( mJobList, "Enter modified frame range", "Enter modified frame range", QLineEdit::Normal, frameRange, &valid );
                if( !valid ) break;
                QList<int> newFrameNumbers = expandNumberList( frameRange, &valid );
                if( valid ) {
                    j.changeFrameRange( newFrameNumbers, tasks[0].jobOutput() );
                    break;
                } else
                    QMessageBox::warning(mJobList, "Invalid frame range", "The frame range entered was invalid: " + frameRange);
            } while(true);
        }
    }
}

HostServiceFilterMenu::HostServiceFilterMenu(HostListWidget * hostList)
: HostListMenu(hostList, "Host Service Filter")
, mActionsCreated( false )
{
	setTearOffEnabled( true );
}

void HostServiceFilterMenu::slotAboutToShow()
{
	if( !mActionsCreated ) {
		mActionsCreated = true;

		bool checkServices = true;
		ServiceList sl = mHostList->mServiceList.sorted( "service" );
		QStringList serviceList = mHostList->mServiceFilter.split(',');

		QAction * act = addAction( "Show All" );
		act->setCheckable( true );
		if( serviceList.size() == (int)sl.size() ) {
			act->setChecked( true );
			checkServices = false;
		}

		act = addAction( "Show None" );
		act->setCheckable( true );
		if( serviceList.isEmpty() ) {
			act->setChecked( true );
			checkServices = false;
		}

		addSeparator();

		foreach( Service service, sl ) {
			act = addAction( service.service() );
			act->setCheckable( true );
			if( (!checkServices && !serviceList.isEmpty())
				|| (checkServices && serviceList.contains( QString::number( service.key() ) ) ) )
				act->setChecked( true );
		}
	}
}

void HostServiceFilterMenu::slotActionTriggered( QAction * act )
{
	bool resetServiceList = false, resetHostList = false;
	bool showAll = false, showNone = false;
	ServiceList sl = mHostList->mServiceList.sorted( "service" );
	QString serviceList = mHostList->mServiceFilter;
	QString txt = act->text();
	if( txt == "Show All" ) {
		serviceList = sl.keyString();
		resetServiceList = resetHostList = showAll = true;
	} else if( txt == "Show None" ) {
		serviceList.clear();
		resetServiceList = resetHostList = showNone = true;
	} else {
		Service s = Service::recordByName( txt );
		if( s.isRecord() ) {
			QString ks = QString::number( s.key() );
			QStringList ssl = serviceList.split(",");
			if( ssl.contains( ks ) )
				ssl.removeAll( ks );
			else
				ssl += ks;
			serviceList = ssl.join(",");
			resetServiceList = resetHostList = true;
		}
	}
	if( resetServiceList )
		mHostList->mServiceFilter = verifyKeyList( serviceList, Service::table() );
	if( resetHostList )
		mHostList->refresh();

	foreach( QAction * action, actions() ) {
		QString text = action->text();
		if( text == "Show All" )
			action->setChecked( serviceList.split(",").size() == (int)sl.size() );
		else if( text == "Show None" )
			action->setChecked( serviceList.isEmpty() );
		else if( showAll || showNone )
			action->setChecked( showAll );
	}
}

CannedBatchJobMenu::CannedBatchJobMenu(HostListWidget * hostList)
: HostListMenu( hostList, "Canned Batch Jobs" )
{}

void CannedBatchJobMenu::slotAboutToShow()
{
	clear();
	QMap<QString,RecordList> groupedCans = JobCannedBatch::select().groupedBy( "group" );
	QMap<QString, RecordList>::const_iterator i = groupedCans.constBegin();
	for (;i != groupedCans.constEnd(); ++i) {
		QMenu * group = addMenu( i.key() );
		RecordList rl = i.value();
		foreach( JobCannedBatch jcb, rl ) {
			QAction * a = group->addAction( jcb.name() );
			a->setProperty( "record", qVariantFromValue<Record>(jcb) );
		}
	}
}

void CannedBatchJobMenu::slotActionTriggered( QAction * action )
{
	JobCannedBatch jcb = qvariant_cast<Record>( action->property( "record" ) );
	BatchSubmitDialog * bsd = new BatchSubmitDialog( this );
	bsd->setName( jcb.name() );
	bsd->setCommand( jcb.cmd() );
	bsd->setCannedBatchGroup( jcb.group() );
	bsd->setHostList( mHostList->mHostTree->selection() );
	bsd->exec();
	delete bsd;
}


TailServiceLogMenu::TailServiceLogMenu(HostListWidget * hostList)
: HostListMenu( hostList, "Tail Service Log..." )
{
}

void TailServiceLogMenu::slotAboutToShow()
{
	clear();
	HostList hl = mHostList->mHostTree->selection();
	if( hl.size() == 1 ) {
		Host h = hl[0];
		// Only list services with a non-null remoteLogPort
		foreach( HostService hs, h.hostServices().filter( "remoteLogPort", 0, false ) ) {
			QAction * tailAction = addAction( hs.service().service() );
			tailAction->setProperty( "record", qVariantFromValue<Record>(hs) );
		}
	}
}

void TailServiceLogMenu::slotActionTriggered( QAction * action )
{
	HostService hs = qvariant_cast<Record>( action->property( "record" ) );
	if( hs.isRecord() ) {
		RemoteTailWindow * tailWindow = new RemoteTailWindow();
		tailWindow->setServiceName( hs.service().service() );
		RemoteTailWidget * tailWidget = tailWindow->tailWidget();
		tailWidget->connectToHost( hs.host().name(), hs.remoteLogPort() );
		tailWidget->setFileName( "APPLICATION_LOG" );
		tailWindow->show();
	}
}

AssfreezerHostMenu::AssfreezerHostMenu(HostListWidget * hostList)
: HostListMenu( hostList )
, mShowHistoryAction( 0 )
{}

void AssfreezerHostMenu::slotAboutToShow()
{
	clear();
	addAction( mHostList->RefreshHostsAction );

	HostList hl = mHostList->mHostTree->selection();
    foreach( HostViewerPlugin * hvp, HostViewerFactory::mHostViewerPlugins.values() ) {
        QAction * action = new QAction( hvp->name(), this );
        action->setIcon( QIcon(hvp->icon()) );
        addAction(action);
        mHostViewerActions[action] = hvp;
    }

	addSeparator();
	addAction( mHostList->HostOnlineAction );
	addAction( mHostList->HostOfflineAction );
	addAction( mHostList->HostRestartAction );
	addAction( mHostList->HostRestartWhenDoneAction );
	addAction( mHostList->HostRebootAction );
	addAction( mHostList->HostRebootWhenDoneAction );
	addSeparator();

	addAction( mHostList->ShowJobsAction );
	if( hl.size() == 1 )
		addAction( mHostList->ShowHostErrorsAction );
	addAction( mHostList->ClearHostErrorsAction );
	addAction( mHostList->ClearHostErrorsSetOfflineAction );

	if( 1 ) { //mAdminEnabled ){
		addSeparator();
        // borked?
		//addAction( mHostList->ClientUpdateAction );
		addAction( mHostList->SubmitBatchJobAction );
		addMenu( mHostList->mCannedBatchJobMenu );
	}

	if( User::hasPerms( "Host", false ) )
		addAction( mHostList->ShowHostInfoAction );

    mShowHistoryAction = addAction( "Show History..." );
    mShowHistoryAction->setEnabled( hl.size() == 1 );

    // This is borked
    //addMenu( mHostList->mTailServiceLogMenu );

	addSeparator();
	addMenu( mHostList->mHostServiceFilterMenu );
}

void AssfreezerHostMenu::slotActionTriggered( QAction * action )
{
    if( !action ) return;

    if( action == mHostList->SubmitBatchJobAction ) {
        BatchSubmitDialog * bsd = new BatchSubmitDialog( mHostList );
        bsd->setHostList( mHostList->mHostTree->selection() );
        bsd->exec();
        delete bsd;
    } else if( action == mHostList->ShowHostInfoAction ) {
        HostList selectedHosts = mHostList->mHostTree->selection();
        mHostList->restorePopup( RecordPropValTree::showRecords( selectedHosts, mHostList, User::hasPerms( "Host", true ) ) );
    } else if( action == mHostList->ClearHostErrorsSetOfflineAction ) {
        clearHostErrorsAndSetOffline( mHostList->mHostTree->selection(), true );
    } else if( action == mHostList->ClearHostErrorsAction ) {
        clearHostErrorsAndSetOffline( mHostList->mHostTree->selection(), false );
    } else if( action == mHostList->ShowHostErrorsAction ) {
        HostList hl = mHostList->mHostTree->selection();
        HostErrorWindow * hew = new HostErrorWindow( mHostList );
        hew->setHost( hl[0] );
        hew->show();
    } else if( action == mShowHistoryAction ) {
        HostHistoryWindow * hhw = new HostHistoryWindow();
        hhw->setWindowTitle( "Host Activity History" );
        hhw->view()->setHostFilter( mHostList->mHostTree->selection()[0] );
        hhw->show();
    } else if( mHostViewerActions.contains(action) ) {
        mHostViewerActions[action]->view( mHostList->mHostTree->selection() );
    }
}

static void createHostViewWithSelection(QWidget * widget, HostList hosts )
{
	MainWindow * mw = qobject_cast<MainWindow*>(widget->window());
	if( mw ) {
		HostListWidget * hostListView = new HostListWidget(mw);
		hostListView->selectHosts( hosts );
		mw->insertView( hostListView );
		mw->setCurrentView( hostListView );
	}
}

AssfreezerTaskMenu::AssfreezerTaskMenu(JobListWidget * jobList)
: JobListMenu(jobList)
, mInfoAction( 0 )
, mRerenderFramesAction( 0 )
, mSuspendFramesAction( 0 )
, mCancelFramesAction( 0 )
, mShowLogAction( 0 )
, mCopyCommandAction( 0 )
, mSelectHostsAction( 0 )
, mShowHistoryAction( 0 )
{
}

void AssfreezerTaskMenu::slotAboutToShow()
{
	clear();
	mTasks = mJobList->mFrameTree->selection();

    QMenu * openWithMenu = addMenu("Open output with..");
    foreach( JobViewerPlugin * jvp, JobViewerFactory::mJobViewerPlugins.values() ) {
        QAction * action = new QAction( jvp->name(), this );
        action->setIcon( QIcon(jvp->icon()) );
        openWithMenu->addAction( action );
        mJobViewerActions[action] = jvp;
    }

    QMenu * connectWithMenu = addMenu("Connect to host..");
    foreach( HostViewerPlugin * hvp, HostViewerFactory::mHostViewerPlugins.values() ) {
        QAction * action = new QAction( hvp->name(), this );
        action->setIcon( QIcon(hvp->icon()) );
        connectWithMenu->addAction( action );
        mHostViewerActions[action] = hvp;
    }

	addSeparator();

	if( ( User::hasPerms( "JobTask", false ) || mJobList->currentJob().user() == User::currentUser() )
		&& mTasks.size() == 1 ) {
		mInfoAction = addAction( "Task Info..." );
		mShowLogAction = addAction( "Show Log..." );
		mShowHistoryAction = addAction( "Show History..." );
		mCopyCommandAction = addAction( "Copy command" );
	}

	if( mTasks.size() )
		mSelectHostsAction = addAction( "Select Host(s)" );

	addSeparator();

	bool enabled = !mTasks.isEmpty();

	if( (QStringList() << "ready" << "started" << "done" << "suspended").contains(mJobList->currentJob().status())
		&& (User::currentUser() ==  mJobList->currentJob().user() || User::hasPerms( "JobTask", true ) ) )
	{
		mRerenderFramesAction = addAction( "Rerender Frame" + QString(mTasks.size()>1 ? "s" : "") );
		mRerenderFramesAction->setEnabled( enabled );
		mSuspendFramesAction = addAction( "Suspend Selected Frames" );
		mSuspendFramesAction->setEnabled( enabled );
		mCancelFramesAction = addAction( "Cancel Selected Frames" );
		mCancelFramesAction->setEnabled( enabled );
	}
}

void AssfreezerTaskMenu::slotActionTriggered( QAction * action )
{
    if( !action ) return;

    QStringList frameList;
    foreach( JobTask jt, mTasks )
        frameList += QString::number( jt.frameNumber() );
    if( action==mRerenderFramesAction ){
        if( QMessageBox::warning( this, "Rerender Frames", "Are you sure that you want to re-render the following frames?\n" + frameList.join(","),
            QMessageBox::Yes, QMessageBox::Cancel ) != QMessageBox::Yes )
            return;

        JobTaskAssignmentList assignments = mTasks.jobTaskAssignments();
        assignments.setJobAssignmentStatuses( JobAssignmentStatus::recordByName( "cancelled" ) );
        assignments.commit();
        mTasks.setStatuses( "new" );
        mTasks.setHosts( Host() );
        mTasks.setJobTaskAssignments( JobTaskAssignment() );
        mTasks.commit();

        JobList jobs = mTasks.jobs().unique();
        foreach( Job j, jobs ) {
            if( j.status() == "done" ) {
                j.setStatus( "started" );
                j.commit();
            }
            JobHistory jh;
            jh.setMessage( "Rerender Frames: " + frameList.join(",") );
            jh.setUser( User::currentUser() );
            jh.setHost( Host::currentHost() );
            jh.setColumnLiteral( "created", "NOW()" );
            jh.setJob( j );
            jh.setType( JobHistoryType::recordByName( "info" ) );
            jh.commit();
        }

        mJobList->refreshFrameList(false);
        mJobList->setStatusBarMessage( "Frames marked as 'new' for re-render" );
    }
    else if( action == mInfoAction ) {
        mJobList->restorePopup( RecordPropValTree::showRecords( mTasks, mJobList, User::hasPerms( "JobTask", true ) || mJobList->currentJob().user() == User::currentUser() ) );
    }
    else if( action == mCancelFramesAction ) {
        if( QMessageBox::warning( this, "Cancel Frames", "Are you sure that you want to cancel the following frames?\n"
            "The Frames will be marked 'cancelled', and will not be rendered.  You can select rerender later, but the job will be marked as done without the canceled frames being rendered, and if the delete on complete option is set you will not have a chance to rerender the frames.\n" + frameList.join(","),
            QMessageBox::Yes, QMessageBox::Cancel ) != QMessageBox::Yes )
            return;

        if( mJobList->currentJob().packetType() != "preassigned" )
            mTasks.setHosts( Host() );
        mTasks.setStatuses( "cancelled" );
        mTasks.commit();

        mJobList->refreshCurrentTab();
        mJobList->setStatusBarMessage( "Frames marked as 'cancelled'" );
    }
    else if( action == mSuspendFramesAction ) {
        if( mJobList->currentJob().packetType() != "preassigned" )
            mTasks.setHosts( Host() );
        mTasks.setStatuses( "suspended" );
        mTasks.commit();
        mJobList->setStatusBarMessage( QString::number( mTasks.size() ) + " frame" + QString(mTasks.size() > 1 ? "s" : "") + " suspended" );
    }
    else if( action == mShowLogAction && mTasks.size() == 1 ) {
        JobTask jt = mTasks[0];
        JobAssignmentWindow * jchw = new JobAssignmentWindow();
        JobAssignment ja = jt.jobTaskAssignment().jobAssignment();

        jchw->setJobAssignment( ja );
        jchw->setWindowTitle("Job Log for frame "+QString::number(jt.frameNumber()));
        jchw->show();
    }
    else if( action == mCopyCommandAction && mTasks.size() == 1 ) {
        JobTask jt = mTasks[0];
        QClipboard * cb = QApplication::clipboard();
        cb->setText( jt.jobTaskAssignment().jobAssignment().command() );
    }
    else if( action == mSelectHostsAction )
        createHostViewWithSelection( mJobList, mTasks.hosts() );
    else if( action == mShowHistoryAction ) {
        HostHistoryWindow * hhw = new HostHistoryWindow();
        hhw->setWindowTitle( "Task Execution History" );
        hhw->view()->setTaskFilter( mJobList->mFrameTree->selection()[0] );
        hhw->show();
    } else if( mJobViewerActions.contains(action) ) {
        mJobViewerActions[action]->view(mJobList->mJobTree->selection());
    } else if( mHostViewerActions.contains(action) ) {
        mHostViewerActions[action]->view( JobTaskList(mJobList->mFrameTree->selection()).hosts() );
    }
}

AssfreezerErrorMenu::AssfreezerErrorMenu(QWidget * parent, JobErrorList selection, JobErrorList all)
: AssfreezerMenu(parent)
, mSelection( selection )
, mAll( all )
, mClearSelected( 0 )
, mClearAll( 0 )
, mCopyText( 0 )
, mShowLog( 0 )
, mSelectHosts( 0 )
, mRemoveHosts( 0 )
, mClearHostErrorsAndOffline( 0 )
, mClearHostErrors( 0 )
, mShowErrorInfo( 0 )
{
}

void AssfreezerErrorMenu::setErrors( JobErrorList selection, JobErrorList allErrors )
{
	mSelection = selection;
	mAll = allErrors;
}

void AssfreezerErrorMenu::slotAboutToShow()
{
	clear();

	bool isJobListChild = parent()->inherits( "JobListWidget" );
	bool hasSelection = mSelection.size(), hasErrors = mAll.size();

	if( isJobListChild ) {
		mClearSelected = addAction("Clear Selected Errors");
		mClearSelected->setEnabled( hasSelection );

		mClearAll = addAction( "Clear All Errors" );
		mClearAll->setEnabled( hasErrors );
		addSeparator();
	}

	mCopyText = addAction("Copy Text of Selected Errors");
	mCopyText->setEnabled( hasSelection );

	mShowLog = addAction("Show Log...");
	mShowLog->setEnabled( mSelection.size() == 1 );

	mShowErrorInfo = addAction("Error Info...");
	mShowErrorInfo->setEnabled( mSelection.size() == 1 );

	if( isJobListChild ) {
		mSelectHosts = addAction("Select Hosts(s)");
		mSelectHosts->setEnabled( hasSelection );
	}

	addSeparator();

	if( isJobListChild ) {
		mRemoveHosts = addAction( "Exclude Selected Hosts From This Job" );
		mRemoveHosts->setEnabled( hasSelection );
	}

	if( isJobListChild ) {
		mClearHostErrors = addAction( "Clear All Errors From Host");
		mClearHostErrors->setEnabled( mSelection.size() == 1 );
		mClearHostErrorsAndOffline = addAction( "Clear All Errors From Host and Set It Offline" );
		mClearHostErrorsAndOffline->setEnabled( mSelection.size() == 1 );
	}
}

void AssfreezerErrorMenu::slotActionTriggered( QAction * action )
{
	if( !action ) return;

	if( (action==mClearAll) || ( action == mClearSelected ) ){
		if( action == mClearAll )
			mAll.setCleared( true ).commit();
		else
			mSelection.setCleared( true ).commit();
		JobListWidget * jlw = qobject_cast<JobListWidget*>(parent());
		if( jlw )
			jlw->refreshCurrentTab();
	}
	else if( action == mCopyText ) {
		QStringList errorList;
		foreach( JobError je, mSelection ) {
			QStringList parts;
			for(int n=0; n<4;n++ ) {
				switch( n ) {
					case 0: parts += je.host().name(); break;
					case 1: parts += je.lastOccurrence().toString(); break;
					case 2: parts += je.frames(); break;
					case 3: parts += je.message().replace( "\r", "" ).trimmed(); break;
				}
			}
			errorList += "[" + parts[0] + "; " + parts[1] + "; Frame " + parts[2] + "]\n" + parts[3];
		}
		QApplication::clipboard()->setText( errorList.join("\n"), QClipboard::Clipboard );
	} else if( action == mRemoveHosts ) {
		JobList jobs = mSelection.jobs().unique();
		if( jobs.size() == 1 ) {
			Job job = jobs[0];
			HostList exclude = JobErrorList(mSelection).hosts();
			HostList hl = hostListFromString(job.hostList());

			// If the host list is empty, set to all the host that can perform this jobtype
			if( hl.isEmpty() ) hl = job.jobType().service().hostServices().hosts();

			hl -= exclude;

			job.setHostList( hl.names().join(",") );
			job.commit();
		}
	} else if( action == mClearHostErrorsAndOffline ) {
		clearHostErrorsAndSetOffline( mSelection.hosts(), true);
	} else if( action == mClearHostErrors ) {
		clearHostErrorsAndSetOffline( mSelection.hosts(), false);
	} else if ( mSelection.size() > 0 && action == mShowLog ) {
		JobError je(mSelection[0]);
		JobAssignmentWindow * jaw = new JobAssignmentWindow();
		jaw->setJobAssignment( je.jobAssignment() );
		jaw->setWindowTitle("Job Log for errored task(s) "+je.frames());
		jaw->show();
	} else if ( action == mSelectHosts ) {
		JobListWidget * jlw = qobject_cast<JobListWidget*>(parent());
		if( jlw )
			createHostViewWithSelection( jlw, mSelection.hosts() );
	} else if( action == mShowErrorInfo ) {
		JobListWidget * jlw = qobject_cast<JobListWidget*>(parent());
		if( jlw )
			jlw->restorePopup( RecordPropValTree::showRecords( mSelection[0], this, User::hasPerms( "JobError", true ) ) );
	}
}

