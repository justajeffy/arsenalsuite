
#include <qapplication.h>
#include <qaction.h>
#include <qfileinfo.h>
#include <qinputdialog.h>
#include <qmainwindow.h>
#include <qmessagebox.h>
#include <qprocess.h>
#include <qsplitter.h>
#include <qtimer.h>
#include <qtoolbar.h>
#include <qclipboard.h>

#include <stdlib.h>

#include "blurqt.h"
#include "database.h"
#include "freezercore.h"
#include "path.h"
#include "process.h"

#include "jobbatch.h"
#include "jobcommandhistory.h"
#include "jobhistory.h"
#include "jobhistorytype.h"
#include "jobtype.h"
#include "projectstatus.h"
#include "service.h"
#include "user.h"

#include "busywidget.h"
#include "recordtreeview.h"
#include "recordfilterwidget.h"
#include "recordpropvaltree.h"

#include "assfreezermenus.h"
#include "batchsubmitdialog.h"
#include "hostlistwidget.h"
#include "imageview.h"
#include "items.h"
#include "jobfilteredit.h"
#include "joblistwidget.h"
#include "jobstatwidget.h"
#include "mainwindow.h"
#include "tabtoolbar.h"
#include "threadtasks.h"

#ifdef LoadImage
#undef LoadImage
#endif

JobTypeList JobListWidget::mJobTypeList;
ProjectList JobListWidget::mProjectList;

JobListWidget::JobListWidget( QWidget * parent )
: FreezerView( parent )
, mToolBar( 0 )
, mViewsInitialized( false )
, mJobTaskRunning( false )
, mQueuedJobRefresh( false )
, mFrameTask( 0 )
, mPartialFrameTask( 0 )
, mStaticDataRetrieved( false )
, mTaskListBusyWidget( 0 )
, mJobMenu( 0 )
, mStatusFilterMenu( 0 )
, mProjectFilterMenu( 0 )
, mJobTypeFilterMenu( 0 )
, mTaskMenu( 0 )
, mErrorMenu( 0 )
{
	setupUi(this);
}

JobListWidget::~JobListWidget()
{
}

QString JobListWidget::viewType() const
{
       return "JobList";
}

