
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
 * along with Blur; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Author$
 * $LastChangedDate: 2010-02-10 15:06:55 +1100 (Wed, 10 Feb 2010) $
 * $Rev: 9329 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/src/items.cpp $
 */

#include <qpixmap.h>
#include <qpainter.h>
#include <qdatetime.h>
#include <qheaderview.h>
#include <qmessagebox.h>
#include <QPixmapCache>

#include "blurqt.h"
#include "database.h"
#include "iniconfig.h"
#include "interval.h"
#include "imagecache.h"
#include "modelgrouper.h"
#include "qvariantcmp.h"
#include "recorddrag.h"

#include "employee.h"
#include "jobdep.h"
#include "jobhistory.h"
#include "joboutput.h"
#include "joboutput.h"
#include "jobstatus.h"
#include "jobservice.h"
#include "jobtype.h"
#include "project.h"
#include "service.h"

#include "afcommon.h"
#include "items.h"

// ColumnStruct declared in recordtreeview.h
// DisplayName, IniName, DefaultSize, DefaultPos, Hidden, Filter Enabled
static const ColumnStruct job_columns [] =
{
	{ "Job Name", 			"JobName", 			220, 	1, 	false, true },	//0
	{ "Status", 			"Status", 			80, 	3, 	false, true },	//1
	{ "Progress", 			"Progress", 		100, 	5, 	false, false },	//2
	{ "Done,Total", 		"ETA", 				60, 	6, 	false, false },	//3
	{ "Owner", 				"Owner", 			100, 	8, 	false, true },	//4
	{ "Slots", 				"Slots", 			50, 	4, 	false, false },	//5
	{ "Priority", 			"Priority", 		60, 	10,	false, true },	//6
	{ "Project", 			"Project", 			40, 	9, 	false, true },	//7
	{ "Submitted", 			"Submitted", 		140, 	14,	false, false },	//8
	{ "Errors", 			"Errors", 			50, 	11,	false, false },	//9
	{ "Output Path",		"OutputPath", 		200, 	17,	true, false },	//10
	{ "Avg. Time", 			"AverageTime", 		80, 	7,	false, false },	//11
	{ "Job Type", 			"JobType", 			50, 	2,	false, true },	//12
	{ "Key", 				"Key", 				60,		0,	false, true },	//13
	{ "Stats", 				"Stats", 			0, 		19,	true, false },	//14
	{ "Map Server Weight", 	"MapServerWeight", 	0, 		20,	true, false },	//15
	{ "Health", 			"Health", 			20, 	18,	true, false }, 	//16
	{ "Ended", 				"Ended", 			140, 	15,	false, false },	//17
	{ "Time in Queue", 		"TimeInQueue",		80, 	13,	false, false },	//18
	{ "Services", 			"Services", 		80, 	16,	false, true }, //19
	{ "Avg. Memory", 		"AverageMemory", 	80, 	12,	false, false },	//20
	{ "Efficiency", 		"Efficiency", 	40, 	21,	false, true },	//21
	{ "Disk Write", 		"DiskWrite", 	40, 	22,	false, false },	//22
	{ "Disk Read", 		"DiskRead", 	40, 	23,	false, false },	//23
	{ "Disk Ops", 		"DiskOps", 	40, 	24,	false, false },	//24
	{ "CPU Time", 		"CPUTime", 	60, 	25,	false, true },	//25
	{ "Queue Order", 		"QueueOrder", 	40, 	26,	false, false },	//26
	{ "Shot Name", 		"ShotName", 	60, 	26,	false, true },	//27
    { "Suspended",          "Suspended",        140,    27, false, false}, //28
	{ 0, 					0, 					0, 		0, 	false, false }
};

static const ColumnStruct error_columns [] =
{
	{ "Host", 				"HostColumn", 		90, 	3, false, true },
	{ "Time", 				"TimeColumn", 		180, 	4, false, false },
	{ "Frames", 			"FrameColumn", 		130, 	5, false, false },
	{ "Error Message", 		"MessageColumn", 	3000, 	6, false, true },
	{ "Count", 				"CountColumn", 		50, 	7, false, false },
	{ 0, 0, 0, 0, false, false }
};

static const ColumnStruct host_error_columns [] =
{
	error_columns[0],
	error_columns[1],
	error_columns[2],
	error_columns[3],
	error_columns[4],
	{ "Job",				"JobColumn",	100,	0, true, false },
	{ "JobType",	"JobTypeColumn", 		60,		1, true, false },
	{ "Services",	"ServicesTypeColumn", 	60,		2, true, false },
	{ 0, 0, 0, 0, false, false }
};

