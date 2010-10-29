
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
 * $LastChangedDate: 2010-03-08 17:38:00 +1100 (Mon, 08 Mar 2010) $
 * $Rev: 9421 $
 * $HeadURL: svn://svn.blur.com/blur/branches/concurrent_burn/cpp/lib/classesui/src/hostselector.cpp $
 */

#include <qcheckbox.h>
#include <qcombobox.h>
#include <qmenu.h>
#include <qmessagebox.h>
#include <qpushbutton.h>
#include <qregexp.h>
#include <qtimer.h>
#include <qtreewidget.h>

#include "iniconfig.h"

#include "dynamichostgroup.h"
#include "employee.h"
#include "host.h"
#include "hostservice.h"
#include "hoststatus.h"
#include "hostgroup.h"
#include "hostgroupitem.h"
#include "hostlistsdialog.h"
#include "jobassignment.h"
#include "jobtaskassignment.h"
#include "jobtask.h"
#include "user.h"
#include "path.h"

#include "hostselector.h"
#include "ui_savelistdialogui.h"

const ColumnStruct HostItem::host_columns [] =
{
	{ "Host", "HostColumn", 100, 0, false, true },
	{ "Current Jobs", "CurrentJobColumn", 200, 1, false, false },
	{ "Status", "StatusColumn", 50, 2, false, true },
	{ "Frames", "FramesColumn", 50, 3, false, false },
	{ "OS", "OSColumn", 40, 4, false, true },
	{ "Memory", "MemoryColumn", 30, 5, false, true },
	{ "Mhz", "MhzColumn", 30, 6, false, true },
	{ "User", "UserColumn", 60, 7, false, true },
	{ "Packet Weight", "PacketWeightColumn", 40, 8, true, false },
	{ "Description", "DescriptionColumn", 200, 9, false, true },
	{ "Pulse", "PulseColumn", 50, 10, false, false },
	{ "Key", "KeyColumn", 0, 11, true, true },
	{ "OS Version", "OsVersionColumn", 40, 12, false, true },
	{ "CPU Name", "CpuNameColumn", 40, 13, false, true },
	{ "Arch", "ArchColumn", 40, 14, false, true },
	{ "Services", "ServicesColumn", 100, 15, true, false },
	{ "Avail. Mem", "AvailMemColumn", 40, 16, false, false },
	{ "Puppet Pulse", "PuppetPulseColumn", 50, 17, false, false },
	{ 0, 0, 0, 0, false, false }
};

ViewColors * HostItem::HostColors = 0;

void HostItem::setup( const Record & r, const QModelIndex &, bool loadJob ) {
	host = r;
	status = host.hostStatus();
	jobsLoaded = false;
	ver = host.os() + " " + host.abVersion();
	mem = QString("%1 Mb").arg(host.memory());
	availMem = QString("%1 Mb").arg(QString::number(status.availableMemory()));
	mhz = QString("%1 Mhz").arg(host.mhz()*host.cpus());
	user = host.user().name();
    now = QDateTime::currentDateTime();
    puppetPulse = QDateTime(host.puppetPulse());
    puppetIcon = ( puppetPulse < now.addSecs(-(6*60*60)) ) ? QIcon("images/exclamation.png") : QIcon("images/blank.png");
	pulse = convertTime( status.slavePulse().secsTo(now) );
	co = HostColors ? HostColors->getColorOption(status.slaveStatus()) : 0;
	services = QString();
	if( loadJob )
		_jobName = jobName();
}

QString HostItem::jobName() const
{
	if( !jobsLoaded ) {
        _jobName = host.activeAssignments().jobs().unique().names().join(", ");
		jobsLoaded = true;
	}
	return _jobName;
}

QString HostItem::convertTime( int secs ) const
{
    int time = secs;
    QString format = "second";

    if ( time > 60 ) {
        time  /= 60;
        format = "minute";

        if ( time > 60 ) {
            time  /= 60;
            format = "hour";

            if ( time > 24 ) {
                time  /= 24;
                format = "day";
            }
        }
    }

    return QString("%1 %2%3 ago").arg(QString::number(time), format, ( time > 1 ) ? QString("s") : QString(""));
}