void JobListWidget::initializeViews()
{
    if( !mViewsInitialized ) {
        mViewsInitialized = true;

        mTabToolBar = new TabToolBar( mJobTabWidget, mImageView );

        RefreshAction = new QAction( "Refresh Job(s)", this );
        RefreshAction->setIcon( QIcon( ":/images/refresh" ) );

        KillAction = new QAction( "Remove Selected Jobs", this );
        KillAction->setIcon( QIcon( ":/images/kill" ) );
        PauseAction = new QAction( "Pause Selected Jobs", this );
        PauseAction->setIcon( QIcon( ":/images/pause" ) );
        ResumeAction = new QAction( "Resume Selected Jobs", this );
        ResumeAction->setIcon( QIcon( ":/images/resume" ) );
        RestartAction = new QAction( "Restart Job(s)", this );
        RestartAction->setIcon( QIcon( ":/images/restart" ) );
        ShowOutputAction = new QAction( "Show Output Directory", this );
        ShowOutputAction->setIcon( QIcon( ":/images/explorer" ) );
        ShowMineAction = new QAction( "View My Jobs", this );
        ShowMineAction->setCheckable( TRUE );
        ShowMineAction->setIcon( QIcon( ":/images/show_mine" ) );
        ClearErrorsAction = new QAction( "Clear Job Errors", this );
        ShowClearedErrorsAction = new QAction( "Show Cleared Errors", this );
        ShowClearedErrorsAction->setCheckable(true);
        ShowClearedErrorsAction->setChecked(false);
        connect( ShowClearedErrorsAction, SIGNAL( toggled( bool ) ), SLOT( refresh() ) );

        DependencyTreeEnabledAction = new QAction( "Show Dependency Tree", this );
        DependencyTreeEnabledAction->setCheckable( true );
		DependencyTreeEnabledAction->setIcon( QIcon(":/images/dependencytree") );
        connect( DependencyTreeEnabledAction, SIGNAL( toggled( bool ) ), SLOT( setDependencyTreeEnabled( bool ) ) );

        FilterAction = new QAction( "&Filter", this );
        FilterAction->setCheckable( TRUE );
		FilterAction->setIcon( QIcon( ":images/filter" ) );
		FilterAction->setShortcut( QKeySequence( Qt::CTRL + Qt::Key_F ) );
		connect( FilterAction, SIGNAL( triggered(bool) ), SLOT( toggleFilter(bool) ) );

        FilterClearAction = new QAction( "Clear Filters", this );
		FilterClearAction->setShortcut( QKeySequence( Qt::CTRL + Qt::SHIFT + Qt::Key_F ) );
		FilterClearAction->setIcon( QIcon( ":images/filterclear" ) );
		connect( FilterClearAction, SIGNAL( triggered(bool) ), SLOT( clearFilters() ) );

        NewViewFromSelectionAction = new QAction( "New View From Selection", this );
		NewViewFromSelectionAction->setIcon( QIcon( ":/images/newview" ) );
        connect( NewViewFromSelectionAction, SIGNAL( triggered(bool) ), SLOT( createNewViewFromSelection() ) );

        connect( RefreshAction, SIGNAL( triggered(bool) ), SLOT( refresh() ) );

        connect( RestartAction, SIGNAL( triggered(bool) ), SLOT( restartJobs() ) );
        connect( ResumeAction, SIGNAL( triggered(bool) ), SLOT( resumeJobs() ) );
        connect( PauseAction, SIGNAL( triggered(bool) ), SLOT( pauseJobs() ) );
        connect( KillAction, SIGNAL( triggered(bool) ), SLOT( deleteJobs() ) );
        connect( ShowMineAction, SIGNAL( toggled(bool) ), SLOT( showMine(bool) ) );
        connect( ShowOutputAction, SIGNAL( triggered(bool) ), SLOT( outputPathExplorer() ) );
        connect( ClearErrorsAction, SIGNAL( triggered(bool) ), SLOT( clearErrors() ) );

        connect( mJobTree, SIGNAL( selectionChanged(RecordList) ), SLOT( jobListSelectionChanged() ) );
        connect( mJobTree, SIGNAL( currentChanged( const Record & ) ), SLOT( currentJobChanged() ) );
        connect( mFrameTree, SIGNAL( currentChanged( const Record & ) ), SLOT( frameSelected(const Record &) ) );
        connect( mFrameTree,  SIGNAL( selectionChanged(RecordList) ), SLOT( frameListSelectionChanged() ) );
        connect( mImageView, SIGNAL( frameStatusChange(int,int) ), SLOT( setFrameCacheStatus(int,int) ) );

        mJobTree->setContextMenuPolicy( Qt::CustomContextMenu );
        mFrameTree->setContextMenuPolicy( Qt::CustomContextMenu );
        mErrorTree->setContextMenuPolicy( Qt::CustomContextMenu );

        connect( mJobTree, SIGNAL( customContextMenuRequested( const QPoint & ) ), SLOT( showJobPopup( const QPoint & ) ) );
        connect( mFrameTree, SIGNAL( customContextMenuRequested( const QPoint & ) ), SLOT( showFramePopup( const QPoint & ) ) );
        connect( mErrorTree,  SIGNAL( customContextMenuRequested( const QPoint & ) ), SLOT( showErrorPopup( const QPoint & ) ) );

        mJobTabWidget->setTabText(0, "&Frames");
        mJobTabWidget->setTabText(1, "&Errors");
        mJobTabWidget->setTabText(2, "&History");
        mJobTabWidget->setTabText(4, "Job &Settings");
        connect( mJobTabWidget, SIGNAL( currentChanged( int ) ), SLOT( currentTabChanged() ) );


        {
            JobModel * jm = new JobModel( mJobTree );
            jm->setAutoSort( true );
            mJobTree->setModel( jm );
            mJobTree->setItemDelegateForColumn( 2, new ProgressDelegate( mJobTree ) );
            mJobTree->setDragEnabled( true );
            mJobTree->setAcceptDrops( true );
            mJobTree->setDropIndicatorShown(true);
            connect( jm, SIGNAL( dependencyAdded( const QModelIndex & ) ), mJobTree, SLOT( expand( const QModelIndex & ) ) );
        }

        {
            //mErrorTree->setItemDelegate( new MultiLineDelegate( mErrorTree ) );
            mErrorTree->setUniformRowHeights( false );
            ErrorModel * em = new ErrorModel( mErrorTree );
            em->setAutoSort( true );
            mErrorTree->setModel( em );
            for( int i=0; i < em->columnCount(); i++ )
                mErrorTree->setColumnAutoResize(i,true);
        }

        {
            RecordSuperModel * fm = new RecordSuperModel( mFrameTree );
            new FrameTranslator( fm->treeBuilder() );
            fm->setAutoSort( true );
            mFrameTree->setModel( fm );
            mFrameTree->setItemDelegateForColumn( 3, new LoadedDelegate( mJobTree ) );
            mFrameTree->setItemDelegateForColumn( 4, new LoadedDelegate( mJobTree ) );
            for(int i=0; i < fm->columnCount(); i++)
                mFrameTree->setColumnAutoResize( i, true );
            mTaskListBusyWidget = new BusyWidget( mFrameTree, QPixmap( "images/rotating_head.png" ) );
            mTaskListBusyWidget->move(0,mFrameTree->header()->height()-5);
            mTaskListBusyWidget->hide();
        }

        mStatusFilterMenu = new StatusFilterMenu( this );
        mProjectFilterMenu = new ProjectFilterMenu( this );
        mJobTypeFilterMenu = new JobTypeFilterMenu( this );

        // Give default settings
        IniConfig empty;
        restore(empty);

        jobListSelectionChanged();
        FreezerCore::addTask( new StaticJobListDataTask( this ) );

        IniConfig & ini = viewConfig();
        setupJobView(mJobTree, ini);
        setupErrorView(mErrorTree, ini);
        setupFrameView(mFrameTree, ini);

        setDependencyTreeEnabled( ini.readBool( "DependencyTreeEnabled", false ), /* allowRefresh= */ false );

		FilterAction->setChecked( ini.readBool( "Filter", true ) );
		toggleFilter( FilterAction->isChecked() );

        QStringList sl = ini.readString( "JobSplitterPos" ).split(',');
        QList<int> vl;
        for( QStringList::Iterator it=sl.begin(); it!=sl.end(); ++it )
            vl += (*it).toInt();
        if( vl.size()!=2 ) {
            vl.clear();
            int h = height();
            if( h < 300 )
                vl << h << 0;
            else
                vl << (int)(h * .6) << (int)(h * .4);
        }

        mJobSplitter->setSizes( vl );

        QStringList frameSplitterSizes = ini.readString( "FrameSplitterPos","750,1100" ).split(',');
        QList<int> frameSplitterInts;
        for( QStringList::Iterator it=frameSplitterSizes.begin(); it!=frameSplitterSizes.end(); ++it )
            frameSplitterInts += (*it).toInt();
        mFrameSplitter->setSizes( frameSplitterInts );

        // Filter any empty entries.  And empty string split with ',' returns a string list with one empty entry
        mJobFilter.typeToShow = ini.readString( "TypeToShow" ).split(',',QString::SkipEmptyParts);
        mJobFilter.statusToShow =   ini.readString( "StatusToShow", "submit,verify,ready,holding,started,suspended,done" ).split(',',QString::SkipEmptyParts);

        mJobFilter.userList =       ini.readString( "UserList", "" ).split(',',QString::SkipEmptyParts);
        ShowMineAction->blockSignals(true);
        ShowMineAction->setChecked( !mJobFilter.userList.isEmpty() );
        ShowMineAction->blockSignals(false);

        mJobFilter.allProjectsShown = ini.readBool( "AllProjectsShown", false );
        if( ini.keys().contains( "VisibleProjects" ) ) {
            mJobFilter.visibleProjects = mProjectList.keyString().split(',',QString::SkipEmptyParts);
        } else {
            mJobFilter.hiddenProjects = ini.readString( "HiddenProjects", "" ).split(',',QString::SkipEmptyParts);
            if( mJobFilter.hiddenProjects.isEmpty() )
                mJobFilter.allProjectsShown = true;
        }
        mJobFilter.showNonProjectJobs = ini.readBool( "ShowNonProjectJobs", true );
        mJobFilter.mLimit = options.mLimit;
        applyOptions();
    }
}