static const ColumnStruct frame_columns [] =
{
	{ "Frame", 				"FrameColumn", 		50, 	0, false, true},
	{ "Status", 			"StatusColumn", 	60, 	1, false, true},
	{ "Host", 				"HostColumn", 		100, 	2, false, true},
	{ "Time", 				"TimeColumn", 		60, 	3, false, false},
	{ "Loaded", 			"LoadedColumn", 	20, 	4, false, false},
	{ "Memory", 			"Memory", 			30, 	5, false, false},
	{ "Pass", 				"PassColumn", 		50, 	6, true, false},
	{ 0, 0, 0, 0, false, false }
};

static const ColumnStruct job_history_columns [] =
{
	{ "Message", 			"MessageColumn", 	90, 	0, false, true },
	{ "User", 				"UserColumn", 		90, 	1, false, true },
	{ "Host", 				"HostColumn", 		90, 	2, false, true },
	{ "When", 				"WhenColumn", 		90, 	3, false, false },
	{ 0, 0, 0, 0, false, false }
};

void setupJobView( RecordTreeView * lv, IniConfig & ini )
{
	ini.pushSubSection("JobList");
	lv->setupTreeView(ini,job_columns);
	lv->setupRecordFilterWidget(ini,job_columns);
	lv->setAlternatingRowColors( true );
	ini.popSection();
}

void saveJobView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("JobList");
	lv->saveTreeView(ini,job_columns);
	ini.popSection();
}

void setupHostView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("HostList");
	HostItem::HostColors = options.mHostColors;
	lv->setupTreeView(ini,HostItem::host_columns);
	lv->setupRecordFilterWidget(ini,HostItem::host_columns);
	lv->setAlternatingRowColors( true );
	ini.popSection();
}

void saveHostView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("HostList");
	lv->saveTreeView(ini,HostItem::host_columns);
	ini.popSection();
}

void setupErrorView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("ErrorList");
	lv->setupTreeView(ini,error_columns);
	lv->setupRecordFilterWidget(ini,error_columns);
	lv->setAlternatingRowColors( false );
	ini.popSection();
}

void saveErrorView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("ErrorList");
	lv->saveTreeView(ini,error_columns);
	ini.popSection();
}

void setupHostErrorView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("HostErrorList");
	lv->setupTreeView(ini,host_error_columns);
	ini.popSection();
}

void saveHostErrorView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("HostErrorList");
	lv->saveTreeView(ini,host_error_columns);
	ini.popSection();
}

void setupFrameView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("FrameList");
	lv->setupTreeView(ini,frame_columns);
	lv->setupRecordFilterWidget(ini,frame_columns);
	lv->setAlternatingRowColors( false );
	ini.popSection();
}

void saveFrameView( RecordTreeView * lv, IniConfig & ini  )
{
	ini.pushSubSection("FrameList");
	lv->saveTreeView(ini,frame_columns);
	ini.popSection();
}

QDateTime FrameItem::CurTime;

void drawGrad( QPainter * p, QColor c, int x, int y, int w, int h )
{
	c = c.light(130);
	for( ; h>0; h-- ){
		p->setPen( c );
		p->drawLine( x, y+h-1, x+w, y+h-1 );
		c = c.dark( 105 );
	}
}

ProgressDelegate::ProgressDelegate( QObject * parent )
: QItemDelegate( parent )
, mBusyColor( options.mJobColors->getColorOption("started") )
, mNewColor( options.mJobColors->getColorOption("ready") )
, mDoneColor( options.mJobColors->getColorOption("done") )
, mSuspendedColor( options.mJobColors->getColorOption("suspended") )
, mCancelledColor( options.mJobColors->getColorOption("suspended") )
, mHoldingColor( options.mJobColors->getColorOption("holding") )
{}

QPixmap ProgressDelegate::gradientCache(int height, const QChar & status) const
{
    QPixmap gradLine(1, height);
    if( QPixmapCache::find(QString("progress-gradient-%1").arg(status), &gradLine) )
        return gradLine;

    gradLine.fill(mNewColor->fg);
    QPainter gradPainter;
    gradPainter.begin( &gradLine );

    QColor c;
    if (status == QChar('a'))
        c = mNewColor->fg;
    else if (status == QChar('b'))
        c = mBusyColor->fg;
    else if (status == QChar('d'))
        c = mDoneColor->fg;
    else if (status == QChar('s'))
        c = mSuspendedColor->fg;
    else if (status == QChar('c'))
        c = mCancelledColor->fg;
    else if (status == QChar('h'))
        c = mHoldingColor->fg;
    else
        c = mNewColor->fg;

    drawGrad( &gradPainter, c, 0, 0, 1 /*width*/, height );

    QPixmapCache::insert(QString("progress-gradient-%1").arg(status), gradLine);
    return gradLine;
}