static QVariant civ( const QColor & c )
{
	if( c.isValid() )
		return QVariant(c);
	return QVariant();
}

QVariant HostItem::modelData( const QModelIndex & i, int role ) const
{
	int col = i.column();
	if( role == Qt::DisplayRole ) {
		switch( col ) {
			case 0: return host.name();
			case 1: return _jobName;
			case 2: return status.slaveStatus();
			case 3: return QString();
			case 4: return ver;
			case 5: return mem;
			case 6: return mhz;
			case 7: return user;
			case 8: return "";
			case 9: return host.description();
			case 10: return pulse;
			case 11: return host.key();
			case 12: return host.osVersion();
			case 13: return host.cpuName();
			case 14: return host.architecture();
			case 15:
			{
				if( services.isNull() ) {
					services = host.hostServices().services().sorted("service").services().join(",");
					if( services.isNull() ) services = QString("");
				}
				return services;
			}
			case 16: return availMem;
			case 17: return ( puppetPulse.toString() != "" ) ? convertTime( puppetPulse.secsTo(now) ) : QString();
		}
	} else if ( role == Qt::TextColorRole )
		return co ? civ(co->fg) : QVariant();
	else if( role == Qt::BackgroundColorRole )
		return co ? civ(co->bg) : QVariant();
    else if ( role == Qt::DecorationRole ) {
        if ( col == 17 )
            return QVariant( puppetIcon );
    }

	return QVariant();
}

char HostItem::getSortChar() const {
	QString stat = status.slaveStatus();
	if( stat=="ready" ) return 'a';
	else if( stat=="assigned" ) return 'b';
	else if( stat=="copy" ) return 'c';
	else if( stat=="busy" ) return 'd';
	else if( stat=="starting" ) return 'e';
	else if( stat=="waking" ) return 'f';
	else if( stat=="sleep" ) return 'g';
	else if( stat=="sleeping" ) return 'h';
	else if( stat=="client-update" ) return 'i';
	else if( stat=="restart" ) return 'j';
	else if( stat=="restart-when-done" ) return 'k';
	else if( stat=="reboot" ) return 'l';
	else if( stat=="reboot-when-done" ) return 'm';
	else if( stat=="stopping" ) return 'n';
	else if( stat=="offline" ) return 'o';
	else if( stat=="no-pulse" ) return 'p';
	else if( stat=="no-ping" ) return 'q';
	else return 'z';
}

int HostItem::compare( const QModelIndex & a, const QModelIndex & b, int col, bool asc )
{
	HostItem & other = HostTranslator::data(b);
	if( col == 2 ) {
		char sc = getSortChar(), osc = other.getSortChar();
		if( sc == osc ) return 0;
		if( sc > osc ) return 1;
		return -1;
	}
	if( col >= 5 && col <= 6 ) {
		int vala = col == 5 ? host.memory() : host.mhz();
		int valb = col == 5 ? other.host.memory() : other.host.mhz();
		return vala - valb;
	}
    if( col == 10 || col == 17 ) {
        int datea = col == 10 ? now.secsTo( status.slavePulse() ) : now.secsTo( puppetPulse );
        int dateb = col == 10 ? now.secsTo( other.status.slavePulse() ) : now.secsTo( other.puppetPulse );
        return datea - dateb;
    }
	return ItemBase::compare(a,b,col,asc);
}

Qt::ItemFlags HostItem::modelFlags( const QModelIndex & )
{ return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled ); }

Record HostItem::getRecord()
{ return host; }

struct HostListItem : public HostItem {
	bool checked;
	void setup( const Record & r, const QModelIndex & i ) {
		HostItem::setup(r,i, false /*loadJob*/);
		checked = false;
	}
	QVariant modelData( const QModelIndex & i, int role ) const {
		int col = i.column();
		if( role == Qt::DisplayRole ) {
			switch( col ) {
				case 0: return host.name();
				case 1: return status.slaveStatus();
				case 2: return ver;
				case 3: return mem;
				case 4: return mhz;
				case 5: return user;
				case 6: return host.description();
			}
		} else if ( role == Qt::TextColorRole )
			return co ? civ(co->fg) : QVariant();
		else if( role == Qt::CheckStateRole && col == 0 )
			return checked ? Qt::Checked : Qt::Unchecked;
		return QVariant();
	}