void JobListWidget::save( IniConfig & ini )
{
    if( mViewsInitialized ) {
        ini.writeString("ViewType","JobList");
        saveJobView(mJobTree,ini);
        saveErrorView(mErrorTree,ini);
        saveFrameView(mFrameTree,ini);
        ini.writeString( "StatusToShow", mJobFilter.statusToShow.join(",") );
        ini.writeString( "UserList", mJobFilter.userList.join(",") );
        ini.writeString( "VisibleProjects", mJobFilter.visibleProjects.join(",") );
        ini.removeKey( "HiddenProjects" );
        ini.writeBool( "AllProjectsShown", mJobFilter.allProjectsShown );
        ini.writeBool( "ShowNonProjectJobs", mJobFilter.showNonProjectJobs );
        ini.writeString( "TypeToShow", mJobFilter.typeToShow.join(",") );
        ini.writeBool( "DependencyTreeEnabled", isDependencyTreeEnabled() );
        ini.writeBool( "Filter", FilterAction->isChecked() );
        // Save the splitter position by making a string of ints separated by commas
        // Output string
        QString jsps;
        // Use comma
        QList<int> list = mJobSplitter->sizes();
        // Stupid qsplitter doesn't return proper sizes if this tab hasn't been shown
        // It returns 12/12 or 13/13 in that case so we won't save
        if( list.size() == 2 && !(list[0] == list[1] && list[0] < 20)) {
            QStringList sizes;
            foreach( int i, list ) sizes += QString::number(i);
            ini.writeString( "JobSplitterPos", sizes.join(",") );
        }
        QStringList sizes;
        foreach( int i, mFrameSplitter->sizes() ) sizes += QString::number(i);
        ini.writeString( "FrameSplitterPos", sizes.join(",") );
    }
    FreezerView::save(ini);
}

void JobListWidget::restore( IniConfig & ini )
{
    FreezerView::restore(ini);
}

ProjectList JobListWidget::activeProjects()
{
	return mProjectList;
}

bool JobListWidget::isDependencyTreeEnabled() const
{
	return ((JobModel*)mJobTree->model())->isDependencyTreeEnabled();
}

void JobListWidget::setDependencyTreeEnabled( bool dte, bool allowRefresh )
{
	if( dte != isDependencyTreeEnabled() ) {
		((JobModel*)mJobTree->model())->setDependencyTreeEnabled( dte );

		DependencyTreeEnabledAction->setChecked( dte );
		mJobTree->setRootIsDecorated( dte );

		if( allowRefresh && dte ) refresh();
	}
}

bool JobListWidget::event( QEvent * event )
{
    if( event->type() == QEvent::Show ) {
        initializeViews();
    }
    return QWidget::event(event);
}

