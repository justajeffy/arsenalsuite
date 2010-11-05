
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of Arsenal.
 *
 * Arsenal is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Arsenal is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Arsenal; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#include <qdebug.h>

#include <qapplication.h>
#include <qaction.h>
#include <qinputdialog.h>
#include <qlabel.h>
#include <qmenubar.h>
#include <qmessagebox.h>
#include <qstatusbar.h>
#include <qtextstream.h>
#include <qtimer.h>
#include <qtooltip.h>
#include <qstackedwidget.h>
#include <qfiledialog.h>

#include <stdlib.h>

#include "blurqt.h"

#include "assfreezermenus.h"
#include "displayprefsdialog.h"
#include "hostlistwidget.h"
#include "hostservicematrix.h"
#include "userservicematrix.h"
#include "joblistwidget.h"
#include "jobfilteredit.h"
#include "projectweightdialog.h"
#include "settingsdialog.h"
#include "threadtasks.h"
#include "viewmanager.h"

#include "mainwindow.h"
#include "ui_aboutdialog.h"

MainWindow::MainWindow( QWidget * parent )
: QMainWindow( parent )
, mTabWidget( 0 )
, mStackedWidget( 0 )
, mCurrentView( 0 )
, mJobPage( 0 )
, mHostPage( 0 )
, mCounterLabel( 0 )
, mAdminEnabled( false )
, mCounterActive( false )
, mAutoRefreshTimer( 0 )
{
	FileExitAction = new QAction( "E&xit", this );
	HelpAboutAction = new QAction( "About...", this );
	HostServiceMatrixAction = new QAction( "Host Service Matrix...", this );
	UserServiceMatrixAction = new QAction( "User Service Matrix...", this );

	ViewHostsAction = new QAction( "View Hosts", this );
	ViewHostsAction->setCheckable( TRUE );
	ViewHostsAction->setIcon( QIcon( ":/images/view_hosts") );
	ViewJobsAction = new QAction( "View Jobs", this );
	ViewJobsAction->setCheckable( TRUE );
	ViewJobsAction->setChecked(true);
	ViewJobsAction->setIcon( QIcon( ":/images/view_jobs" ) );

	connect( ViewHostsAction, SIGNAL( toggled(bool) ), SLOT( hostViewActionToggled(bool) ) );
	connect( ViewJobsAction, SIGNAL( toggled(bool) ), SLOT( jobViewActionToggled(bool) ) );

	QActionGroup * viewAG = new QActionGroup( this );
	viewAG->addAction( ViewHostsAction );
	viewAG->addAction( ViewJobsAction );

	DisplayPrefsAction = new QAction( "Display Preferences...", this );
	SettingsAction = new QAction( "Settings...", this );
	AdminAction = new QAction( "Admin", this );
	
	AutoRefreshAction = new QAction( "Auto Refresh", this );
	AutoRefreshAction->setIcon( QIcon( ":/images/auto_refresh.png" ) );
	AutoRefreshAction->setCheckable( true );
	connect( AutoRefreshAction, SIGNAL( toggled( bool ) ), SLOT( setAutoRefreshEnabled( bool ) ) );
	mAutoRefreshTimer = new QTimer(this);
	connect( mAutoRefreshTimer, SIGNAL( timeout() ), SLOT( autoRefresh() ) );

	connect( HostServiceMatrixAction, SIGNAL( triggered(bool) ), SLOT( openHostServiceMatrixWindow() ) );
	connect( UserServiceMatrixAction, SIGNAL( triggered(bool) ), SLOT( openUserServiceMatrixWindow() ) );
	connect( HelpAboutAction, SIGNAL( triggered(bool) ), SLOT( showAbout() ) );
	connect( FileExitAction, SIGNAL( triggered(bool) ), qApp, SLOT( quit() ) );
	connect( SettingsAction, SIGNAL( triggered(bool) ), SLOT( showSettings() ) );
	connect( DisplayPrefsAction, SIGNAL( triggered(bool) ), SLOT( showDisplayPrefs() ) );
	connect( AdminAction, SIGNAL( triggered(bool) ), SLOT( enableAdmin() ) );

	/* Setup counter */
	mCounterLabel = new QLabel("", statusBar());
	mCounterLabel->setAlignment( Qt::AlignCenter );
	mCounterLabel->setMinimumWidth(350);
	mCounterLabel->setMaximumHeight(20);
	statusBar()->addPermanentWidget( mCounterLabel );

	mFarmStatusLabel = new QLabel("", statusBar());
	statusBar()->insertPermanentWidget( 0, mFarmStatusLabel );

	/* Set up MainWindow stuff */
	IniConfig & c( config() );
	c.pushSection( "Assfreezer" );
	QString cAppName = c.readString("ApplicationName", "AssFreezer");
	setWindowTitle(cAppName+" - Version " + VERSION);
	setWindowIcon( QIcon(":/images/"+cAppName+"Icon.png" ) );

	Toolbar = new QToolBar( this );
	Toolbar->setIconSize( QSize( 20, 20 ) );
	addToolBar( Toolbar );

	QMenuBar * mb = menuBar();
	mFileMenu = mb->addMenu( "&File" );
	mFileMenu->addAction( FileExitAction );

	mToolsMenu = mb->addMenu( "&Tools" );
    mToolsMenu->setObjectName( "Assfreezer_Tools_Menu" );
    connect( mToolsMenu, SIGNAL( aboutToShow() ), SLOT( populateToolsMenu() ) );

	mOptionsMenu = mb->addMenu( "&Options" );
	connect( mOptionsMenu, SIGNAL( aboutToShow() ), SLOT( populateViewMenu() ) );

	mViewMenu = mb->addMenu( "&View" );
//	connect( mViewMenu, SIGNAL( aboutToShow() ), SLOT( populateWindowMenu() ) );
	mViewMenu->addAction( ViewJobsAction );
	mViewMenu->addAction( ViewHostsAction );
	mViewMenu->addSeparator();
	mNewJobViewAction = mViewMenu->addAction( "New &Job View" );
	mNewJobViewAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_T ) );
	mNewHostViewAction = mViewMenu->addAction( "New &Host View" );
	mNewHostViewAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_H ) );
	mRestoreViewMenu = mViewMenu->addMenu( "Rest&ore View" );

	connect( mRestoreViewMenu, SIGNAL( aboutToShow() ), SLOT( populateRestoreViewMenu() ) );
	connect( mRestoreViewMenu, SIGNAL( triggered( QAction * ) ), SLOT( restoreViewActionTriggered( QAction * ) ) );

	mViewMenu->addSeparator();
	mSaveViewAsAction = mViewMenu->addAction( "Clone Current View As..." );
	mCloseViewAction = mViewMenu->addAction( "&Close Current View" );
	mCloseViewAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_C ) );
	QAction * renameViewAction = mViewMenu->addAction( "Re&name Current View" );
	mMoveViewLeftAction = mViewMenu->addAction( "Move Current View &Left" );
	mMoveViewLeftAction->setShortcut( QKeySequence( Qt::CTRL + Qt::SHIFT + Qt::Key_Left ) );
	mMoveViewRightAction = mViewMenu->addAction( "Move Current View &Right" );
	mMoveViewRightAction->setShortcut( QKeySequence( Qt::CTRL + Qt::SHIFT + Qt::Key_Right ) );

    QAction * mSaveViewToFileAction = mViewMenu->addAction( "Save View To &File" );
    mSaveViewToFileAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_S ) );

    QAction * mLoadViewFromFileAction = mViewMenu->addAction( "Load View fr&om File" );
    mLoadViewFromFileAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_O ) );

	connect( mNewJobViewAction, SIGNAL( triggered(bool) ), SLOT( createJobView() ) );
	connect( mNewHostViewAction, SIGNAL( triggered(bool) ), SLOT( createHostView() ) );
	connect( mSaveViewAsAction, SIGNAL( triggered(bool) ), SLOT( saveCurrentViewAs() ) );
	connect( mCloseViewAction, SIGNAL( triggered(bool) ), SLOT( closeCurrentView() ) );
	connect( mMoveViewLeftAction, SIGNAL( triggered(bool) ), SLOT( moveCurrentViewLeft() ) );
	connect( mMoveViewRightAction, SIGNAL( triggered(bool) ), SLOT( moveCurrentViewRight() ) );
	connect( renameViewAction, SIGNAL( triggered(bool) ), SLOT( renameCurrentView() ) );

	connect( mSaveViewToFileAction, SIGNAL( triggered(bool) ), SLOT( saveCurrentViewToFile() ) );
	connect( mLoadViewFromFileAction, SIGNAL( triggered(bool) ), SLOT( loadViewFromFile() ) );

    mViewMenu->addSeparator();
    mFilterViewAction = mViewMenu->addAction( "Show &Filter" );
	mFilterViewAction->setCheckable( true );
	mFilterViewAction->setChecked( true );
	//mFilterViewAction->setChecked( ini.readBool( "FilterEnabled", false ) );
	mFilterViewAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_F ) );

	connect( mFilterViewAction, SIGNAL( triggered(bool) ), SLOT( toggleFilter(bool) ) );

	mHelpMenu = mb->addMenu( "&Help" );
	mHelpMenu->addAction( HelpAboutAction );

	QPalette p = palette();
	QColor fg(155,207,226), bg(8,5,76);

	IniConfig & ini = ::userConfig();

	ini.pushSection("Assfreezer_Preferences");

	options.mHostColors = new ViewColors("HostView");
	options.mHostColors->mColors
		<< ColorOption( "Default", fg, bg )
		<< ColorOption( "Ready" )
		<< ColorOption( "Assigned", QColor(47,191,255) )
		<< ColorOption( "Busy", QColor(47,191,255) )
		<< ColorOption( "Copy", QColor(47,191,255) )
		<< ColorOption( "Restart" )
		<< ColorOption( "Client-Update" )
		<< ColorOption( "Offline", QColor(125,122,156) );

	options.mHostColors->readColors();

	options.mJobColors = new ViewColors("JobView");
	options.mJobColors->mColors
		<< ColorOption( "Default", fg, bg )
		<< ColorOption( "Submit", QColor(51,49,91) )
		<< ColorOption( "Verify", QColor(51,49,91) )
		<< ColorOption( "Ready", fg )
		<< ColorOption( "Started", QColor(47,191,255) )
		<< ColorOption( "Suspended", QColor(164,141,199) )
		<< ColorOption( "Holding", QColor(164,141,199) )
		<< ColorOption( "Done", QColor(125,122,156) );
	
	options.mFrameColors = new ViewColors("FrameView");
	options.mFrameColors->mColors
		<< ColorOption( "Default", fg, bg )
		<< ColorOption( "New" )
		<< ColorOption( "Assigned", fg )
		<< ColorOption( "Busy", QColor(47,191,255) )
		<< ColorOption( "Done", QColor(125,122,156) );
	
	options.mErrorColors = new ViewColors("ErrorView");
	options.mErrorColors->mColors
		<< ColorOption( "Default", fg, bg );

	options.mJobColors->readColors();
	options.mFrameColors->readColors();
	options.mErrorColors->readColors();

	options.appFont = ini.readFont( "AppFont" );
	options.jobFont = ini.readFont( "JobFont" );
	options.frameFont = ini.readFont( "FrameFont" );
	options.summaryFont = ini.readFont( "SummaryFont" );
	options.frameCyclerPath = ini.readString( "FrameCyclerPath" );
	options.frameCyclerArgs = ini.readString( "FrameCyclerArgs" );

	options.mRefreshInterval = ini.readInt( "AutoRefreshIntervalMinutes", 5 );
	options.mAutoRefreshOnWindowActivation = ini.readBool( "AutoRefreshOnWindowActivation", true );
	options.mRefreshOnViewChange = ini.readBool( "RefreshOnViewChange", options.mAutoRefreshOnWindowActivation );
	setAutoRefreshEnabled( ini.readBool( "AutoRefreshEnabled", false ) );
	options.mCounterRefreshInterval = ini.readInt( "CounterRefreshIntervalSeconds", 30 );
	options.mLimit = ini.readInt( "QueryLimit", 1000 );
	ini.popSection();

	applyOptions();

	restoreViews();

	setCounterState(true);

}

