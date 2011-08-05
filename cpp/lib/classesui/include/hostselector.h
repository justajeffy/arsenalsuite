
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
 * $LastChangedDate: 2010-02-10 15:06:55 +1100 (Wed, 10 Feb 2010) $
 * $Rev: 9329 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/classesui/include/hostselector.h $
 */

#ifndef HOST_SELECTOR_H
#define HOST_SELECTOR_H

#include <qstring.h>

#include "host.h"
#include "job.h"
#include "hoststatus.h"
#include "service.h"

#include "classesui.h"
#include "supermodel.h"
#include "recordsupermodel.h"
#include "ui_hostselectorbase.h"

#include "viewcolors.h"

class RecordModel;
class ColorOption;

CLASSESUI_EXPORT HostList hostListFromString( const QString & );

struct CLASSESUI_EXPORT GroupedHostItem : public ItemBase
{
    QString groupValue, slotsOnGroup;
    int groupColumn;
    ColorOption * colorOption;
    void init( const QModelIndex & idx );
    QVariant modelData( const QModelIndex & i, int role ) const;
    Qt::ItemFlags modelFlags( const QModelIndex & );
    bool setModelData( const QModelIndex & i, const QVariant & value, int role );
};

typedef TemplateDataTranslator<GroupedHostItem> GroupedHostTranslator;


class CLASSESUI_EXPORT HostItem : public RecordItemBase
{
public:
	Host host;
	HostStatus status;
	mutable bool jobsLoaded;
	mutable QString ver, mem, availMem, mhz, user, pulse, services, _jobName;
    QDateTime now, puppetPulse;
    QIcon puppetIcon;
	ColorOption * co;
	QString jobName() const;
	void setup( const Record & r, const QModelIndex &, bool loadJob = true );
	QVariant modelData( const QModelIndex & i, int role ) const;
	char getSortChar() const;
	int compare( const QModelIndex & a, const QModelIndex & b, int, bool );
	Qt::ItemFlags modelFlags( const QModelIndex & );
	Record getRecord();

	static const ColumnStruct host_columns [];
	static ViewColors * HostColors;

private:
    QString convertTime( int ) const;
};

typedef TemplateRecordDataTranslator<HostItem> HostTranslator;

class CLASSESUI_EXPORT HostSelector : public QDialog, public Ui::HostSelectorBase
{
Q_OBJECT
public:
	HostSelector(QWidget * parent=0);

	/// Checks the hosts according to the list
	void setHostList( const RecordList & );
	/// Checks the hosts according to a comma separated list of host names
	void setHostList( const QString & hostList );

	/// Returns a comma separated list of host names for each checked host in the list
	QString hostStringList() const;

	/// Returns the list of hosts that are checked
	HostList hostList() const;

	/// Returns the list of services required for each displayed host
	ServiceList serviceFilter() const;
	
	bool showingMyGroupsOnly() const;
public slots:

	void selectAll();

	void checkSelected();

	void uncheckSelected();

	void setShowMyGroupsOnly( bool );
	void refreshHostGroups();

	void hostGroupChanged( const Record & hg );

	/// Saves the current hostList() as a host group, prompts the user for info
	void saveHostGroup();

	/// Opens the Host Lists Dialog
	void manageHostLists();

	/// Sets the list of services required for each displayed host and calls refresh
	void setServiceFilter( ServiceList );

	/// Schedules a refresh of the list of hosts according to the current service filter
	void refresh();

	void showOptionsMenu();
protected slots:
	/// Performs the actual refresh
	void performRefresh();
	void performHostGroupRefresh();
protected:
	void setSelected(bool check);

	void updateList( HostList checked );

	bool mRefreshPending, mHostGroupRefreshPending;
	HostList mNeedsSelected;
	ServiceList mServiceFilter;
	RecordSuperModel * mModel;
	QAction * mShowMyGroupsOnlyAction, * mManageGroupsAction, * mSaveGroupAction;
};

#endif // HOST_SELECTOR_H