void JobListWidget::customEvent( QEvent * evt )
{
	switch( evt->type() ) {
		case JOB_LIST:
		{
			JobListTask * jlt = ((JobListTask*)evt);
			JobModel * jm = (JobModel*)mJobTree->model();

            JobList topLevelJobs = jlt->mReturn - jlt->mDependentJobs;
            JobList existing;
            QModelIndexList toRemove;

            GroupingTreeBuilder * gtb = qobject_cast<GroupingTreeBuilder*>(jm->treeBuilder());
            int topLevelDepth = 0;
            if( gtb && gtb->isGrouped() )
                topLevelDepth = 1;

            for( ModelIter it(jm,ModelIter::Filter(ModelIter::Recursive|ModelIter::DescendLoadedOnly)); it.isValid(); ++it ) {
                QModelIndex idx = *it;
                if( topLevelDepth == it.depth() ) {
                    Job j = jm->getRecord(idx);
                    if( !topLevelJobs.contains(j) )
                        toRemove += QPersistentModelIndex(idx);
                    else {
                        existing += j;
                        jm->updateIndex(idx);
                    }
                }
            }

            jm->remove(toRemove);
            JobList jobsToAdd = topLevelJobs - existing;
            LOG_5( "Appending " + QString::number(jobsToAdd.size()) + " jobs to the list" );
            jm->append( jobsToAdd );

            QMap<Record, JobServiceList> jobServicesByJob;
            if( jlt->mFetchJobServices ) {
                jobServicesByJob = jlt->mJobServices.groupedBy<Record,JobServiceList,uint,Job>( "fkeyjob" );
                LOG_5( QString("Got %1 services for %2 jobs").arg(jlt->mJobServices.size()).arg(jobServicesByJob.size()) );
			}

			QMap<uint,JobDepList> jobDepsByJob = jlt->mJobDeps.groupedBy<uint,JobDepList>("fkeyjob");

            for( ModelIter it(jm,ModelIter::Filter(ModelIter::Recursive|ModelIter::DescendLoadedOnly)); it.isValid(); ++it ) {
                Job j = jm->getRecord(*it);
                if( j.isRecord() ) {
                    JobDepList deps = jobDepsByJob[j.key()];
                    if( deps.size() )
                        jm->updateRecords( deps.deps(), *it, false );
                    if( jlt->mFetchJobServices ) {
                        // Update services
                        JobItem & ji = JobTranslator::data(*it);
                        if( jobServicesByJob.contains( ji.job ) ) {
                            ji.services = jobServicesByJob[j].services().services().join(",");
                            LOG_5( "Set Job " + j.name() + " services to " + ji.services );
                        } else
                            LOG_5( "No services found for " + j.name() );
                    }
                }
            }

            // clear out existing toolTip info first
            int numRows = jm->rowCount();
            for ( int row = 0; row < numRows; row++ ) {
                QModelIndex qmi = jm->index(row, 4);
                Job j = jm->getRecord(qmi);
                if( !j.isRecord() )
                    continue;
                JobItem & ji = JobTranslator::data(qmi);
                ji.userToolTip.clear();
                ji.projectToolTip.clear();
            }

            // Update slot use data for tooltips
            if( jlt->mFetchUserServices ) {
                // we store the pre-formatted tooltip in the model so
                // need to do that now..
                foreach( QString key, jlt->mUserServiceCurrent.keys() ) {
                    QString keyUser = key.section(":",0,0);
                    QString keyService = key.section(":",1,1);
                    QString toolTip = QString("%1 : %2").arg(keyService).arg(QString::number(jlt->mUserServiceCurrent[key]));
                    if( jlt->mUserServiceLimits.contains(key) )
                        toolTip += " / " + QString::number(jlt->mUserServiceLimits[key]);

                    toolTip += "\n";
                    //LOG_1( QString("append tooltip for %1 to %2").arg(keyUser).arg(toolTip) );

                    // iterate through the model and set as tooltip for all rows belonging to
                    // the user
                    int numRows = jm->rowCount();
                    for ( int row = 0; row < numRows; row++ ) {
                        QModelIndex qmi = jm->index(row, 4);
                        QString cell = jm->data( qmi ).toString();
                        //LOG_1( QString("row %1 has data %2").arg(QString::number(row)).arg(cell) );
                        if( keyUser == cell ) {
                            JobItem & ji = JobTranslator::data(qmi);
                            ji.userToolTip += toolTip;
                        }
                    }
                }
            }

            // Update slot use data for Project tooltips
            if( jlt->mFetchProjectSlots ) {
                // we store the pre-formatted tooltip in the model so
                // need to do that now..
                foreach( QString keyProject, jlt->mProjectSlots.keys() ) {
                    QString value = jlt->mProjectSlots[keyProject];
                    int projectCurrent = value.section(":",0,0).toInt();
                    int projectReserve = value.section(":",1,1).toInt();
                    int projectLimit = value.section(":",2,2).toInt();
                    QString toolTip = QString("(%1)\n%2").arg(projectReserve).arg(projectCurrent);
                    if( projectLimit > -1 )
                        toolTip += " / " + QString::number(projectLimit);
                    //toolTip += "\n";
                    //LOG_1( QString("append tooltip for %1 to %2").arg(keyUser).arg(toolTip) );

                    // iterate through the model and set as tooltip for all rows belonging to
                    // the user
                    int numRows = jm->rowCount();
                    for ( int row = 0; row < numRows; row++ ) {
                        QModelIndex qmi = jm->index(row, 7);
                        QString cell = jm->data( qmi ).toString();
                        //LOG_1( QString("row %1 has data %2").arg(QString::number(row)).arg(cell) );
                        if( keyProject == cell ) {
                            JobItem & ji = JobTranslator::data(qmi);
                            ji.projectToolTip += toolTip;
                        }
                    }
                }
            }

            mJobTree->busyWidget()->stop();
			mJobTaskRunning = false;
			// This will update the status bar and action states
			// since they selected jobs may have changed
			jobListSelectionChanged();

			if( mQueuedJobRefresh ) {
				mQueuedJobRefresh = false;
				refresh();
			}

            mJobTree->mRecordFilterWidget->filterRows();

			break;
		}
		case FRAME_LIST:
		{
			int minFrame = -1, maxFrame = -1;
			JobTaskList jtl = ((FrameListTask*)evt)->mReturn;
			FrameItem::CurTime = ((FrameListTask*)evt)->mCurTime;
			foreach( JobTask jt, jtl )
			{
				if( minFrame==-1 || (int)jt.frameNumber() < minFrame )
					minFrame = jt.frameNumber();
				if( maxFrame==-1 || (int)jt.frameNumber() > maxFrame )
					maxFrame = jt.frameNumber();
			}
			mFrameTree->model()->updateRecords( jtl );
			mTabToolBar->slotPause();
			mImageView->setFrameRange( mCurrentJob.outputPath(), minFrame, maxFrame );
			mFrameTask = 0;

            mFrameTree->mRecordFilterWidget->filterRows();
            mFrameTree->busyWidget()->stop();

			break;
		}
		case PARTIAL_FRAME_LIST:
		{
			JobTaskList jtl = ((PartialFrameListTask*)evt)->mReturn;
			LOG_3("got partial frame list back:"+QString::number(jtl.size()));
			FrameItem::CurTime = ((PartialFrameListTask*)evt)->mCurTime;
			mFrameTree->model()->updated( jtl );
			mTabToolBar->slotPause();
			mPartialFrameTask = 0;

            mFrameTree->mRecordFilterWidget->filterRows();
            mFrameTree->busyWidget()->stop();

			break;
		}
		case ERROR_LIST:
		{
			JobErrorList jer = ((ErrorListTask*)evt)->mReturn;
            mErrorTree->busyWidget()->stop();
			mErrorTree->model()->updateRecords(jer);

            mErrorTree->mRecordFilterWidget->filterRows();

			break;
		}
		case STATIC_JOB_LIST_DATA:
		{
			mStaticDataRetrieved = true;
			StaticJobListDataTask * sdt = (StaticJobListDataTask*)evt;
		
			// Only the first StaticJobListDataTask actual does the select and fills in these static structures
			// any subsequent ones just ensure that the data is retreived before doing the rest of this logic
			if( sdt->mHasData ) {
				mJobTypeList = sdt->mJobTypes;
				mProjectList = sdt->mProjects;
			}

			// Default to showing all of the services and job types
			if( mJobFilter.typeToShow.isEmpty() )
                mJobFilter.typeToShow = mJobTypeList.filter( "fkeyparentjobtype", QVariant(), false ).keyString().split(',',QString::SkipEmptyParts);
			else
                mJobFilter.typeToShow = verifyKeyList( mJobFilter.typeToShow.join(","), JobType::table() ).split(',',QString::SkipEmptyParts);
			// If we haven't retrieved the static data, then mJobTaskRunning indicates
			// that we need to refresh the job list.
			if( mJobTaskRunning ) {
				mJobTaskRunning = false;
				refresh();
			}

            mJobTree->mRecordFilterWidget->filterRows();

			break;
		}
		case JOB_HISTORY_LIST:
		{
			mHistoryView->setHistory( ((JobHistoryListTask*)evt)->mReturn );
            mHistoryView->busyWidget()->stop();
		}
		case UPDATE_JOB_LIST:
		{
			JobList jl = ((UpdateJobListTask*)evt)->mReturn;
			mJobTree->model()->updated(jl);

            mJobTree->mRecordFilterWidget->filterRows();

			break;
		}
		default:
			break;
	}
}