MainWindow::~MainWindow()
{
	FreezerCore::instance()->cancelObjectTasks(this);
}

void MainWindow::closeEvent( QCloseEvent * ce )
{
	IniConfig & ini = userConfig();
	ini.pushSection( "MainWindow" );
	ini.writeString( "FrameGeometry", QString("%1,%2,%3,%4").arg( pos().x() ).arg( pos().y() ).arg( size().width() ).arg( size().height() ) );
	ini.popSection();
	QMainWindow::closeEvent(ce);

	options.mJobColors->writeColors();
	options.mHostColors->writeColors();
	options.mFrameColors->writeColors();
	options.mErrorColors->writeColors();

	ini.pushSection("Assfreezer_Preferences" );
	ini.writeFont( "AppFont", options.appFont );
	ini.writeFont( "JobFont", options.jobFont );
	ini.writeFont( "FrameFont", options.frameFont );
	ini.writeFont( "SummaryFont", options.summaryFont );
	ini.writeString( "FrameCyclerPath", options.frameCyclerPath );
	ini.writeString( "FrameCyclerArgs", options.frameCyclerArgs );
	ini.writeBool( "AutoRefreshEnabled", AutoRefreshAction->isChecked() );
	ini.writeInt( "AutoRefreshIntervalMinutes", options.mRefreshInterval );
	ini.writeBool( "AutoRefreshOnWindowActivation", options.mAutoRefreshOnWindowActivation );
	ini.writeBool( "RefreshOnViewChange", options.mRefreshOnViewChange );
	ini.writeInt( "CounterRefreshIntervalSeconds", options.mCounterRefreshInterval );
	ini.writeInt( "QueryLimit", options.mLimit );
	ini.popSection();

	ini.pushSection("Assfreezer");
	ini.popSection();
	
	saveViews();
}