	bool setModelData( const QModelIndex & i, const QVariant & v, int role ) {
		if( role == Qt::CheckStateRole && i.column() == 0 ) {
			checked = v.toInt() == Qt::Checked;
			return true;
		}
		return false;
	}

	int compare( const QModelIndex & a, const QModelIndex & b, int col, bool asc );

	Qt::ItemFlags modelFlags( const QModelIndex & i )
	{
		if( i.column() == 0 )
			return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemIsUserCheckable );
		return Qt::ItemFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled );
	}
};

typedef TemplateRecordDataTranslator<HostListItem> HostListTranslator;

int HostListItem::compare( const QModelIndex & a, const QModelIndex & b, int col, bool asc )
{
	HostListItem & other = HostListTranslator::data(b);
	if( col == 1 ) {
		char sc = getSortChar(), osc = other.getSortChar();
		if( sc == osc ) return 0;
		if( sc > osc ) return 1;
		return -1;
	}
	if( col >= 3 && col <= 4 ) {
		int vala = col == 3 ? host.memory() : host.mhz();
		int valb = col == 3 ? other.host.memory() : other.host.mhz();
		return vala - valb;
	}
	return ItemBase::compare(a,b,col,asc);
}

HostSelector::HostSelector( QWidget * parent )
: QDialog( parent )
, mRefreshPending( false )
, mHostGroupRefreshPending( false )
{
	HostSelectorBase::setupUi( this );

	mModel = new RecordSuperModel( mHostTree );
	new HostListTranslator(mModel->treeBuilder());
	mHostTree->setModel( mModel );
	mModel->setHeaderLabels( QStringList() << "Host" << "Status" << "Version" << "Memory" << "Mhz" << "User" << "Description" );

    for( int i=0; i < mModel->columnCount(); i++ )
        mHostTree->setColumnAutoResize(i,true);

	mModel->setAutoSort(true);
	mModel->sort(0,Qt::DescendingOrder);
	connect( SelectAll, SIGNAL( clicked() ), SLOT( selectAll() ) );
	connect( CheckSelected, SIGNAL( clicked() ), SLOT( checkSelected() ) );
	connect( UnCheckSelected, SIGNAL( clicked() ), SLOT( uncheckSelected() ) );

	mShowMyGroupsOnlyAction = new QAction( "Show My Lists Only", this );
	mShowMyGroupsOnlyAction->setCheckable( true );
	IniConfig & cfg = userConfig();
	cfg.pushSection( "HostSelector" );
	mShowMyGroupsOnlyAction->setChecked( cfg.readBool( "ShowMyGroupsOnly", false ) );
	cfg.popSection();

	mManageGroupsAction = new QAction( "Manage My Lists", this );
	mSaveGroupAction = new QAction( "Save Current List", this );
	
	connect( mHostGroupCombo,SIGNAL( currentChanged( const Record & ) ), SLOT( hostGroupChanged( const Record & ) ) );
	connect( mSaveGroupAction, SIGNAL( triggered() ), SLOT( saveHostGroup() ) );
	connect( mManageGroupsAction, SIGNAL( triggered() ), SLOT( manageHostLists() ) );
	connect( mShowMyGroupsOnlyAction, SIGNAL( toggled(bool) ), SLOT( setShowMyGroupsOnly(bool) ) );
	connect( mOptionsButton, SIGNAL( clicked() ), SLOT( showOptionsMenu() ) );

	mHostGroupCombo->setColumn( "name" );

	refreshHostGroups();
}