QToolBar * JobListWidget::toolBar( QMainWindow * mw )
{
	if( !mToolBar ) {
        initializeViews();
		mToolBar = new QToolBar( mw );
		mToolBar->addAction( RefreshAction );
		mToolBar->addSeparator();
		mToolBar->addAction( ResumeAction );
		mToolBar->addAction( PauseAction );
		mToolBar->addAction( KillAction );
		mToolBar->addAction( RestartAction );
		mToolBar->addSeparator();
		mToolBar->addAction( FilterAction );
		mToolBar->addAction( FilterClearAction );
		mToolBar->addAction( ShowMineAction );
		mToolBar->addSeparator();
		mToolBar->addAction( DependencyTreeEnabledAction );
	}
	return mToolBar;
}

void JobListWidget::populateViewMenu( QMenu * viewMenu )
{
    initializeViews();
	viewMenu->addAction( DependencyTreeEnabledAction );
	viewMenu->addAction( NewViewFromSelectionAction );
	viewMenu->addSeparator();
	viewMenu->addAction( ShowMineAction );
	viewMenu->addAction( FilterAction );
	viewMenu->addAction( FilterClearAction );
	{
		QMenu * filterMenu = viewMenu->addMenu( "Job Filters" );
		filterMenu->addMenu( mProjectFilterMenu );
		filterMenu->addMenu( mStatusFilterMenu );
		filterMenu->addMenu( mJobTypeFilterMenu );
	}
}

void JobListWidget::setLimit()
{
	bool ok;
	int limit = QInputDialog::getInteger( this, "Set Job Limit", "Enter Maximum number of jobs to display", options.mLimit, 1, 100000, 1, &ok );
	if( ok ) {
		options.mLimit = limit;
		applyOptions();
		refresh();
	}
}

