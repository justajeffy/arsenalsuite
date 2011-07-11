
#include <qtimer.h>
#include <qtoolbar.h>

#include "blurqt.h"
#include "iniconfig.h"
#include "interval.h"
#include "tableschema.h"

#include "jobtaskassignment.h"
#include "jobassignmentstatus.h"
#include "joberror.h"
#include "jobservice.h"
#include "service.h"

#include "recordsupermodel.h"
#include "recordpropvaltree.h"

#include "hosthistoryview.h"
#include "jobcommandhistorywindow.h"

static int jobServicesColumn = 0, statusColumn = 0;

class JobAssignmentItem : public RecordItem
{
	public:
	QString services;
	void setup( const Record & record, const QModelIndex & idx )
	{
		RecordItem::setup(record,idx);
		Job j = JobAssignment(record).job();
		if( j.isRecord() )
			services = j.jobServices().services().services().join(",");
	}

	QVariant modelData( const QModelIndex & idx, int role )
	{
		if( role == Qt::BackgroundRole ) {
			JobTaskAssignment jta(record);
			if( jta.jobError().isRecord() )
				return QColor(Qt::red).lighter(120);
			if( jta.jobAssignmentStatus().status() == "done" )
				return QColor(Qt::green).lighter(120);
		}
		if( role == Qt::DisplayRole && idx.column() == jobServicesColumn )
			return services;
		if( idx.column() == statusColumn )
			return JobAssignmentStatus(record.getValue("fkeyjobassignmentstatus").toInt()).status();
		return RecordItem::modelData(idx,role);
	}
	RecordList children( const QModelIndex & )
	{
		return JobAssignment(record).jobTaskAssignments();
	}
};

HostHistoryView::HostHistoryView( QWidget * parent )
: RecordTreeView( parent )
, mRefreshScheduled( false )
, mLimit( 600 )
{
	QStringList cols, col_names;
	foreach( Field * field, JobAssignment::table()->schema()->fields() ) {
		QString fnl = field->name().toLower();
		if( fnl == "command" || fnl == "stdout" || fnl == "stderr" ) continue;
		if( fnl == "fkeyjobassignmentstatus" ) statusColumn = field->pos();
		cols << field->name();
		col_names << field->displayName();
	}
	jobServicesColumn = col_names.size();
	col_names << "Job Services";
	mModel = new RecordSuperModel(this);
	mModel->setHeaderLabels( col_names );
	mTrans = new JobAssignmentTranslator(mModel->treeBuilder());
	mTrans->setRecordColumnList( cols );
	setModel( mModel );
	setRootIsDecorated( true );
	connect( this, SIGNAL( doubleClicked( const QModelIndex & ) ), SLOT( slotDoubleClicked( const QModelIndex & ) ) );
}

void HostHistoryView::slotDoubleClicked( const QModelIndex & idx )
{
	JobAssignment ja( mModel->getRecord(idx) );
	JobTaskAssignment jta( mModel->getRecord(idx) );
	if( !ja.isRecord() && !jta.isRecord() ) return;

	QString col = mTrans->recordColumnName( idx.column() ).toLower();
	if( col == "fkeyjoberror" ) {
		RecordPropValTree * tree = new RecordPropValTree(0);
		tree->setAttribute( Qt::WA_DeleteOnClose, true );
		tree->setWindowTitle( "Job Error" );
		tree->setRecords( ja.isRecord() ? ja.jobError() : jta.jobError() );
		tree->show();
	} else if( ja.isRecord() ) {
		JobAssignmentWindow * jaw = new JobAssignmentWindow();
		jaw->setAttribute( Qt::WA_DeleteOnClose, true );
		jaw->setJobAssignment( ja );
		jaw->setWindowTitle("Job Executation Log: ");
		jaw->show();
	}
}

Host HostHistoryView::hostFilter() const
{
	return mHostFilter;
}