QPixmap ProgressDelegate::taskProgressBar(int height, const QString & taskBitmap) const
{
    // if the width is stupidly big chop it off
    int width = qMin(16000, qMax(1, taskBitmap.size()));
    QPixmap progressBar(width, height);
    progressBar.fill(mNewColor->fg);
    QPainter progressPainter;
    progressPainter.begin( &progressBar );

    for (int x = 0; x < width; ++x)
        progressPainter.drawPixmap( x, 0, gradientCache(height, taskBitmap.at(x) ));

    return progressBar;
}

void ProgressDelegate::paint( QPainter * p, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	if( index.isValid() && index.column() == 2 && JobTranslator::isType(index) ) {
		Job j = JobTranslator::data(index).getRecord();
		JobStatus js = JobStatus::recordByJob(j);
        QString taskBitmap = js.taskBitmap();
        //p->drawPixmap( option.rect.x()+2, option.rect.y()+2, taskProgressBar(option.rect.height()-4, taskBitmap).scaledToWidth( option.rect.width()-3 ) );
        p->drawPixmap( option.rect.x()+2, option.rect.y()+2, taskProgressBar(10, taskBitmap).scaled( option.rect.width()-2, 12 ) );

		p->setPen(QColor(180,180,180));
		p->drawRect(option.rect.x() + 1, option.rect.y() + 1,option.rect.width()-2,option.rect.height()-2);

		//p->setPen(QColor(232,232,232));
		//p->drawText( option.rect, Qt::AlignRight | Qt::AlignVCenter, JobTranslator::data(index).done );
		return;
	}
	return QItemDelegate::paint( p, option, index );
}

void LoadedDelegate::paint( QPainter * p, const QStyleOptionViewItem & option, const QModelIndex & index ) const
{
	if( index.isValid() && index.column() == 3 ) {
	  FrameItem & frameItem = FrameTranslator::data(index);
		if( frameItem.task.job().getValue("hasTaskProgress").toBool() ) {
			static ColorOption * started=0, * done=0;
			if( !started )
				started = options.mJobColors->getColorOption("started");
			if( !done )
				done = options.mJobColors->getColorOption("done");
	
			int progress = frameItem.task.progress();
			float donePct = (float)progress / 100.00;
	
			if( frameItem.stat == "done" )
				donePct = 1;
			drawGrad( p, done->fg, option.rect.x() + 2, option.rect.y() + 2, (int)((option.rect.width()-4)*donePct), option.rect.height()-3 );
		
			p->setPen(QColor(180,180,180));
			p->drawRect(option.rect.x() + 1, option.rect.y() + 1,option.rect.width()-2,option.rect.height()-2);
			p->setPen(QColor(232,232,232));
			QString text = index.model()->data(index, Qt::DisplayRole).toString();
			p->drawText( option.rect, Qt::AlignRight | Qt::AlignBottom, text );
			return;
		}
	}
	else if( index.isValid() && index.column() == 4 ) {
		FrameItem & frameItem = FrameTranslator::data(index);
		int status = frameItem.loadedStatus;
		if ( status==ImageCache::ImageNoInfo )
			return;

		QBrush b;
		if ( status==ImageCache::ImageLoading )
			b = QBrush(QColor(0,127,127));
		else if ( status==ImageCache::ImageNotFound )
			b = QBrush(QColor(255,0,0));
		else if ( status==ImageCache::ImageLoaded )
			b = QBrush(QColor(0,255,0));

		p->fillRect(option.rect, b);
		return;
	}
	return QItemDelegate::paint( p, option, index );
}

QSize MultiLineDelegate::sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const
{
	const QAbstractItemModel *model = index.model();
	QVariant value = model->data(index, Qt::FontRole);
	QFont fnt = value.isValid() ? qvariant_cast<QFont>(value) : option.font;
	QString text = model->data(index, Qt::DisplayRole).toString();
	QFontMetrics fontMetrics(fnt);
	return fontMetrics.size( 0, text );
}

QVariant civ( const QColor & c )
{
	if( c.isValid() )
		return QVariant(c);
	return QVariant();
}