void JobListWidget::applyOptions()
{
    if( mViewsInitialized ) {
        mJobFilter.mLimit = options.mLimit;
        mJobTree->setFont( options.jobFont );
        mFrameTree->setFont( options.frameFont );
        mErrorTree->setFont( options.frameFont );
        mSummaryTab->setFont( options.summaryFont );
        options.mJobColors->apply(mJobTree);
        options.mFrameColors->apply(mFrameTree);
        options.mErrorColors->apply(mErrorTree);

        QPalette p = mJobTree->palette();
        ColorOption * co = options.mJobColors->getColorOption("Default");
        p.setColor(QPalette::Active, QPalette::AlternateBase, co->bg.darker(120));
        p.setColor(QPalette::Inactive, QPalette::AlternateBase, co->bg.darker(120));
        mJobTree->setPalette( p );

        mJobTree->update();
        mFrameTree->update();
        mErrorTree->update();
    }
}

void JobListWidget::setJobFilter( const JobFilter & jf )
{
	mJobFilter = jf;
}

void JobListWidget::setHiddenProjects( ProjectList hiddenProjects )
{
	mJobFilter.hiddenProjects.clear();
	foreach( Project p, hiddenProjects )
		mJobFilter.hiddenProjects += QString::number( p.key() );
}

void JobListWidget::setElementList( ElementList el )
{
	mJobFilter.elementList = el;
}

void JobListWidget::setStatusToShow( QStringList statii )
{
	mJobFilter.statusToShow = statii;
}

void JobListWidget::doRefresh()
{
	FreezerView::doRefresh();
	bool needJobListTask = false;
	bool needStatusBarMsg = false;

	if( !mStaticDataRetrieved )
		mJobTaskRunning = needStatusBarMsg = true;
	else if( mJobTaskRunning )
		mQueuedJobRefresh = true;
	else
		needJobListTask = needStatusBarMsg = true;

	if( needStatusBarMsg )
		setStatusBarMessage( "Refreshing Job List..." );

	if( needJobListTask ) {
		mJobTaskRunning = true;
		LOG_5( "Statuses to show: " + mJobFilter.statusToShow.join(",") );
        mJobTree->busyWidget()->start();
		FreezerCore::addTask( new JobListTask( this, mJobFilter, mJobList, activeProjects(), !mJobTree->isColumnHidden(19) /*Service column*/, isDependencyTreeEnabled()) );
		FreezerCore::wakeup();
		// Refresh frame or error list too
		currentJobChanged();
	}
}

void JobListWidget::jobTreeColumnVisibilityChanged( int column, bool visible )
{
	// Services column
	if( column == 19 && visible )
		refresh();
}

void JobListWidget::setJobList( JobList jobList )
{
	mJobList = jobList;
	refresh();
}

void JobListWidget::refreshErrorList()
{
       mErrorTree->busyWidget()->start();
       FreezerCore::addTask( new ErrorListTask( this, mCurrentJob, mShowClearedErrors ) );
       FreezerCore::wakeup();
}

void JobListWidget::currentJobChanged()
{
	bool jobChange = mCurrentJob != mJobTree->current();
	mCurrentJob = mJobTree->current();
	LOG_5( "JobListWidget::currentJobChanged: " + QString::number( mCurrentJob.key() ) );

	QWidget * curTab = mJobTabWidget->currentWidget();
	if( curTab==mFrameTab )
		refreshFrameList(jobChange);
    else if( curTab == mErrorsTab )
        refreshErrorList();
}

void JobListWidget::refreshFrameList( bool jobChange )
{
	// Cancel the current task if there is one
	if( mFrameTask )
		mFrameTask->mCancel = true;
	
	if( jobChange )
		mFrameTree->model()->setRootList( RecordList() );

	if( mCurrentJob.isRecord() ) {
		if( jobChange || mCurrentJob.jobStatus().tasksCount() < 2000 ) {
			mFrameTask = new FrameListTask( this, mCurrentJob );
            mTaskListBusyWidget->show();
            mTaskListBusyWidget->start();
			FreezerCore::addTask( mFrameTask );
			FreezerCore::wakeup();
		} else {
			// only update visible items
			QModelIndex start = mFrameTree->indexAt(QPoint(1,1));
			QModelIndex end = mFrameTree->indexAt(QPoint( 1, mFrameTree->viewport()->height()+1 ));
			JobTaskList jtl;
			for(ModelIter it(start); *it != end; ++it)
				jtl += FrameTranslator::getRecordStatic(*it);
			mPartialFrameTask = new PartialFrameListTask( this, jtl );
			FreezerCore::addTask( mPartialFrameTask );
			FreezerCore::wakeup();
		}
	}
}

