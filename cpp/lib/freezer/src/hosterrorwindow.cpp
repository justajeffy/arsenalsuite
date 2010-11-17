
#include <qlayout.h>
#include <qtimer.h>
#include <qstatusbar.h>

#include "freezercore.h"

#include "recordtreeview.h"

#include "assfreezermenus.h"
#include "hosterrorwindow.h"
#include "items.h"
#include "threadtasks.h"

HostErrorWindow::HostErrorWindow( QWidget * parent )
: QMainWindow( parent )
, mLimit( 50 )
, mTask( 0 )
, mRefreshQueued( false )
, mRefreshScheduled( false )
, mModel( 0 )
, mErrorTree( 0 )
{
	setAttribute( Qt::WA_DeleteOnClose, true );

	mErrorTree = new RecordTreeView( this );
	mErrorTree->setUniformRowHeights( false );
	connect( mErrorTree, SIGNAL( showMenu( const QPoint &, const Record &, RecordList ) ), SLOT( showMenu( const QPoint &, const Record &, RecordList ) ) );

	mModel = new HostErrorModel( mErrorTree );
	mModel->setAutoSort( true );
	mErrorTree->setModel( mModel );
	IniConfig ini;
	setupHostErrorView(mErrorTree,ini);
	for( int i=0; i<8; i++ ) {
		mErrorTree->setColumnAutoResize(i,true);
		mErrorTree->setColumnHidden(i,false);
	}
	resize( 600, 450 );
	setCentralWidget(mErrorTree);
	statusBar();
}

void HostErrorWindow::setHost( const Host & host )
{
	mHost = host;
	setWindowTitle( host.name() + " errors" );
	refresh();
}

void HostErrorWindow::setLimit( int limit )
{
	mLimit = limit;
	refresh();
}

void HostErrorWindow::refresh()
{
	if( !mRefreshScheduled ) {
		mRefreshScheduled = true;
		statusBar()->showMessage( "Refreshing Errors..." );
		QTimer::singleShot( 0, this, SLOT( doRefresh() ) );
	}
}

void HostErrorWindow::doRefresh()
{
	mRefreshScheduled = false;

	if( mTask ) {
		mRefreshQueued = true;
		return;
	}

	mTask = new HostErrorListTask( this, mHost, mLimit );
	FreezerCore::addTask( mTask );
}

void HostErrorWindow::showMenu( const QPoint & pos, const Record & underMouse, RecordList selected )
{
	Q_UNUSED(underMouse);
	AssfreezerErrorMenu * menu = new AssfreezerErrorMenu( this, selected, mErrorTree->model()->rootList() );
	menu->exec( pos );
	delete menu;
}

void HostErrorWindow::customEvent( QEvent * evt )
{
	if( evt == mTask ) {
		mModel->setErrors( mTask->mReturn, mTask->mJobs, mTask->mJobServices );
		mTask = 0;
		if( mRefreshQueued ) {
			mRefreshQueued = false;
			doRefresh();
		} else
			statusBar()->clearMessage();
	}
}