bool MainWindow::event( QEvent * event )
{
	if( event->type() == QEvent::WindowActivate && autoRefreshOnWindowActivation() )
		autoRefresh();

	switch( event->type() ) {
		case COUNTER:
		{
			CounterTask * ct = (CounterTask*)event;
			CounterState & cs = ct->mReturn;
			QString counterText;
			QTextStream ts( &counterText, QIODevice::WriteOnly );
			ts << "<b>Hosts</b>( " << cs.hostsTotal << ", " << cs.hostsActive <<", "<< cs.hostsReady;
			ts << " )   <b>Jobs</b>( "<< cs.jobsTotal << ", " << cs.jobsActive << ", " << cs.jobsDone << " )";
			mCounterLabel->setText( counterText );
			mCounterLabel->setToolTip( "Hosts( Total, Active, Ready )  Jobs( Total, Active, Done )"  );
			updateFarmStatus( ct->mManagerService );
			QTimer::singleShot( options.mCounterRefreshInterval * 1000, this, SLOT( updateCounter() ) );
			break;
		}
		default:
			break;
	}
	return QMainWindow::event(event);
}

void MainWindow::keyPressEvent( QKeyEvent * event )
{
	if( event->key() == Qt::Key_F5 ) {
		if( mCurrentView )
			mCurrentView->refresh();
		event->accept();
	} else
		event->ignore();
}