void JobListWidget::jobListSelectionChanged()
{
	JobList selection = mJobTree->selection();
	if( selection.size() == 1 ) {
		setStatusBarMessage( selection[0].name() + " Selected" );
	} else if( selection.size() )
		setStatusBarMessage( QString::number( selection.size() ) + " Jobs Selected" );
	else
		clearStatusBar();

	mSelectedJobs = selection;
	LOG_5( "JobListWidget::jobListSelectionChanged: " + mSelectedJobs.keyString() + " -- Current: " + QString::number( mCurrentJob.key() ) );

	QWidget * curTab = mJobTabWidget->currentWidget();
	if( curTab==mSummaryTab ) {
		mJobSettingsWidget->setSelectedJobs( selection );
	} else if( curTab == mHistoryTab ) {
		// Clear the view
        mHistoryView->setHistory( JobHistoryList() );
        mHistoryView->busyWidget()->start();
        FreezerCore::addTask( new JobHistoryListTask( this, selection ) );
        FreezerCore::wakeup();
	} else if( curTab == mNotesTab ) {
		mThreadView->setJobList( selection );
    }

	int cnt = mSelectedJobs.size();
	QMap<QString,RecordList> byStatus = mSelectedJobs.groupedBy( "status" );
	int newCnt = byStatus["submit"].size() + byStatus["verify"].size();
	int activeCnt = byStatus["ready"].size() + byStatus["started"].size();
	int doneCnt = byStatus["done"].size();
	int suspCnt = byStatus["suspended"].size();
	int holdCnt = byStatus["holding"].size();
	
	// Allow resume if all selected jobs are suspended
	ResumeAction->setEnabled( cnt && (suspCnt == cnt) );
	// Allow pause if all selected jobs are active( ready/started )
	PauseAction->setEnabled( cnt && (activeCnt == cnt) );
	// Allow Remove if all selected jobs are active, done, or suspended
	KillAction->setEnabled( cnt && (activeCnt + doneCnt + suspCnt + newCnt + holdCnt == cnt) );
	// Allow Restart if all selected jobs are active, done, or suspended
	RestartAction->setEnabled( cnt && (activeCnt + doneCnt + suspCnt == cnt) );
}

void JobListWidget::refreshCurrentTab()
{
	QWidget * curTab = mJobTabWidget->currentWidget();
	if( curTab==mSummaryTab || curTab == mHistoryTab )
		jobListSelectionChanged();
	else if( curTab==mFrameTab )
		refreshFrameList(true);
	else if( curTab==mNotesTab )
		mThreadView->setJobList( mJobTree->selection() );
	else
		currentJobChanged();
}

void JobListWidget::currentTabChanged()
{
	QWidget * curTab = mJobTabWidget->currentWidget();

	// This hack allows the bottom part of the splitter to be smaller than
	// the SummaryTab's minimum height, when the SummaryTab is not shown
	if( curTab == mSummaryTab )
		mJobTabWidget->setSizePolicy( QSizePolicy( QSizePolicy::Expanding, QSizePolicy::Expanding ) );
	else
		mJobTabWidget->setSizePolicy( QSizePolicy( QSizePolicy::Ignored, QSizePolicy::Ignored ) );

	if( curTab==mFrameTab )
		mTabToolBar->show();
	else
		mTabToolBar->hide();

	refreshCurrentTab();
}

void JobListWidget::clearErrors()
{
    JobList jobs = mJobTree->selection();
    if( jobs.size() ) {
        QString history = " Errors cleared";
        QSqlQuery q = Database::current()->exec("SELECT fkeyjob, sum(count) FROM JobError WHERE (cleared=false OR cleared IS NULL) AND fkeyjob IN (" + jobs.keyString() + ") GROUP BY fkeyjob");

        while( q.next() ) {
            Job j( q.value(0).toInt() );
            j.addHistory( QString::number(q.value(1).toInt()) + history );
        }
        Database::current()->exec("UPDATE JobError SET cleared=true WHERE fkeyJob IN(" + jobs.keyString() + ")");
    }
}

void JobListWidget::restartJobs()
{
    if( !(qApp->keyboardModifiers() & (Qt::ControlModifier|Qt::AltModifier)) && (QMessageBox::warning( this, "Restart Job Confirmation", "Are you sure that you want to restart the selected jobs?\n  All tasks will be set to 'new'.", QMessageBox::Yes | QMessageBox::No, QMessageBox::Yes) ) != QMessageBox::Yes )
        return;
    updateSelectedJobs("verify", true);

    foreach( Job job, mJobTree->selection() )
        job.addHistory( "Job Restarted" );
}

void JobListWidget::resumeJobs()
{
    updateSelectedJobs("started", false);
    refresh();
}

void JobListWidget::pauseJobs()
{
    updateSelectedJobs("suspended", false);
    refresh();
}

void JobListWidget::deleteJobs()
{
    if( !(qApp->keyboardModifiers() & (Qt::ControlModifier|Qt::AltModifier)) && (QMessageBox::warning( this, "Delete Job Confirmation", "Are you sure that you want to delete the selected jobs?\n  Once deleted a job cannot be restarted.", QMessageBox::Yes | QMessageBox::No, QMessageBox::Yes) ) != QMessageBox::Yes )
        return;
    updateSelectedJobs("deleted", false);
    refresh();
}

void JobListWidget::updateSelectedJobs(const QString & jobStatus, bool resetTasks)
{
    JobList jl = mJobTree->selection(), checked;

    foreach( Job j, jl ) {
        if( jobStatus!="started" || j.status()=="suspended" )
            checked += j;
    }

    Job::updateJobStatuses( checked, jobStatus, resetTasks);
}

void JobListWidget::showMine(bool sm)
{
	User u = User::currentUser();

	/* Edit the mJobFilter */
	mJobFilter.userList.clear();
	if( sm && u.isRecord() )
		mJobFilter.userList += QString::number(u.key());

	/* Refresh the list */
	refresh();
}

void JobListWidget::jobFilterChanged( const QString & jobFilter )
{
	mJobFilter.mExtraFilters = jobFilter;
	refresh();
}

void JobListWidget::frameSelected( const Record & frameRecord )
{
	JobTask frame(frameRecord);
	if( frame.isRecord() ) {
		int frameNumber = frame.frameNumber();
		mImageView->setImageNumber( frameNumber );
	}
}

