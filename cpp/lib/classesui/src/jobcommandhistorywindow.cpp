
/* $Author: brobison $
 * $LastChangedDate: 2007-06-18 11:27:47 -0700 (Mon, 18 Jun 2007) $
 * $Rev: 4632 $
 * $HeadURL: svn://brobision@66.93.150.126/blur/trunk/cpp/lib/assfreezer/src/jobsettingswidget.cpp $
 */

#include <qtimer.h>
#include <qfile.h>

#include "config.h"
#include "jobcommandhistorywindow.h"

JobAssignmentWindow::JobAssignmentWindow( QWidget * parent )
: QMainWindow( parent )
, mRefreshRequested( false )
{
	setupUi( this );

	setAttribute( Qt::WA_DeleteOnClose, true );

	connect(mRefreshButton, SIGNAL(pressed()), SLOT(refresh()));
	resize(600, 800);
	mLogRoot = Config::getString("assburnerLogRootDir", "");
}

JobAssignmentWindow::~JobAssignmentWindow()
{}

JobAssignment JobAssignmentWindow::jobAssignment()
{
	return mJobAssignment;
}

void JobAssignmentWindow::setJobAssignment(const JobAssignment & ja)
{
	mJobAssignment = ja;
	refresh();
}

void JobAssignmentWindow::refresh()
{
	if( !mRefreshRequested ) {
		mRefreshRequested = true;
		QTimer::singleShot( 0, this, SLOT( doRefresh() ) );
	}
}

void JobAssignmentWindow::doRefresh()
{
	mRefreshRequested = false;
	mJobAssignment.reload();
	mCommandEdit->setText( mJobAssignment.command() );
	if( mLogRoot.isEmpty() ) {
		mPathEdit->hide();
		mLogText->document()->setPlainText( mJobAssignment.stdOut() );
	} else {
		QFile read(mJobAssignment.stdOut());
		if( !read.open(QIODevice::ReadOnly | QIODevice::Text) )
			return;
		mLogText->document()->setPlainText( read.readAll() );
		mPathEdit->setText( mJobAssignment.stdOut() );
	}
	mLogText->moveCursor(QTextCursor::End);
}