void MainWindow::saveViews()
{
	IniConfig & ini = userConfig();
	ini.pushSection("Assfreezer_Open_Views");
	ini.writeInt("ViewCount",mViews.size());
	ini.writeString("CurrentView",mCurrentView ? mCurrentView->viewName() : QString());
	LOG_5( "Saving " + QString::number( mViews.size() ) + " views" );
	int i = 0;
	foreach( AssfreezerView * view, mViews ) {
		++i;
		LOG_5( "Saving View " + view->viewName() );
		ini.writeString( QString("ViewName%1").arg(i), view->viewName() );
		ini.pushSection("View_" + view->viewName());
		view->save(ini);
		ini.popSection();
	}
	ini.popSection();

	ini.pushSection("Assfreezer_Saved_Views");
	ViewManager::instance()->writeSavedViews(ini);
	ini.popSection();
}

void MainWindow::saveView( AssfreezerView * view )
{
	LOG_5( "Saving View " + view->viewName() );
	IniConfig & ini = userConfig();
	ini.pushSection("View_" + view->viewName());
	view->save(ini);
	ini.popSection();
}

void MainWindow::restoreViews()
{
	IniConfig & ini = userConfig();

	ini.pushSection("Assfreezer_Saved_Views");
	ViewManager::instance()->readSavedViews(ini);
	ini.popSection();

	AssfreezerView * currentView = 0;
	ini.pushSection("Assfreezer_Open_Views");
	QString currentViewName = ini.readString("CurrentView");
	int viewCount = ini.readInt("ViewCount");
	for( int i = 1; i <= viewCount; ++i ) {
		QString viewName = ini.readString(QString("ViewName%1").arg(i));
		if( viewName.isEmpty() ) continue;
		AssfreezerView * view = restoreSavedView( viewName, false );
		if( !currentView || viewName == currentViewName )
			currentView = view;
	}

	ini.popSection();

	// testing
	if( mViews.size() == 0 ) {
		insertView(new JobListWidget(this));
		insertView(new HostListWidget(this));
	}
	
	if( currentView )
		setCurrentView(currentView);
	checkViewModeChange();
}

AssfreezerView * MainWindow::restoreSavedView( const QString & viewName, bool updateWindow )
{
	IniConfig & ini = userConfig();
	ini.pushSection("View_" + viewName);
	AssfreezerView * view = restoreView( ini, viewName, updateWindow );
	ini.popSection();
	return view;
}

AssfreezerView * MainWindow::restoreView( IniConfig & viewDesc, const QString & viewName, bool updateWindow )
{
	QString type = viewDesc.readString( "ViewType" );
	LOG_5( "Restoring View " + viewName + " type: " + type );
	AssfreezerView * view = 0;
	if( type == "HostList" )
		view = new HostListWidget(this);
	else if( type == "JobList" )
		view = new JobListWidget(this);
	if( view ) {
        view->setViewConfig( viewDesc );
		view->setViewName( viewName );
		view->restore(viewDesc);
		insertView(view,updateWindow);
	} else
		LOG_1( "Unable to create view of type: " + type );
	return view;
}

void MainWindow::cloneCurrentView()
{
	if( mCurrentView )
		cloneView(mCurrentView);
}

void MainWindow::cloneView( AssfreezerView * view )
{
	IniConfig empty;
	view->save(empty);
	restoreView(empty, view->viewName());
}

void MainWindow::insertView( AssfreezerView * view, bool checkViewModeCheckCurrent )
{
	mViews += view;

	// Keep pointers to the first job page and first host page
	if( !mJobPage && view->inherits( "JobListWidget" ) )
		mJobPage = qobject_cast<JobListWidget*>(view);

	if( !mHostPage && view->inherits( "HostListWidget" ) )
		mHostPage = qobject_cast<HostListWidget*>(view);

	if( checkViewModeCheckCurrent ) {
		if( !checkViewModeChange() ) {
			if( mStackedWidget ) {
				mStackedWidget->addWidget(view);
			} else if( mTabWidget ) {
				LOG_3( "Adding tab for view: " + view->viewName() );
				mTabWidget->addTab( view, view->viewName() );
			}
		}
		if( !mCurrentView ) setCurrentView( view );
	}
}