Job HostHistoryView::jobFilter() const
{
	return mJobFilter;
}

JobTask HostHistoryView::taskFilter() const
{
	return mJobTaskFilter;
}

int HostHistoryView::limit() const
{
	return mLimit;
}

void HostHistoryView::refresh()
{
	if( !mRefreshScheduled ) {
		mRefreshScheduled = true;
		QTimer::singleShot( 0, this, SLOT( doRefresh() ) );
	}
}

void HostHistoryView::doRefresh()
{
	mRefreshScheduled = false;
	QString where;
	VarList args;
	if( mHostFilter.isRecord() ) {
		where += "fkeyhost=?";
		args << mHostFilter.key();
	}
	if ( mJobFilter.isRecord() ) {
		if( !where.isEmpty() ) where += " AND ";
		where += "fkeyjob=?";
		args << mJobFilter.key();
	}
	/*
	if ( mJobTaskFilter.isRecord() ) {
		if( !where.isEmpty() ) where += " AND ";
		where += "fkeyjobtask=?";
		args << mJobTaskFilter.key();
	}
	*/
	where += " ORDER BY keyjobassignment DESC LIMIT " + QString::number( mLimit );
	JobAssignmentList jal = JobAssignment::select( where, args );

	Index * jsi = JobService::table()->indexFromField( "fkeyjob" );
	bool jsiRestore = false;
	if( jsi ) {
		jsiRestore = jsi->cacheEnabled();
		jsi->setCacheEnabled( true );
	}
	JobList jobs = jal.jobs();
	mCache = jobs;
	// Cache the job services
	jobs.jobServices();

	//mCache += hhl.jobTasks();
	mCache += jal.jobErrors();
	mModel->updateRecords( jal );
	
	// Restore jobservice.fkeyjob caching state
	jsi->setCacheEnabled( jsiRestore );
}

void HostHistoryView::setHostFilter( const Host & host )
{
	mHostFilter = host;
	refresh();
}

void HostHistoryView::setJobFilter( const Job & job )
{
	mJobFilter = job;
	refresh();
}

void HostHistoryView::setTaskFilter( const JobTask & task )
{
	mJobTaskFilter = task;
	refresh();
}

void HostHistoryView::setLimit( int limit )
{
	mLimit = limit;
}

void HostHistoryView::clearFilters()
{
	mJobFilter = Job();
	mHostFilter = Host();
}


HostHistoryWindow::HostHistoryWindow( QWidget * parent )
: QMainWindow( parent )
{
	setAttribute( Qt::WA_DeleteOnClose, true );

	mView = new HostHistoryView(this);
	setCentralWidget( mView );

	mCloseAction = new QAction( "&Close", this );
	connect( mCloseAction, SIGNAL( activated() ), SLOT( close() ) );
	
	mRefreshAction = new QAction( "&Refresh", this );
	connect( mRefreshAction, SIGNAL( activated() ), mView, SLOT( refresh() ) );

	QMenu * fileMenu = menuBar()->addMenu( "&File" );
	fileMenu->addAction( mRefreshAction );
	fileMenu->addSeparator();
	fileMenu->addAction( mCloseAction );
	
	addToolBar("Main")->addAction( mRefreshAction );

	IniConfig & ini = userConfig();
	ini.pushSection( "HostHistoryWindow" );
	QByteArray geometry = ini.readByteArray( "WindowGeometry" );
	ini.popSection();
	if( geometry.isEmpty() )
		resize( 700, 600 );
	else
		restoreGeometry( geometry );
}

HostHistoryView * HostHistoryWindow::view() const
{
	return mView;
}

void HostHistoryWindow::closeEvent( QCloseEvent * ce )
{
	IniConfig & ini = userConfig();
	ini.pushSection( "HostHistoryWindow" );
	ini.writeByteArray( "WindowGeometry", saveGeometry() );
	ini.popSection();
	QMainWindow::closeEvent(ce);
}