void FrameItem::setup( const Record & r, const QModelIndex & ) {
	task = r;
	currentAssignment = task.jobTaskAssignment();
	hostName = task.host().name();
	stat = task.status();

	loadedStatus = 0;
	label = task.label();
	if( label.isEmpty() )
		label = QString::number(task.frameNumber());
	Interval dur;
	//if( stat == "done" || stat == "busy" )
	//	dur = Interval( currentAssignment.started(), (stat == "done") ? currentAssignment.ended() : CurTime );
	//time = dur.toString( Interval::Hours, Interval::Seconds, Interval::TrimMaximum | Interval::PadHours );
	co = options.mFrameColors->getColorOption(stat);
    /*
	if( currentAssignment.memory() > 0 )
        memory = QString("%1 MB").arg(currentAssignment.memory()/1024);
	else
		memory = "";
    */
}
QVariant FrameItem::modelData( const QModelIndex & i, int role ) const {
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 0: return label;
			case 1: return stat;
			case 2: return hostName;
			case 3: return ( stat == "done" || stat == "busy" ) ? Interval( currentAssignment.started(), (stat == "done") ? currentAssignment.ended() : CurTime ).toString( Interval::Hours, Interval::Seconds, Interval::TrimMaximum | Interval::PadHours ) : "";
			case 4: return loadedStatus;
			case 5: return currentAssignment.memory() > 0 ?  QString("%1 MB").arg(currentAssignment.memory()/1024) : "";
			case 6: return task.jobOutput().name();
		}
	} else if ( role == Qt::TextColorRole )
		return co ? civ(co->fg) : QVariant();
	else if( role == Qt::BackgroundColorRole )
		return co ? civ(co->bg) : QVariant();
	return QVariant();
}

char FrameItem::getSortChar() const {
	QString stat = task.status();
	if( stat=="new" ) return 'a';
	else if( stat=="assigned" ) return 'b';
	else if( stat=="busy" ) return 'c';
	else if( stat=="done" ) return 'd';
	else return 'k';
}

int FrameItem::compare( const QModelIndex & a, const QModelIndex & b, int column, bool asc )
{
	FrameItem & other = FrameTranslator::data(b);
	if( column == 1 ) {
		char sca = getSortChar();
		char scb = other.getSortChar();
		return sca == scb ? 0 : (sca > scb ? 1 : -1);
	}
	if( column == 0 ) {
		int fna = task.frameNumber();
		int fnb = other.task.frameNumber();
		return fna == fnb ? 0 : (fna > fnb ? 1 : -1);
	}
	return ItemBase::compare(a,b,column,asc);
}

Qt::ItemFlags FrameItem::modelFlags( const QModelIndex & )
{ return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled ); }

Record FrameItem::getRecord()
{ return task; }

void ErrorItem::setup( const JobError & err, const QModelIndex & ) {
	error = err;
	hostName = error.host().name();
	cnt = QString::number(error.count());
	when = error.lastOccurrence().toString();
	if( when.isEmpty() ) {
		QDateTime dt;
		dt.setTime_t( error.errorTime() );
		when = dt.toString();
	}
	msg = error.message().replace("\r","").trimmed();
	co = options.mErrorColors->getColorOption("error");
}

QVariant ErrorItem::modelData( const QModelIndex & i, int role ) const {
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 0: return hostName;
			case 1: return when;
			case 2: return error.frames();
			case 3: return msg;
			case 4: return cnt;
		}
	} else if( role == Qt::TextColorRole ) {
		return co ? civ(co->fg) : QVariant();
	} else if( role == Qt::BackgroundColorRole )
		return co ? civ(co->bg) : QVariant();
	return QVariant();
}

int ErrorItem::compare( const QModelIndex & a, const QModelIndex & b, int col, bool asc )
{
	if( col == 1 ) {
		ErrorItem & other = ErrorTranslator::data(b);
		return error.lastOccurrence() == other.error.lastOccurrence() ? 0 : (error.lastOccurrence() > other.error.lastOccurrence() ? 1 : -1);
	}
	return ItemBase::compare(a,b,col,asc);
}

Qt::ItemFlags ErrorItem::modelFlags( const QModelIndex & ) const
{ return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled ); }

Record ErrorItem::getRecord() { return error; }

void HostErrorItem::setup( const JobError & err, const QModelIndex & idx ) {
	ErrorItem::setup(err,idx);
	job = error.job();
	jobType = job.jobType();
	HostErrorModel * model = ((HostErrorModel*)idx.model());
	services = model->mJobServicesByJob[job].services().services().join(",");
}

QVariant HostErrorItem::modelData( const QModelIndex & i, int role ) const {
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 5: return job.name();
			case 6: return jobType.name();
			case 7: return services;
		}
	}
	return ErrorItem::modelData(i,role);
}

ErrorModel::ErrorModel( QObject * parent )
: RecordSuperModel( parent )
{
	new ErrorTranslator(treeBuilder());
}

HostErrorModel::HostErrorModel( QObject * parent )
: RecordSuperModel( parent )
{
	new HostErrorTranslator(treeBuilder());
}