bool MainWindow::checkViewModeChange()
{
	bool needTabs = mViews.size() > 2 || (mViews.size() == 2 && (!mHostPage || !mJobPage));
	if( needTabs && !mTabWidget )
		setupTabbedView();
	else if( !needTabs && !mStackedWidget && mViews.size() )
		setupStackedView();
	else
		return false;
	repopulateToolBar();
	return true;
}

void MainWindow::removeView( AssfreezerView * view )
{
	mViews.removeAll( view );
	// Remove the view settings from the ini file if it's not a saved view
	// since all open views will be resaved on close
	if( !ViewManager::instance()->savedViews().contains( view->viewName() ) ) {
		IniConfig & ini = userConfig();
		ini.removeSection( "View_" + view->viewName() );
	}
	if( view == mCurrentView )
		setCurrentView( mViews.size() ? mViews[0] : 0 );
	if( mStackedWidget )
		mStackedWidget->removeWidget(view);
	if( mTabWidget )
		mTabWidget->removeTab(mTabWidget->indexOf(view));
	if( view == mJobPage || view == mHostPage ) {
		if( mJobPage == view ) mJobPage = 0;
		if( mHostPage == view ) mHostPage = 0;
		foreach( AssfreezerView * view, mViews ) {
			if( !mJobPage && view->inherits( "JobListWidget" ) ) mJobPage = qobject_cast<JobListWidget*>(view);
			if( !mHostPage && view->inherits( "HostListWidget" ) ) mHostPage = qobject_cast<HostListWidget*>(view);
		}
	}
	delete view;
	QTimer::singleShot( 0, this, SLOT( checkViewModeChange() ) );
}

void MainWindow::currentTabChanged( int index )
{
	setCurrentView( qobject_cast<AssfreezerView*>(mTabWidget->widget(index)) );
}

void MainWindow::setCurrentView( AssfreezerView * view )
{
	if( view == mCurrentView ) return;
	
	setUpdatesEnabled( false );
	if( mCurrentView ) {
		disconnect( mCurrentView, SIGNAL( statusBarMessageChanged( const QString & ) ), statusBar(), SLOT( showMessage( const QString & ) ) );
		QToolBar * tb = mCurrentView->toolBar(this);
		if( tb ) tb->hide();
	}

	mCurrentView = view;
	if( mCurrentView ) {
		if( mStackedWidget && mCurrentView != mStackedWidget->currentWidget() )
			mStackedWidget->setCurrentWidget( mCurrentView );
		else if( mTabWidget && mCurrentView != mTabWidget->currentWidget() )
			mTabWidget->setCurrentWidget( mCurrentView );
		QString currentMessage = view->statusBarMessage();
		LOG_5( "currentMessage: " + currentMessage );
		if( currentMessage.isEmpty() )
			statusBar()->clearMessage();
		else
			statusBar()->showMessage(currentMessage);
		connect( view, SIGNAL( statusBarMessageChanged( const QString & ) ), statusBar(), SLOT( showMessage( const QString & ) ) );
		QToolBar * tb = mCurrentView->toolBar(this);
		if( tb ) {
			addToolBar(tb);
			tb->show();
		}
		bool isHostView = view->inherits("HostListWidget");
		if( mStackedWidget ) {
			ViewJobsAction->setChecked(!isHostView);
			ViewHostsAction->setChecked(isHostView);
		}

        emit currentViewChanged( mCurrentView );

		// Always refresh the first time a view is shown.
		if( options.mRefreshOnViewChange || mCurrentView->refreshCount() == 0 )
			mCurrentView->refresh();
	} else
		statusBar()->clearMessage();

	mMoveViewLeftAction->setEnabled( mTabWidget && (mTabWidget->currentIndex() > 0) );
	mMoveViewRightAction->setEnabled( mTabWidget && (mTabWidget->currentIndex() < mTabWidget->count() - 1) );

	setUpdatesEnabled( true );
}

void MainWindow::showNextView()
{
    if( mTabWidget && mTabWidget->count() > 1 ) {
        int index = (mTabWidget->currentIndex() + 1) % mTabWidget->count();
        setCurrentView( qobject_cast<AssfreezerView*>(mTabWidget->widget(index)) );
   }
}

void MainWindow::setupStackedView()
{
	mStackedWidget = new QStackedWidget(this);
	disconnect( mTabWidget, SIGNAL( currentChanged(int) ), this, 0 );
	foreach( AssfreezerView * view, mViews ) {
		if( mTabWidget ) mTabWidget->removeTab(mTabWidget->indexOf(view));
		mStackedWidget->addWidget(view);
	}
	setCentralWidget(mStackedWidget);
	if( mCurrentView )
		mStackedWidget->setCurrentWidget( mCurrentView );
	mTabWidget = 0;
}

