
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of Assburner.
 *
 * Assburner is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Assburner is distributed in the hope that it will be useful,
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
 * $LastChangedDate: 2009-11-23 11:30:56 +1100 (Mon, 23 Nov 2009) $
 * $Rev: 9055 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/assfreezer/include/items.h $
 */

#ifndef ITEMS_H
#define ITEMS_H

#include <qtreewidget.h>
#include <qdatetime.h>
#include <qitemdelegate.h>
#include <qpainter.h>

#include "blurqt.h"

#include "employee.h"
#include "job.h"
#include "jobtask.h"
#include "jobtaskassignment.h"
#include "joberror.h"
#include "jobtype.h"
#include "jobstatus.h"
#include "jobservice.h"
#include "host.h"
#include "hoststatus.h"

#include "hostselector.h"
#include "recordtreeview.h"
#include "recordsupermodel.h"

#include "afcommon.h"
#include "displayprefsdialog.h"

#include <math.h>

class JobDepList;

// color if valid
QVariant civ( const QColor & c );

struct ASSFREEZER_EXPORT FrameItem : public RecordItemBase
{
	static QDateTime CurTime;
	JobTask task;
	JobTaskAssignment currentAssignment;
	QString hostName, label, time, memory, stat;
	ColorOption * co;
	int loadedStatus;
	void setup( const Record & r, const QModelIndex & );
	QVariant modelData( const QModelIndex & i, int role ) const;
	char getSortChar() const;
	int compare( const QModelIndex & a, const QModelIndex & b, int, bool );
	Qt::ItemFlags modelFlags( const QModelIndex & );
	Record getRecord();
};

typedef TemplateRecordDataTranslator<FrameItem> FrameTranslator;

struct ASSFREEZER_EXPORT ErrorItem : public RecordItemBase
{
	JobError error;
	QString hostName, cnt, when, msg;
	ColorOption * co;
	void setup( const JobError & r, const QModelIndex & );
	QVariant modelData( const QModelIndex & i, int role ) const;
	int compare( const QModelIndex & a, const QModelIndex & b, int, bool );
	Qt::ItemFlags modelFlags( const QModelIndex & ) const;
	Record getRecord();
};

struct ASSFREEZER_EXPORT HostErrorItem : public ErrorItem
{
	Job job;
	JobType jobType;
	QString services;
	void setup( const JobError & r, const QModelIndex & );
	QVariant modelData( const QModelIndex & i, int role ) const;
};

typedef TemplateRecordDataTranslator<ErrorItem> ErrorTranslator;
typedef TemplateRecordDataTranslator<HostErrorItem> HostErrorTranslator;
//typedef RecordModelImp<TreeNodeT<ErrorCache> > ErrorModel;

class ASSFREEZER_EXPORT ErrorModel : public RecordSuperModel
{
Q_OBJECT
public:
	ErrorModel( QObject * parent );
};

class ASSFREEZER_EXPORT HostErrorModel : public RecordSuperModel
{
Q_OBJECT
public:
	HostErrorModel( QObject * parent );

	void setErrors( JobErrorList errors, JobList jobs, JobServiceList services );

	JobList mJobs;
	QMap<Job,JobServiceList> mJobServicesByJob;
};

struct ASSFREEZER_EXPORT JobItem : public RecordItemBase
{
	Job job;
	JobStatus jobStatus;
	QPixmap icon;
	QString done, userName, hostsOnJob, priority, project, submitted, errorCnt, avgTime, type, ended, timeInQueue, services, avgMemory;
	bool healthIsNull;
	ColorOption * co;
	void setup( const Record & r, const QModelIndex & );
	QVariant modelData( const QModelIndex & i, int role ) const;
	int compare( const QModelIndex & a, const QModelIndex & b, int, bool );
	Qt::ItemFlags modelFlags( const QModelIndex & );
	Record getRecord();
    QString toolTip;

    QString efficiency, bytesRead, bytesWrite, diskOps, cpuTime;
};

typedef TemplateRecordDataTranslator<JobItem> JobTranslator;

class ASSFREEZER_EXPORT JobTreeBuilder : public ModelTreeBuilder
{
public:
	JobTreeBuilder( SuperModel * parent );
	virtual bool hasChildren( const QModelIndex & parentIndex, SuperModel * model );
	virtual void loadChildren( const QModelIndex & parentIndex, SuperModel * model );
protected:
	JobTranslator * mJobTranslator;
};

class ASSFREEZER_EXPORT JobModel : public RecordSuperModel
{
Q_OBJECT
public:
	JobModel( QObject * parent );

	bool dropMimeData ( const QMimeData * data, Qt::DropAction action, int row, int column, const QModelIndex & parent );

	bool isDependencyTreeEnabled() const { return mDependencyTreeEnabled; }
	void setDependencyTreeEnabled( bool );

	QPixmap jobTypeIcon( const JobType & );
public slots:
	void depsAdded(RecordList);
	void depsRemoved(RecordList);

signals:
    void dependencyAdded( const QModelIndex & parent );

protected:
	void addRemoveWorker( JobDepList, bool remove );

	bool mDependencyTreeEnabled;
	QMap<JobType,QPixmap> mJobTypeIconMap;
};

ASSFREEZER_EXPORT void setupJobView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void saveJobView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void setupHostView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void saveHostView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void setupHostErrorView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void saveHostErrorView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void setupErrorView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void saveErrorView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void setupFrameView( RecordTreeView *, IniConfig & );
ASSFREEZER_EXPORT void saveFrameView( RecordTreeView *, IniConfig & );

class ASSFREEZER_EXPORT ProgressDelegate : public QItemDelegate
{
Q_OBJECT
public:
	ProgressDelegate( QObject * parent=0 );
	~ProgressDelegate() {}

	virtual void paint ( QPainter * painter, const QStyleOptionViewItem & option, const QModelIndex & index ) const;
protected:
	ColorOption * mStartedColor, * mReadyColor, * mDoneColor;
};

class ASSFREEZER_EXPORT LoadedDelegate : public QItemDelegate
{
Q_OBJECT
public:
	LoadedDelegate( QObject * parent=0 ) : QItemDelegate( parent ) {}
	~LoadedDelegate() {}

	virtual void paint ( QPainter * painter, const QStyleOptionViewItem & option, const QModelIndex & index ) const;
};

class ASSFREEZER_EXPORT MultiLineDelegate : public QItemDelegate
{
Q_OBJECT
public:
	MultiLineDelegate( QObject * parent=0 ) : QItemDelegate( parent ) {}
	~MultiLineDelegate() {}

	QSize sizeHint(const QStyleOptionViewItem &option,
                              const QModelIndex &index) const;
};

#endif // ITEMS_H