void HostErrorModel::setErrors( JobErrorList errors, JobList jobs, JobServiceList jobServices )
{
	mJobs = jobs;
	mJobServicesByJob = jobServices.groupedBy<Job,JobServiceList,uint,Job>("fkeyjob");
	setRootList(errors);
	mJobs.clear();
	mJobServicesByJob.clear();
}

static int adjustedHostsOnJob(const QString & status, const JobStatus & jobStatus)
{
    return ( status=="suspended" || status=="done" || status=="deleted" ) ? 0 : jobStatus.hostsOnJob();
}

QString memoryString( int kb )
{
	int megs = kb / 1024;
	if( megs > 0 ) {
		if( megs > 1024 )
			return QString("%1 Gb").arg(megs/1024.0,0,'f',2);
		return QString("%1 Mb").arg(megs);
	}
	return "";
}

void JobItem::setup( const Record & r, const QModelIndex & idx ) {
	job = r;
	jobStatus = JobStatus::recordByJob(job);
    if( !jobStatus.isRecord() ) {
        jobStatus = JobStatus::recordByJob(job);
        userName = job.user().name();
        project = job.project().name();
        //submitted = job.submittedts().toString();
        type = job.jobType().name();
        icon = ((JobModel*)idx.model())->jobTypeIcon(job.jobType());
        if( job.wrangler().isRecord() ) {
            icon = QPixmap("images/wrangled.png");
        }
    }

	healthIsNull = jobStatus.getValue( "health" ).isNull();
    done = QString("%1 / %2").arg(jobStatus.tasksDone()).arg(jobStatus.tasksCount());
	QString status = job.status();
	hostsOnJob = QString::number( adjustedHostsOnJob(status,jobStatus) );
	priority = QString::number( job.priority() );

	errorCnt = QString::number(jobStatus.errorCount());

	avgTime = Interval(jobStatus.tasksAverageTime()).toString( Interval::Hours, Interval::Seconds, Interval::TrimMaximum | Interval::PadHours );

	Interval tiq( job.submittedts(), job.endedts().isNull() ? QDateTime::currentDateTime() : job.endedts() );
	timeInQueue = tiq.toString( Interval::Hours, Interval::Seconds, Interval::TrimMaximum | Interval::PadHours );

	co = options.mJobColors->getColorOption(status);
	avgMemory = memoryString(jobStatus.averageMemory());

	cpuTime = Interval(jobStatus.cputime() / 1000).toString( Interval::Hours, Interval::Seconds, Interval::TrimMaximum | Interval::PadHours );

    bytesWrite = memoryString( jobStatus.bytesWrite()/1024 );
    bytesRead = memoryString( jobStatus.bytesRead()/1024 );
    diskOps = QString::number( jobStatus.opsWrite() + jobStatus.opsRead() );
    efficiency.sprintf("%3.2f %", jobStatus.efficiency()*100.00);
}

QVariant JobItem::modelData( const QModelIndex & i, int role ) const
{
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 0: return job.name();
			case 1: return job.status();
			case 2: return "";
			case 3: return done;
			case 4: return userName;
			case 5: return hostsOnJob;
			case 6: return priority;
			case 7: return project;
			case 8: return job.submittedts().toString();
			case 9: return errorCnt;
			case 10: return job.outputPath();
			case 11: return avgTime;
			case 12: return type;
			case 13: return job.key();
			//case 14: return job.stats();
			case 15: return job.currentMapServerWeight();
			case 17: return job.endedts().toString();
			case 18: return timeInQueue;
			case 19: return services;
			case 20: return avgMemory;
			case 21: return efficiency;
			case 22: return bytesWrite;
			case 23: return bytesRead;
			case 24: return diskOps;
			case 25: return cpuTime;
			case 26: return jobStatus.queueOrder();
			case 27: return job.shotName();
            case 28: return job.suspendedts().toString();
		}
	} else if (role == Qt::TextColorRole )
		return co ? civ(co->fg) : QVariant();
	else if( role == Qt::BackgroundColorRole ) {
		if( col == 16 && !healthIsNull ) {
			QColor ret;
			ret.setRgbF( 1.0 - jobStatus.health(), jobStatus.health(), 0 );
			return ret;
		} else
			return co ? civ(co->bg) : QVariant();
	} else if( role == Qt::ToolTipRole && col == 16 && !healthIsNull ) {
		return QString( "%1% Healthy" ).arg(int(jobStatus.health() * 100));
	} else if( role == Qt::ToolTipRole ) {
        if( col == 0 ) {
            if( job.wrangler().isRecord() )
                return "Job is currently being wrangled by: " + job.wrangler().name();
        } else if ( col == 4 ) {
            if( userToolTip.isEmpty() ) return QVariant();
                return userName + "\n" + userToolTip;
        } else if ( col == 7 ) {
            if( projectToolTip.isEmpty() ) return QVariant();
                return project + "\n" + projectToolTip;
        }
    } else if( role == Qt::DecorationRole && col == 0 ) {
        return icon;
    }
    return QVariant();
}