void MainWindow::setupTabbedView()
{
	mTabWidget = new QTabWidget(this);
	mTabWidget->installEventFilter(this);
	foreach( AssfreezerView * view, mViews ) {
		if( mStackedWidget )
			mStackedWidget->removeWidget(view);
		mTabWidget->addTab( view, view->viewName() );
	}
	if( mCurrentView )
		mTabWidget->setCurrentWidget( mCurrentView );
	connect( mTabWidget, SIGNAL( currentChanged(int) ), SLOT( currentTabChanged(int) ) );
	setCentralWidget( mTabWidget );
	mStackedWidget = 0;
}

void MainWindow::repopulateToolBar()
{
	Toolbar->clear();
	if( mStackedWidget ) {
		Toolbar->addAction( ViewHostsAction );
		Toolbar->addAction( ViewJobsAction );
		Toolbar->addSeparator();
		if( mCurrentView ) {
			bool isHostView = mCurrentView->inherits("HostListWidget");
			ViewJobsAction->setChecked(!isHostView);
			ViewHostsAction->setChecked(isHostView);
		}
	}
	Toolbar->addAction( AutoRefreshAction );
}

void MainWindow::createJobView()
{
	AssfreezerView * view = new JobListWidget(this);
    renameView(view);
	insertView(view);
}

void MainWindow::createHostView()
{
	AssfreezerView * view = new HostListWidget(this);
	insertView(view);
}

void MainWindow::closeCurrentView()
{
	if( mCurrentView )
		removeView( mCurrentView );
}

void MainWindow::saveViewToFile( AssfreezerView * view )
{
    QString fileName = QFileDialog::getSaveFileName(this, tr("Save View to File"),
                                                    "",
                                                    tr("ViewConfig (*.ini)"));
    IniConfig newConfig = IniConfig(fileName);
    newConfig.pushSection("View_SavedToFile");
    view->save(newConfig);
    newConfig.popSection();
    newConfig.writeToFile();
}

void MainWindow::saveCurrentViewToFile()
{
    if( mCurrentView )
        saveViewToFile( mCurrentView );
}

void MainWindow::toggleFilter(bool enable) {
	if ( mCurrentView && mCurrentView->inherits( "JobListWidget" ) ) {
		JobListWidget * jlw = qobject_cast<JobListWidget*>(mCurrentView);
		jlw->mJobTree->enableFilterWidget(enable);
		jlw->mFrameTree->enableFilterWidget(enable);
		jlw->mErrorTree->enableFilterWidget(enable);
	}

	if ( mCurrentView && mCurrentView->inherits( "HostListWidget" ) ) {
		HostListWidget * hlw = qobject_cast<HostListWidget*>(mCurrentView);
		hlw->mHostTree->enableFilterWidget(enable);
	}
}

void MainWindow::loadViewFromFile()
{
    QString fileName = QFileDialog::getOpenFileName(this, tr("Load View From"),
                                                    "",
                                                    tr("ViewConfig (*.ini)"));
    IniConfig newConfig(fileName);
    newConfig.pushSection("View_SavedToFile");
    QString viewName = newConfig.readString( "ViewName" );
    restoreView(newConfig, viewName);
}

void MainWindow::renameCurrentView()
{
	if( mCurrentView ) renameView( mCurrentView );
}

// Pops up dialog to prompt user
void MainWindow::renameView( AssfreezerView * view )
{
	while( 1 ) {
		bool okay;
		QString newViewName = QInputDialog::getText( this, "Rename View", "Enter new view name", QLineEdit::Normal, view->viewName(), &okay );
		if( okay ) {
			if( newViewName.isEmpty() ) {
				QMessageBox::warning( this, "Invalid View Name", "View name cannot be empty" );
				continue;
			}

			bool viewOpen = false;
			foreach( AssfreezerView * v, mViews )
				if( v != view && v->viewName() == newViewName ) {
					viewOpen = true;
					break;
				}

			if( viewOpen ) {
				QMessageBox::warning( this, "Invalid View Name", "There is already an open view named '" + newViewName + "'" );
				continue;
			}

			view->setViewName( newViewName );

			if( mTabWidget ) {
				int idx = mTabWidget->indexOf(view);
				mTabWidget->setTabText(idx,newViewName);
			}
		}
		break;
	}
}

void MainWindow::saveCurrentViewAs()
{
	saveViewAs( mCurrentView );
}