void HostSelector::showOptionsMenu()
{
	QMenu * menu = new QMenu(this);
	menu->addAction( mShowMyGroupsOnlyAction );
	menu->addSeparator();
	menu->addAction( mSaveGroupAction );
	menu->addAction( mManageGroupsAction );
	menu->exec( QCursor::pos() );
	delete menu;
}

HostList hostListFromString( const QString & hostList )
{
	HostList hosts;
	QStringList sl = hostList.split(',');
	foreach( QString hn, sl ) {
		Host h = Host::recordByName( hn );
		LOG_3( QString(h.isRecord() ? "Found host " : "Unknown host ") + hn );
		if( h.isRecord() ) hosts += h;
	}
	return hosts;
}

void HostSelector::refresh()
{
	if( !mRefreshPending ) {
		QTimer::singleShot( 0, this, SLOT( performRefresh() ) );
		mRefreshPending = true;
	}
}

void HostSelector::performRefresh()
{
	HostList hl;
	if( mServiceFilter.isEmpty() )
		hl = Host::select();
	else
		// Fancy select because we need hosts that have ALL services, not any of the services in the filter.
		hl = Host::select( "WHERE keyhost IN (SELECT fkeyhost FROM "
			" (SELECT count(*), fkeyhost"
            " FROM HostService"
            " WHERE HostService.fkeyservice IN (" + mServiceFilter.keyString() + ")"
            " AND HostService.enabled=true GROUP BY fkeyhost) AS iq "
			"WHERE count=?)", VarList() << mServiceFilter.size() );
	HostStatusList hsl = HostStatus::select( "fkeyhost in (" + hl.keyString() + ")" );
	mModel->updateRecords( hl );

	if( !mNeedsSelected.isEmpty() ) {
                updateList( mNeedsSelected );
	}
	mRefreshPending = false;
}

void HostSelector::setHostList( const QString & hostList )
{
        mNeedsSelected = hostListFromString(hostList);
        performRefresh();
}

void HostSelector::setHostList( const RecordList & hrl )
{
	updateList(hrl);
}

void HostSelector::updateList( HostList checked )
{
	if( mRefreshPending ) {
		mNeedsSelected = checked;
		return;
	}

	int rows = mModel->rowCount();
	for( int r=0; r<rows; r++ ) {
		QModelIndex i = mModel->index(r,0);
		mModel->setData( i, QVariant(checked.contains(mModel->getRecord(i)) ? Qt::Checked : Qt::Unchecked), Qt::CheckStateRole );
	}
}

void HostSelector::refreshHostGroups()
{
	if( !mHostGroupRefreshPending ) {
		QTimer::singleShot( 0, this, SLOT( performHostGroupRefresh() ) );
		mHostGroupRefreshPending = true;
	}
}

void HostSelector::performHostGroupRefresh()
{
	mHostGroupRefreshPending = false;
	HostGroup hg;
	hg.setName( "Custom List" );
	HostGroupList hgl = HostGroup::select( "fkeyusr=? or private is null or private=false", VarList() << User::currentUser().key() ).sorted( "name" );
	if( mShowMyGroupsOnlyAction->isChecked() )
		hgl = hgl.filter( "fkeyusr", User::currentUser().key() );
	hgl.insert(hgl.begin(),hg);
	mHostGroupCombo->setItems( hgl );
}

void HostSelector::setShowMyGroupsOnly( bool showMyGroupsOnly )
{
	IniConfig & cfg = userConfig();
	cfg.pushSection( "HostSelector" );
	cfg.writeBool( "ShowMyGroupsOnly", showMyGroupsOnly );
	cfg.popSection();
	mShowMyGroupsOnlyAction->setChecked( showMyGroupsOnly );
	refreshHostGroups();
}

bool HostSelector::showingMyGroupsOnly() const
{
	return mShowMyGroupsOnlyAction->isChecked();
}

void HostSelector::hostGroupChanged( const Record & hgr )
{
	if( hgr.isRecord() )
		updateList(HostGroup(hgr).hosts());
}