void JobListWidget::frameListSelectionChanged()
{
	JobTaskList jtl = mFrameTree->selection();
	if( jtl.size() == 1 ) {
		int num = jtl[0].frameNumber();
		setStatusBarMessage( mCurrentJob.name() + " Frame " + QString::number( num ) );
	} else if( jtl.size() > 1 ) {
		setStatusBarMessage( mCurrentJob.name() + " " + QString::number( jtl.size() ) + " Frames Selected" );
	} else
		clearStatusBar();
}

void JobListWidget::outputPathExplorer()
{
	JobTask cur = mFrameTree->current();
	if( cur.isRecord() ){
		mImageView->showOutputPath(cur.frameNumber());
	} else {
		Job j = mJobTree->current();
		if( j.isRecord() ) {
			QString path = j.outputPath();
			path = QFileInfo( path ).path();
		
			QString cmd;
#ifdef Q_OS_WIN
			path.replace("/", "\\");
			cmd = "explorer.exe";
#endif
#ifdef Q_OS_LINUX
			path.replace('\\', '/');
			cmd = "thunar";
#endif
#ifdef Q_OS_MAC
			path.replace('\\', '/');
			cmd = "open";
#endif
			if( !QProcess::startDetached( cmd, QStringList() << path ) ) {
				LOG_1( "Unable to start " + cmd );
			}
		}
	}
}

void JobListWidget::changeFrameSelection(int /*frameNumber*/)
{
	/*QTreeWidgetItem * item = mFrameTree->firstChild();
	while(item){
		if( item->isSelected() || (item->text(0).toInt()==frameNumber) )
			FrameListView->setSelected(item, item->text(0).toInt()==frameNumber);
		item = item->nextSibling();
	}*/
}

void JobListWidget::showJobPopup( const QPoint & point )
{
	if( !mJobMenu ) mJobMenu = new FreezerJobMenu(this);
	mJobMenu->popup( mJobTree->mapToGlobal( point ) );
}

void JobListWidget::saveCannedBatchJob()
{
	JobList jobs = mJobTree->selection();
	if( jobs.size() == 1 ) {
		JobBatch jb(jobs[0]);
		BatchSubmitDialog * bsd = new BatchSubmitDialog( this );
		bsd->setSaveCannedBatchMode( true );
		bsd->setName( jb.name() );
		bsd->setCommand( jb.cmd() );
		bsd->exec();
		delete bsd;
	}
}

void JobListWidget::clearJobList()
{
	setJobList(JobList());
}

void JobListWidget::showJobInfo()
{
	bool canEdit = User::hasPerms( "Job", true ) || (mCurrentJob.user() == User::currentUser());
	restorePopup( RecordPropValTree::showRecords( mCurrentJob, this, canEdit ) );
}

void JobListWidget::showJobStatistics()
{
	JobStatWidget * jsw = new JobStatWidget(0);
	jsw->setJobs( mJobTree->selection() );
	jsw->show();
	restorePopup(jsw);
}

void JobListWidget::setJobPriority()
{
	int total = 0, count = 0;
	JobList jl = mJobTree->selection();
	foreach( Job j, jl ) {
		count++;
		total += j.priority();
	}
	bool ok;
	int priority = QInputDialog::getInteger(this,"Set Job(s) Priority","Set Job(s) Priority", total / count, 1, 99, 1, &ok);
	if( ok ) {
		jl.setPriorities( priority );
		jl.commit();
	}
}

void JobListWidget::showFramePopup(const QPoint & point)
{
	if( !mTaskMenu ) mTaskMenu = new FreezerTaskMenu(this);
	mTaskMenu->popup( mErrorTree->mapToGlobal(point) );
}

void JobListWidget::showErrorPopup(const QPoint & point)
{
	if( !mErrorMenu )
		mErrorMenu = new FreezerErrorMenu( this, mErrorTree->selection(), mErrorTree->model()->rootList() );
	else
		mErrorMenu->setErrors( mErrorTree->selection(), mErrorTree->model()->rootList() );
	mErrorMenu->popup( mErrorTree->mapToGlobal(point) );
}


ImageView * JobListWidget::imageView() const
{
	return mImageView;
}

void JobListWidget::setFrameCacheStatus(int fn, int status)
{
	LOG_5("setFrameCacheStatus: fn: "+QString::number(fn) + " status:"+QString::number(status));
	QModelIndex idx = ModelIter(mFrameTree->model()).findFirst(0,fn);
	if( idx.isValid() )
		FrameTranslator::data(idx).loadedStatus = status;
}

void JobListWidget::createNewViewFromSelection()
{
	JobList sel = mJobTree->selection();
	if( sel.isEmpty() ) return;
	MainWindow * mw = qobject_cast<MainWindow*>(window());
	if( mw ) {
		JobListWidget * jobListView = new JobListWidget(mw);
		jobListView->setJobList( sel );
		mw->insertView( jobListView );
		mw->setCurrentView( jobListView );
	}
}

void JobListWidget::toggleFilter(bool enable)
{
    mJobTree->enableFilterWidget(enable);
    mFrameTree->enableFilterWidget(enable);
    mErrorTree->enableFilterWidget(enable);
}

void JobListWidget::clearFilters()
{
	mJobTree->mRecordFilterWidget->clearFilters();
	mFrameTree->mRecordFilterWidget->clearFilters();
	mErrorTree->mRecordFilterWidget->clearFilters();
}