void MainWindow::saveViewAs( AssfreezerView * view )
{
	while( 1 ) {
		bool okay;
		QString newViewName = QInputDialog::getText( this, "Save View As...", "Enter name to save view as", QLineEdit::Normal, view->viewName(), &okay );
		if( okay ) {
			if( newViewName.isEmpty() ) {
				QMessageBox::warning( this, "Invalid View Name", "View name cannot be empty" );
				continue;
			}

			bool viewOpen = false;
			foreach( AssfreezerView * v, mViews )
				if( v != view && v->viewName() == newViewName ) {
					viewOpen = true;
					break;
				}

			if( viewOpen ) {
				QMessageBox::warning( this, "Invalid View Name", "There is already an open view named '" + newViewName + "'" );
				continue;
			}

			if( ViewManager::instance()->savedViews().contains( newViewName ) ) {
				QMessageBox::StandardButton result = QMessageBox::question( this, "Overwrite '" + newViewName + "'?", "There is already a saved view named '" + newViewName + "'.  Do you wish to overwrite it?", QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel );
				if( result == QMessageBox::Cancel )
					return;

				if( result == QMessageBox::No )
					continue;
			}
			view->setViewName( newViewName );

			if( mTabWidget ) {
				int idx = mTabWidget->indexOf(view);
				mTabWidget->setTabText(idx,newViewName);
			}
		
			saveView( view );
			ViewManager::instance()->addSavedView( newViewName );
		}
		break;
	}
	
}

void MainWindow::moveViewLeft( AssfreezerView * view )
{
	if( view ) {
		int idx = mViews.indexOf( view );
		if( idx > 0 ) {
			mViews.removeAt(idx);
			mViews.insert(idx-1,view);
			if( mTabWidget ) {
				bool sb = mTabWidget->signalsBlocked();
				mTabWidget->blockSignals(true);
				mTabWidget->removeTab(idx);
				mTabWidget->insertTab(idx-1,view,view->viewName());
				if( view == mCurrentView )
					mTabWidget->setCurrentWidget(view);
				mTabWidget->blockSignals(sb);
			}
		}
	}

}

void MainWindow::moveViewRight( AssfreezerView * view )
{
	if( view ) {
		int idx = mViews.indexOf( view );
		if( idx < mViews.size() - 1 ) {
			mViews.removeAt(idx);
			mViews.insert(idx+1,view);
			if( mTabWidget ) {
				bool sb = mTabWidget->signalsBlocked();
				mTabWidget->blockSignals(true);
				mTabWidget->removeTab(idx);
				mTabWidget->insertTab(idx+1,view,view->viewName());
				if( view == mCurrentView )
					mTabWidget->setCurrentWidget(view);
				mTabWidget->blockSignals(sb);
			}
		}
	}
}

void MainWindow::moveCurrentViewLeft()
{
	moveViewLeft( mCurrentView );
}

void MainWindow::moveCurrentViewRight()
{
	moveViewRight( mCurrentView );
}

void MainWindow::populateToolsMenu()
{
    if( User::hasPerms( "HostService", true ) )
        mToolsMenu->addAction( HostServiceMatrixAction );
    if( User::hasPerms( "UserService", true ) )
        mToolsMenu->addAction( UserServiceMatrixAction );

    mToolsMenu->addAction( "Project Weighting...", this, SLOT( showProjectWeightDialog() ) );

    AssfreezerMenuFactory::instance()->aboutToShow(mToolsMenu);

    // We only need to populate this menu once
    mToolsMenu->disconnect( this, SLOT( populateToolsMenu() ) );
}

void MainWindow::populateViewMenu()
{
	mOptionsMenu->clear();

	mOptionsMenu->addAction( AutoRefreshAction );

	if( mCurrentView )
		mCurrentView->populateViewMenu( mOptionsMenu );

	mOptionsMenu->addSeparator();

	mOptionsMenu->addAction( DisplayPrefsAction );
	mOptionsMenu->addAction( SettingsAction );
}

void MainWindow::populateRestoreViewMenu()
{
	mRestoreViewMenu->clear();
	QStringList views = ViewManager::instance()->savedViews();
	views.sort();
	foreach( QString viewName, views )
		mRestoreViewMenu->addAction( viewName );	
}

void MainWindow::restoreViewActionTriggered(QAction * action)
{
	restoreSavedView( action->text() );
}

void MainWindow::hostViewActionToggled(bool en)
{
	if( en ) showHostView();
}

void MainWindow::jobViewActionToggled(bool en)
{
	if( en ) showJobView();
}

void MainWindow::showHostView()
{
	if( !mHostPage )
		insertView( new HostListWidget(this) );
	setCurrentView( mHostPage );
	ViewHostsAction->setChecked(true);
}

void MainWindow::showJobView()
{
	if( !mJobPage )
		insertView( new JobListWidget(this) );
	setCurrentView( mJobPage );
	ViewJobsAction->setChecked(true);
}

void MainWindow::showProjectWeightDialog()
{
	(new ProjectWeightDialog(this))->show();
}

bool MainWindow::autoRefreshEnabled() const
{
	return AutoRefreshAction->isChecked();
}