int JobItem::compare( const QModelIndex & a, const QModelIndex & b, int col, bool asc )
{
    if( !a.isValid() || !b.isValid() )
        return -1;

	JobItem & other = JobTranslator::data(b);
	if( col == 2 ) {
		float other_done = other.jobStatus.tasksCount() ? other.jobStatus.tasksDone() / float(other.jobStatus.tasksCount()) : 0;
		float done = jobStatus.tasksCount() ? jobStatus.tasksDone() / float(jobStatus.tasksCount()) : 0;
		// If the number of done frames are the same, then sort by assigned frames
		if( fabs( done - other_done ) < 0.01 ) {
			float other_active = other.jobStatus.tasksCount() ? (other.jobStatus.tasksCount() - other.jobStatus.tasksUnassigned()) / float( other.jobStatus.tasksCount() ) : 0;
			float active = jobStatus.tasksCount() ? (jobStatus.tasksCount() - jobStatus.tasksUnassigned()) / float( jobStatus.tasksCount() ) : 0;
			if( fabs( other_active - active ) < 0.01 )
				return 0;
			return other_active > active ? 1 : -1;
		}
		return other_done > done ? 1 : -1;
	} else if( col == 16 ) {
		if( healthIsNull != other.healthIsNull )
			return int(healthIsNull) - int(other.healthIsNull);
		return (int)(100.0 * (jobStatus.health() - other.jobStatus.health()));
	} else if( col == 8 )
		return compareRetI( job.submittedts(), other.job.submittedts() );
	else if( col == 3 )
		return compareRetI( jobStatus.tasksCount(), other.jobStatus.tasksCount() );
	else if( col == 5 )
		return compareRetI( adjustedHostsOnJob(job.status(),jobStatus), adjustedHostsOnJob(other.job.status(),other.jobStatus) );
	else if( col == 6 )
		return compareRetI( job.priority(), other.job.priority() );
	else if( col == 9 )
		return compareRetI( jobStatus.errorCount(), other.jobStatus.errorCount() );
	else if( col == 11 )
		return compareRetI( jobStatus.tasksAverageTime(), other.jobStatus.tasksAverageTime() );
	else if( col == 17 )
		return compareRetI( job.endedts(), other.job.endedts() );
	else if( col == 18 ) {
		Interval tiq( job.submittedts(), job.endedts().isNull() ? QDateTime::currentDateTime() : job.endedts() );
		Interval otiq( other.job.submittedts(), other.job.endedts().isNull() ? QDateTime::currentDateTime() : other.job.endedts() );
		return compareRetI( tiq, otiq );
	}
    else if( col == 21 )
		return compareRetI( jobStatus.efficiency(), other.jobStatus.efficiency() );
    else if( col == 20 )
		return compareRetI( jobStatus.averageMemory(), other.jobStatus.averageMemory() );
    else if( col == 22 )
		return compareRetI( jobStatus.bytesWrite(), other.jobStatus.bytesWrite() );
    else if( col == 23 )
		return compareRetI( jobStatus.bytesRead(), other.jobStatus.bytesRead() );
    else if( col == 24 )
		return compareRetI( (jobStatus.opsWrite()+jobStatus.opsRead()), (other.jobStatus.opsWrite()+other.jobStatus.opsRead()) );
	else if( col == 25 )
		return compareRetI( jobStatus.cputime(), other.jobStatus.cputime() );
	return ItemBase::compare( a, b, col, asc );
}

Qt::ItemFlags JobItem::modelFlags( const QModelIndex & idx )
{
	Qt::ItemFlags ret( Qt::ItemIsSelectable | Qt::ItemIsEnabled );
	if( idx.model() && ((JobModel*)idx.model())->isDependencyTreeEnabled() )
		ret = Qt::ItemFlags( ret | Qt::ItemIsDragEnabled | Qt::ItemIsDropEnabled );
	return ret;
}

Record JobItem::getRecord() { return job; }

void GroupedJobItem::init( const QModelIndex & idx )
{
       Interval avgTimeInterval;
       int jobs=0;
       int slotCount=0;
       foreach( QModelIndex i, ModelIter::collect( idx.child(0,0) ) ) {
               if( JobTranslator::isType(i) ) {
                       JobItem & ji = JobTranslator::data(i);
                       avgTimeInterval += Interval( ji.jobStatus.tasksAverageTime() );
                       slotCount += adjustedHostsOnJob(ji.job.status(),ji.jobStatus);
                       jobs++;
               }
       }
       avgTime = (avgTimeInterval/qMax(1,jobs)).toDisplayString();
       slotsOnGroup = QString::number(slotCount);
    colorOption = options.mJobColors->getColorOption("ready");
}