void HostSelector::saveHostGroup()
{
	QDialog * sld = new QDialog( this );
	Ui::SaveListDialogUI ui;
	ui.setupUi( sld );

	ui.mNameCombo->addItems( HostGroup::recordsByUser( User::currentUser() ).filter( "name", QRegExp( "^.+$" ) ).sorted( "name" ).names() );
	ui.mNameCombo->addItems( HostGroup::recordsByUser( User() ).filter( "name", QRegExp( "^.+$" ) ).sorted( "name" ).names() );

	HostGroup cur_hg(mHostGroupCombo->current());
	if( cur_hg.isRecord() ) {
		int idx = ui.mNameCombo->findText( cur_hg.name() );
		if( idx >= 0 )
			ui.mNameCombo->setCurrentIndex( idx );

		if( !cur_hg.user().isRecord() )
			ui.mGlobalCheck->setChecked( true );
	}

	if( sld->exec() ) {
		HostGroup hg = HostGroup::recordByNameAndUser( ui.mNameCombo->currentText(), ui.mGlobalCheck->isChecked() ? User() : User::currentUser() );
		if( hg.isRecord() &&
			QMessageBox::question( this, "Overwrite Host List?"
				,"This will overwrite the existing list: " + hg.name() + "\nAre you sure you want to continue?"
				, QMessageBox::Yes, QMessageBox::No ) != QMessageBox::Yes
			)
			return;

		//
		// Commit the host group
		hg.setName( ui.mNameCombo->currentText() );
		hg.setUser( User::currentUser() );
		hg.setPrivate_( !ui.mGlobalCheck->isChecked() );
		hg.commit();

		// Gather existing hostgroup items
		QMap<Host,HostGroupItem> exist;
		HostGroupItemList com;

		HostGroupItemList hgl = HostGroupItem::recordsByHostGroup( hg );
		foreach( HostGroupItem hgi, hgl )
			exist[hgi.host()] = hgi;
	
		// Commit the items
		HostList hl = hostList();
		foreach( Host h, hl ) {
			HostGroupItem hgi;
			if( exist.contains( h ) ) {
				hgi = exist[h];
				exist.remove( h );
			}
			hgi.setHostGroup(hg);
			hgi.setHost(h);
			com += hgi;
		}
		com.commit();
		
		// Delete the old ones
		HostGroupItemList toRemove;
		for( QMap<Host,HostGroupItem>::Iterator it = exist.begin(); it != exist.end(); ++it )
			toRemove += it.value();
		toRemove.remove();
	}
	refreshHostGroups();
}

void HostSelector::manageHostLists()
{
	HostListsDialog * hld = new HostListsDialog( this );
	hld->show();
	hld->exec();
	delete hld;
}

HostList HostSelector::hostList() const
{
	HostList ret = mModel->getRecords( ModelIter::collect( mModel, ModelIter::Checked ) );
	LOG_5( "Found " + QString::number( ret.size() ) + " checked hosts" );
	return ret;
}

QString HostSelector::hostStringList() const
{
	QString ret = hostList().names().join(",");
	LOG_5( ret );
	return ret;
}

void HostSelector::setSelected( bool check )
{
	QItemSelection sel = mHostTree->selectionModel()->selection();
	foreach( QItemSelectionRange r, sel ) {
		if( r.left() > 0 ) continue;
		for( int i = r.top(); i<= r.bottom(); i++ )
			mModel->setData( mModel->index( i, 0, r.parent() ), QVariant(check ? Qt::Checked : Qt::Unchecked), Qt::CheckStateRole );
	}
}

void HostSelector::selectAll()
{
	mHostTree->selectionModel()->select(
		  QItemSelection(
			  mModel->index(0,0)
			, mModel->index(mModel->rowCount()-1,mModel->columnCount()-1)
		  )
		, QItemSelectionModel::ClearAndSelect );
}

void HostSelector::checkSelected()
{
	setSelected( true );
}

void HostSelector::uncheckSelected()
{
	setSelected( false );
}

void HostSelector::setServiceFilter( ServiceList sl )
{
	mServiceFilter = sl;
	refresh();
}

ServiceList HostSelector::serviceFilter() const
{
	return mServiceFilter;
}