bool MainWindow::autoRefreshOnWindowActivation() const
{
	return options.mAutoRefreshOnWindowActivation;
}

void MainWindow::setAutoRefreshEnabled( bool enabled )
{
	if( AutoRefreshAction->isChecked() != enabled ) AutoRefreshAction->setChecked( enabled );

	if( enabled )
		mAutoRefreshTimer->start( options.mRefreshInterval * 60 * 1000 );
	else
		mAutoRefreshTimer->stop();
}

void MainWindow::setAutoRefreshOnWindowActivation( bool enabled )
{
	options.mAutoRefreshOnWindowActivation = enabled;
}

void MainWindow::autoRefresh()
{
	if( mCurrentView ) mCurrentView->refresh();
	// Restart the timer, since this could have been called
	// from mainwindow activation or elsewhere.
	setAutoRefreshEnabled( AutoRefreshAction->isChecked() );
}

void MainWindow::openHostServiceMatrixWindow()
{
	(new HostServiceMatrixWindow(this))->show();
}

void MainWindow::openUserServiceMatrixWindow()
{
	(new UserServiceMatrixWindow(this))->show();
}

// Turns the update counter on or off
void MainWindow::setCounterState( bool cs )
{
	if( cs != mCounterActive ) {
		mCounterActive = cs;
		if( cs ) updateCounter();
	}
}

void MainWindow::showDisplayPrefs()
{
	DisplayPrefsDialog opts( this );
	connect( &opts, SIGNAL( apply() ), SLOT( applyOptions() ) );
	if( opts.exec() == QDialog::Accepted )
		applyOptions();
}

void MainWindow::showSettings()
{
	SettingsDialog opts( this );
	connect( &opts, SIGNAL( apply() ), SLOT( applyOptions() ) );
	if( opts.exec() == QDialog::Accepted )
		applyOptions();
}

void MainWindow::applyOptions()
{
	bool ue = updatesEnabled();
	setUpdatesEnabled(false);
	QApplication * app = (QApplication*)QApplication::instance();
	app->setFont( options.appFont );
	foreach( AssfreezerView * view, mViews )
		view->applyOptions();

	// Reset the interval
	if( AutoRefreshAction->isChecked() )
		setAutoRefreshEnabled( true );

	setUpdatesEnabled(ue);
}

void MainWindow::enableAdmin()
{
	mAdminEnabled=true;
}

void MainWindow::showAbout()
{
	QDialog dialog( this );
	Ui::AboutDialog ui;
	ui.setupUi( &dialog );
	dialog.exec();
}

void MainWindow::updateCounter()
{
	if( mCounterActive ) {
		FreezerCore::addTask( new CounterTask( this ) );
		FreezerCore::wakeup();
	}
}

void MainWindow::showTabMenu( const QPoint & pos, AssfreezerView * view )
{
	QMenu * menu = new QMenu(this);
	QAction * close = menu->addAction( "&Close View" );
	QAction * moveLeft = menu->addAction( "Move View &Left" );
	QAction * moveRight = menu->addAction( "Move View &Right" );
	QAction * rename = menu->addAction( "Re&name View" );
	QAction * result = menu->exec(pos);
    QAction * save = menu->addAction( "&Save View" );

	if( result == close ) {
		removeView(view);
	} else if( result == moveLeft ) {
		moveViewLeft( view );
	} else if( result == moveRight ) {
		moveViewRight( view );
	} else if( result == rename ) {
		renameView( view );
    } else if( result == save ) {
        saveViewToFile(view);
	}
}

class TabBarHack : public QTabWidget { public: QTabBar * tb() { return tabBar(); } };

bool MainWindow::eventFilter( QObject * o, QEvent * event )
{
	QTabBar * tb = mTabWidget ? ((TabBarHack*)mTabWidget)->tb() : 0;
	if( tb && o == mTabWidget && event->type() == QEvent::MouseButtonPress ) {
		QMouseEvent * mouseEvent = (QMouseEvent*)event;
		if( mouseEvent->button() == Qt::RightButton ) {
			for( int i = tb->count()-1; i >= 0; --i ) {
				QPoint tabBarPos = tb->mapFromParent(mouseEvent->pos());
				if( tb->tabRect(i).contains( tabBarPos ) ) {
					showTabMenu( mouseEvent->globalPos(), qobject_cast<AssfreezerView*>(mTabWidget->widget(i)) );
					break;
				}
			}
		}
	}
	return false;
}

void MainWindow::updateFarmStatus( const Service & managerService )
{
	if( managerService.isRecord() && managerService.enabled() ) {
		mFarmStatusLabel->setText( " Farm Status: <font color=\"green\">Online</font> " );
	} else {
		mFarmStatusLabel->setText( " Farm Status: <font color=\"red\">Offline</font> [" + managerService.description() + "] " );
	}
}