QVariant GroupedJobItem::modelData( const QModelIndex & i, int role ) const
{
       if( role == Qt::DisplayRole && i.column() == 0 )
               return groupValue + " Jobs";
       if( role == Qt::DisplayRole && i.column() == 5 )
               return slotsOnGroup;
       if( role == Qt::DisplayRole && i.column() == 11 )
               return avgTime;
       if( role == Qt::DisplayRole && i.column() == groupColumn )
               return groupValue;
       if( role == Qt::DecorationRole && groupColumn == 12 && i.column() == 0 )
           return ((JobModel*)i.model())->jobTypeIcon(JobType::recordByName(groupValue));
       if ( role == Qt::TextColorRole )
           return colorOption ? civ(colorOption->fg) : QVariant();
       if( role == Qt::BackgroundColorRole )
           return colorOption ? civ(colorOption->bg) : QVariant();

       return ItemBase::modelData(i,role);
}

Qt::ItemFlags GroupedJobItem::modelFlags( const QModelIndex & )
{
       return Qt::ItemFlags(0);
}

bool GroupedJobItem::setModelData( const QModelIndex & i, const QVariant & value, int role )
{
       if( role == ModelGrouper::GroupingUpdate ) {
               init(i);
               return true;
       }
       if( role == ModelGrouper::GroupingColumn ) {
               groupColumn = value.toInt();
               return true;
       }
       if( role == ModelGrouper::GroupingValue ) {
               groupValue = value.toString();
               return true;
       }
       return false;
}

JobTreeBuilder::JobTreeBuilder( SuperModel * parent )
: RecordTreeBuilder( parent )
, mJobTranslator( new JobTranslator(this) )
{
       parent->grouper()->setGroupedItemTranslator( new GroupedJobTranslator(this) );
       setDefaultTranslator( mJobTranslator );
}

bool JobTreeBuilder::hasChildren( const QModelIndex & parentIndex, SuperModel * model )
{
	if( JobTranslator::isType(parentIndex) ) {
		return ((JobModel*)model)->isDependencyTreeEnabled() && JobDep::recordsByJob( ((JobModel*)model)->getRecord(parentIndex) ).size() > 0;
	}
	return false;
}

void JobTreeBuilder::loadChildren( const QModelIndex & parentIndex, SuperModel * model )
{
	if( JobTranslator::isType(parentIndex) )
		((JobModel*)model)->append( JobDep::recordsByJob( JobTranslator::getRecordStatic(parentIndex) ).deps(), parentIndex );
}

JobModel::JobModel( QObject * parent )
: RecordSuperModel( parent )
, mDependencyTreeEnabled( false )
{
	setTreeBuilder( new JobTreeBuilder(this) );
	connect( JobDep::table(), SIGNAL( added( RecordList ) ), SLOT( depsAdded( RecordList ) ) );
	connect( JobDep::table(), SIGNAL( removed( RecordList ) ), SLOT( depsRemoved( RecordList ) ) );
}

void JobModel::addRemoveWorker( JobDepList deps, bool removeDeps )
{
	JobList jobs = removeDeps ? deps.deps() : deps.jobs();
	QList<QPersistentModelIndex> toRemove;
	QList<QPersistentModelIndex> toSignalAdded;
	for( ModelIter it(this,ModelIter::Filter(ModelIter::Recursive | ModelIter::DescendLoadedOnly)); it.isValid(); ++it ) {
		QModelIndex i(*it);
		if( removeDeps ) {
			// Dont remove top level items, only items that exist from a jobdep relationship
			if( i.parent().isValid() && jobs.contains(getRecord(i)) )
				toRemove += i;
		} else {
			int index = jobs.findIndex( getRecord(i) );
			if( index >= 0 ) {
				if( childrenLoaded(i) ) {
					JobDep dep = deps[index];
					append( dep.dep(), i );
                    toSignalAdded += i;
				} else
					// This will cause a redraw, so that hasChildren will be called again and the + sign shown
					dataChanged( i, i );
			}
		}
	}
	foreach(QPersistentModelIndex pi, toRemove)
		if( pi.isValid() )
			remove( pi );
    foreach( JobDep jd, deps ) {
        // See if there's a top level item for this, if there isn't, add it
        QModelIndex topLevel = findIndex(jd.dep(),false);
        if( removeDeps && !topLevel.isValid() )
            append( jd.dep() );
        if( !removeDeps && topLevel.isValid() )
            remove( topLevel );
    }
    foreach(QPersistentModelIndex pi, toSignalAdded)
        if( pi.isValid() )
            emit dependencyAdded( pi );
}

QPixmap JobModel::jobTypeIcon( const JobType & jt )
{
	QMap<JobType,QPixmap>::iterator it = mJobTypeIconMap.find(jt);
	if( it == mJobTypeIconMap.end() ) {
		QImage img = jt.icon().scaled(16,16,Qt::IgnoreAspectRatio,Qt::SmoothTransformation);
		QPixmap pix = img.isNull() ? QPixmap() : QPixmap::fromImage(img);
		mJobTypeIconMap[jt] = pix;
		return pix;
	}
	return it.value();
}

void JobModel::depsAdded( RecordList rdeps )
{
	addRemoveWorker( rdeps, false );
}

void JobModel::depsRemoved( RecordList rdeps )
{
	addRemoveWorker( rdeps, true );
    foreach( JobDep jd, rdeps ) {
        // See if there's a top level item for this, if there isn't, add it
        QModelIndex topLevel = findIndex(jd.dep(),false);
        if( !topLevel.isValid() )
            append( jd.dep() );
    }
}

void JobModel::setDependencyTreeEnabled( bool dte )
{
	if( mDependencyTreeEnabled != dte ) {
		mDependencyTreeEnabled = dte;
		if( !dte ) {
			for( ModelIter it(this); it.isValid(); ++it )
				clearChildren(*it);
		}
	}
}

JobList dependencies( const Job & job )
{
	return JobDep::recordsByJob(job).deps();
}

bool checkForCircularDependencies( Job job, Job potentialDep )
{
	foreach( Job j, dependencies(potentialDep) ) {
		if( j == job ) return true;
		if( checkForCircularDependencies( job, j ) ) return true;
	}
	return false;
}

bool JobModel::dropMimeData ( const QMimeData * data, Qt::DropAction action, int row, int column, const QModelIndex & parent )
{
	RecordList rl;
	if( RecordDrag::decode( data, &rl ) ) {
		JobList dropped(rl.unique());
		Job target = getRecord(parent);
		LOG_5( "Jobs " + dropped.names().join(",") + " dropped on " + target.name() );
		foreach( Job pdep, dropped ) {
			if( pdep == target ) {
				LOG_5( "A job can't depend on itself" );
				continue;
			}
			if( checkForCircularDependencies( target, pdep ) ) {
				LOG_5( "Circular dependency detected, dependency request denied" );
				continue;
			}
			if( JobDep::recordByJobAndDep( target, pdep ).isRecord() ) {
				LOG_5( "Job " + target.name() + " " + QString::number(target.key()) + " already depends on job " + pdep.name() + " " + QString::number(pdep.key()) );
				continue;
			}
			if ( QMessageBox::warning( QApplication::activeWindow(), "Freezer: Confirm Dependency Creation",
				QString("You have requested to have job %1 depend on job %2.\n  The former will have status \"holding\" until the latter is done.\n  Are you sure you want this dependency?").arg(target.name()).arg(pdep.name()), QMessageBox::Yes | QMessageBox::No, QMessageBox::No ) != QMessageBox::Yes )
				continue;

			Database::current()->beginTransaction();
			JobDep dep;
			dep.setJob( target );
			dep.setDep( pdep );
			dep.commit();
			// Set job to holding if the dependency is not done
			if( pdep.status() != "done" && (QStringList() << "ready" << "started").contains(target.status()) )
				Job::updateJobStatuses( target, "holding", true );
			Database::current()->commitTransaction();
		}
		return true;
	}
	return RecordSuperModel::dropMimeData(data,action,row,column,parent);
}

/*
void JobHistoryCache::setup( const Record & r, const QModelIndex & ) {
	JobHistory jh(r);
	message = jh.message();
	user = jh.user();
	host = jh.host();
	created = jh.created();
}

QVariant JobHistoryCache::data( const QModelIndex & i, int role ) const {
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 0: return message;
			case 1: return user.name();
			case 2: return host.name();
			case 3: return created.toString();
		}
	}
	return QVariant();
}

int JobHistoryCache::cmp( const JobHistoryCache & other, const QModelIndex & a, const QModelIndex & b, bool )
{
	if( a.column() == 3 ) {
		return created == other.created ? 0 : (created > other.created ? 1 : -1);
	}
	QString dra = data(a,Qt::DisplayRole).toString().toUpper();
	QString drb = other.data(b,Qt::DisplayRole).toString().toUpper();
	return dra == drb ? 0 : (dra > drb ? 1 : -1);
}

Qt::ItemFlags JobHistoryCache::flags( const QModelIndex & ) { return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled ); }
Record JobHistoryCache::getRecord() { return Record(); }
*/
