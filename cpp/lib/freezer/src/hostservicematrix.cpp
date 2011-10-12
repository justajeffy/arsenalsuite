
#include <qcombobox.h>
#include <qheaderview.h>
#include <qinputdialog.h>
#include <qmessagebox.h>
#include <qmenu.h>
#include <qtimer.h>

#include "iniconfig.h"

#include "hostservicematrix.h"
#include "qvariantcmp.h"
#include "syslog.h"
#include "syslogrealm.h"
#include "syslogseverity.h"
#include "user.h"
#include "hostgroup.h"
#include "hostlistsdialog.h"

#include "ui_savelistdialogui.h"

struct HostServiceItem : public RecordItem
{
	Host mHost;
	HostStatus mHostStatus;
	void setup( const Record & r, const QModelIndex & );
	QVariant modelData ( const QModelIndex & index, int role ) const;
	bool setModelData( const QModelIndex & idx, const QVariant & v, int role );
	int compare( const QModelIndex & a, const QModelIndex & b, int, bool );
	Qt::ItemFlags modelFlags( const QModelIndex & );
	Record getRecord();
	static HostServiceModel * model(const QModelIndex &);
};

typedef TemplateRecordDataTranslator<HostServiceItem> HostServiceTranslator;

HostServiceModel * HostServiceItem::model(const QModelIndex & idx)
{
	return const_cast<HostServiceModel*>(qobject_cast<const HostServiceModel*>(idx.model()));
}

void HostServiceItem::setup( const Record & r, const QModelIndex & )
{
	mHost = r;
	mHostStatus = mHost.hostStatus();
	LOG_5( "Setting up host " + mHost.name() );
}

static int hsSortVal( const HostService & hs )
{
	if( !hs.isRecord() ) return 0;
	if( hs.enabled() ) return 2;
	return 1;
}

int HostServiceItem::compare( const QModelIndex & a, const QModelIndex & b, int column, bool asc )
{
	if( column == 0 ) return ItemBase::compare( a, b, column, asc );
	HostServiceModel * m = model(a);
	HostService hs = m->findHostService( mHost, column );
	HostService ohs = m->findHostService( HostServiceTranslator::data(b).mHost, column );
	return compareRetI( hsSortVal( hs ), hsSortVal( ohs ) );
}

QVariant HostServiceItem::modelData( const QModelIndex & idx, int role ) const
{
	if( role == Qt::DisplayRole || role == Qt::EditRole || role == Qt::ForegroundRole ) {
		if( idx.column() == 0 ) return mHost.name();
        if( idx.column() == 1 ) return mHostStatus.slaveStatus();
        if( idx.column() == 2 ) return mHost.os();
        if( idx.column() == 3 ) return mHost.userIsLoggedIn() ? "Logged On" : "Logged Off";

		HostServiceModel * m = model(idx);
		if( role == Qt::EditRole )
			return qVariantFromValue<Record>(m->findHostService( mHost, idx.column() - 3));
		QVariant d = m->serviceData( mHost, idx.column() - 3, role );
		if( role == Qt::ForegroundRole ) {
			QString txt = d.toString();
			return (txt == "Enabled" ? Qt::green : (txt == "Disabled" ? Qt::red : Qt::black));
		}
		return d;
	}
	return QVariant();
}

bool HostServiceItem::setModelData( const QModelIndex & idx, const QVariant & v, int role )
{
	if( role == Qt::EditRole && idx.column() > 3 ) {
		HostServiceModel * m = model(idx);
		HostService hs = m->findHostService( mHost, idx.column() - 3);
		switch( v.toInt() ) {
			case 0:
			case 1:
				hs.setEnabled( v.toInt() == 0 );
				hs.commit();
				break;
			case 2:
				hs.remove();
		}
		return true;
	}
	return false;
}

Qt::ItemFlags HostServiceItem::modelFlags( const QModelIndex & idx )
{
	Qt::ItemFlags ret = Qt::ItemIsSelectable | Qt::ItemIsEnabled;
	return idx.column() < 4 ? ret : Qt::ItemFlags(ret | Qt::ItemIsEditable);
}

Record HostServiceItem::getRecord()
{
	return mHost;
}

HostServiceModel::HostServiceModel( QObject * parent )
: RecordSuperModel( parent )
{
	new HostServiceTranslator(treeBuilder());

	// Set HostService index to cache
	updateServices();

    // Initialize the list
    currentFilteredList = Host::select();

    hostFiltering = statusFiltering = osFiltering = userFiltering = false;
}

void HostServiceModel::updateServices()
{
	Index * i = HostService::table()->index( "HostAndService" );
	if( i ) i->setCacheEnabled( true );
	HostService::schema()->setPreloadEnabled( true );
	mServices = Service::select().sorted( "service" );
	LOG_5( mServices.services().join(",") );
	setHeaderLabels( QStringList() << "Host" << "Status" << "OS" << "User Logged" << mServices.services() );
	HostList hosts = Host::select();
	// Keep the list in memory until the items can store each hoststatus record
	HostStatusList statuses = HostStatus::select();
	LOG_5( "setRootList: Adding " + QString::number(hosts.size()) + " hosts" );
	setRootList( hosts );
}

HostService HostServiceModel::findHostService( const Host & host, int column ) const
{
	column -= 1;
	if( column < 0 || column >= (int)mServices.size() ) return HostService();
	Service s = mServices[column];
	HostService ret = HostService::recordByHostAndService( host, s );
	if( !ret.isRecord() ) {
		ret.setHost( host );
		ret.setService( s );
	}
	return ret;
}

HostService HostServiceModel::findHostService( const QModelIndex & idx ) const
{
	return findHostService( getRecord(idx), idx.column() - 3);
}

QVariant HostServiceModel::serviceData ( const Host & host, int column, int ) const
{
	HostService hs = findHostService( host, column );
	if( hs.isRecord() )
		return hs.enabled() ? "Enabled" : "Disabled";
	return "No Service";
}

void HostServiceModel::setHostFilter( const QString & filter, bool cascading )
{
    currentHostFilter = filter;

    if( filter != "" ) {
        hostFiltering = true;

        if( cascading )
            currentFilteredList = currentFilteredList.filter( "name", QRegExp( filter ) );
        else
            currentFilteredList = Host::select().filter( "name", QRegExp( filter ) );
    } else {
        hostFiltering = false;

        currentFilteredList = Host::select();
    }

    if( !cascading ) {
        if( statusFiltering )
            setStatusFilter( currentStatusFilter , true);
        if( osFiltering )
            setOSFilter( currentOsFilter , true);
        if( userFiltering )
            setUserLoggedFilter( userFiltering , true);
    }

  	setRootList( currentFilteredList );
}

void HostServiceModel::setStatusFilter( const QString & filter , bool cascading)
{
    currentStatusFilter = filter;

    if( filter != "" ) {
        statusFiltering = true;
        
        if( cascading ) {
            HostStatusList statuses = currentFilteredList.hostStatuses().filter( "slavestatus", QRegExp( filter ));
            currentFilteredList = statuses.hosts();
        } else {
            HostStatusList statuses = HostStatus::select().filter( "slavestatus", QRegExp( filter ));
            currentFilteredList = statuses.hosts();
        }
    } else {
        statusFiltering = false;

        currentFilteredList = Host::select();
    }

    if( !cascading ) {
        if( hostFiltering )
            setHostFilter( currentHostFilter , true);
        if( osFiltering )
            setOSFilter( currentOsFilter , true);
        if( userFiltering )
            setUserLoggedFilter( userFiltering , true);
    }

    setRootList( currentFilteredList );
}

void HostServiceModel::setOSFilter( const QString & filter , bool cascading)
{
    currentOsFilter = filter;

    if( filter != "" ) {
        osFiltering = true;

        if( cascading )
            currentFilteredList = currentFilteredList.filter( "os", QRegExp( filter ) );
        else
            currentFilteredList = Host::select().filter( "os", QRegExp( filter ) );
    } else {
        osFiltering = false;

        currentFilteredList = Host::select();
    }

    if( !cascading ) {
        if( hostFiltering )
            setHostFilter( currentHostFilter , true);
        if( statusFiltering )
            setStatusFilter( currentStatusFilter , true);
        if( userFiltering )
            setUserLoggedFilter( userFiltering , true);
    }

    setRootList( currentFilteredList );
}

void HostServiceModel::setUserLoggedFilter( bool filter, bool useLoggedIn, bool cascading)
{
    if( filter ) {
        userFiltering = true;

        if( cascading )
            currentFilteredList = currentFilteredList.filter( "userisloggedin", useLoggedIn );
        else
            currentFilteredList = Host::select().filter( "userisloggedin", useLoggedIn );
    } else {
        userFiltering = false;

        currentFilteredList = Host::select();
    }

    if( !cascading ) {
        if( hostFiltering )
            setHostFilter( currentHostFilter , true);
        if( statusFiltering )
            setStatusFilter( currentStatusFilter , true);
        if( osFiltering )
            setOSFilter( currentOsFilter , true);
    }

    setRootList( currentFilteredList );
}

class HostServiceDelegate : public RecordDelegate
{
public:
	HostServiceDelegate ( QObject * parent = 0 )
	: RecordDelegate( parent )
	{}

	QWidget * createEditor ( QWidget * parent, const QStyleOptionViewItem & option, const QModelIndex & index ) const
	{
		if( !index.isValid() ) return 0;
		QVariant v = index.model()->data(index, Qt::EditRole);
		uint t = v.userType();
		if( t == static_cast<uint>(qMetaTypeId<Record>()) ) {
			QComboBox * ret = new QComboBox(parent);
			ret->addItems( QStringList() << "Enabled" << "Disabled" << "No Service" );
			ret->setCurrentIndex( 2 - hsSortVal( qVariantValue<Record>(v) ) );
			ret->installEventFilter(const_cast<HostServiceDelegate*>(this));
			return ret;
		}
		return RecordDelegate::createEditor(parent,option,index);
	}

	void setModelData ( QWidget * editor, QAbstractItemModel * model, const QModelIndex & index ) const
	{
		if( editor->inherits( "QComboBox" ) ) {
			QComboBox * combo = (QComboBox*)editor;
			model->setData(index, combo->currentIndex(),Qt::EditRole);
			return;
		}
		RecordDelegate::setModelData(editor,model,index);
	}

	void setEditorData ( QWidget * editor, const QModelIndex & index ) const
	{
		if( editor->inherits( "QComboBox" ) ) {
			QComboBox * combo = (QComboBox*)editor;
			QVariant v = index.model()->data(index, Qt::EditRole);
			combo->setCurrentIndex( 2 - hsSortVal( qVariantValue<Record>(v) ) );
			return;
		}
		RecordDelegate::setEditorData(editor,index);
	}
};

HostServiceMatrix::HostServiceMatrix( QWidget * parent )
: RecordTreeView( parent )
{
	mModel = new HostServiceModel(this);
	setModel( mModel );
	setItemDelegate( new HostServiceDelegate(this) );
	connect( this, SIGNAL( showMenu( const QPoint &, const QModelIndex & ) ), SLOT( slotShowMenu( const QPoint &, const QModelIndex & ) ) );

    hostFTimer = new QTimer(this);
    statusFTimer = new QTimer(this);
    osFTimer = new QTimer(this);

    connect( hostFTimer, SIGNAL(timeout()), this, SLOT( hostTimerExpired() ) );
    connect( statusFTimer, SIGNAL(timeout()), this, SLOT( statusTimerExpired() ) );
    connect( osFTimer, SIGNAL(timeout()), this, SLOT( osTimerExpired() ) );

    hostFTimer->setSingleShot( true );
    statusFTimer->setSingleShot( true );
    osFTimer->setSingleShot( true );

	setSelectionBehavior( QAbstractItemView::SelectItems );
	header()->setStretchLastSection( false );

	connect( Service::table(), SIGNAL( added(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( removed(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( updated(Record,Record) ), SLOT( updateServices() ) );

    userFiltering = false;
}

HostServiceModel * HostServiceMatrix::getModel() const
{
    return mModel;
}

void HostServiceMatrix::setHostFilter( const QString & filter )
{
	mHostFilter = filter;
    hostFTimer->start(300);
}

void HostServiceMatrix::hostTimerExpired()
{
    mModel->setHostFilter( mHostFilter );
}

void HostServiceMatrix::setStatusFilter( const QString & filter )
{
    mHostStatusFilter = filter;
    statusFTimer->start(300);
}

void HostServiceMatrix::statusTimerExpired()
{
    mModel->setStatusFilter( mHostStatusFilter );
}

void HostServiceMatrix::setOSFilter( const QString & filter )
{
    mHostOsFilter = filter;
    osFTimer->start(300);
}

void HostServiceMatrix::osTimerExpired()
{
    mModel->setOSFilter( mHostOsFilter );
}

void HostServiceMatrix::setUserLoggedFilter( int filter )
{
    userFiltering = filter > 0;
    mModel->setUserLoggedFilter( filter > 0 , useLoggedIn);
}

void HostServiceMatrix::setUserLoggedType( bool type )
{
    useLoggedIn = type;
    if( userFiltering )
        mModel->setUserLoggedFilter( true, useLoggedIn );
}

void HostServiceMatrix::setServiceFilter( const QString & filter )
{
	mServiceFilter = filter;
	QHeaderView * h = header();
	QRegExp re(filter);
	for( int i=1; i < h->count(); i++ )
		h->setSectionHidden( i, !model()->headerData(i, Qt::Horizontal, Qt::DisplayRole ).toString().contains( re ) );
}

void HostServiceMatrix::updateServices()
{
	mModel->updateServices();
	setServiceFilter( mServiceFilter );
}

void HostServiceMatrix::slotShowMenu( const QPoint & pos, const QModelIndex & /*underMouse*/ )
{
	QItemSelection sel = selectionModel()->selection();
	if( !sel.isEmpty() ) {
		QMenu * menu = new QMenu( this );
		QAction * en = menu->addAction( "Set Enabled" );
		QAction * dis = menu->addAction( "Set Disabled" );
		//QAction * nos = 
		menu->addAction( "Set No Service" );
		QAction * result = menu->exec(pos);
		if( result ) {
			HostServiceList toUpdate;
			foreach( QModelIndex idx, sel.indexes() ) {
				HostService hs = mModel->findHostService( idx );
				hs.setEnabled( result == en );
				toUpdate += hs;
			}
			if( result == en || result == dis ) {
				toUpdate.commit();
                SysLog log;
                log.setSysLogRealm( SysLogRealm::recordByName("Farm") );
                log.setSysLogSeverity( SysLogSeverity::recordByName("Warning") );
                log.setMessage( QString("%1 host services modified").arg(toUpdate.size()) );
                log.set_class("UserServiceMatrix");
                log.setMethod("slotShowMenu");
                log.setUserName( User::currentUser().name() );
                log.setHostName( Host::currentHost().name() );
                log.commit();
			} else {
				toUpdate.remove();
                SysLog log;
                log.setSysLogRealm( SysLogRealm::recordByName("Farm") );
                log.setSysLogSeverity( SysLogSeverity::recordByName("Warning") );
                log.setMessage( QString("%1 host services removed").arg(toUpdate.size()) );
                log.set_class("HostServiceMatrix");
                log.setMethod("slotShowMenu");
                log.setUserName( User::currentUser().name() );
                log.setHostName( Host::currentHost().name() );
                log.commit();
            }
		}
		delete menu;
	}
}

HostServiceMatrixWindow::HostServiceMatrixWindow( QWidget * parent )
: QMainWindow( parent )
, mHostGroupRefreshPending(false)
{
	setupUi(this);

	setWindowTitle( "Edit Host Services" );

	mView = new HostServiceMatrix( mCentralWidget );
	mCentralWidget->layout()->addWidget(mView);
	mView->show();
	connect( mHostFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setHostFilter( const QString & ) ) );
    connect( mHostStatusFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setStatusFilter( const QString & ) ) );
    connect( mHostOsFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setOSFilter( const QString & ) ) );
    connect( mHostUserLoggedInCheckbox, SIGNAL( stateChanged( int ) ), mView, SLOT( setUserLoggedFilter( int ) ) );
    connect( mUserLoggedInType, SIGNAL( toggled( bool ) ), mView, SLOT( setUserLoggedType( bool ) ) );

	connect( mServiceFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setServiceFilter( const QString & ) ) );
	QMenu * fileMenu = menuBar()->addMenu( "&File" );
	fileMenu->addAction( "&New Service", this, SLOT( newService() ) );
	fileMenu->addSeparator();
	fileMenu->addAction( "&Close", this, SLOT( close() ) );

    mShowMyGroupsOnlyAction = new QAction( "Show My Lists Only", this );
    mShowMyGroupsOnlyAction->setCheckable( true );
    IniConfig & cfg = userConfig();
    cfg.pushSection( "HostSelector" );
    mShowMyGroupsOnlyAction->setChecked( cfg.readBool( "ShowMyGroupsOnly", false ) );
    cfg.popSection();

    mManageGroupsAction = new QAction( "Manage My Lists", this );
    mSaveGroupAction = new QAction( "Save Current List", this );

    connect( mHostGroupCombo, SIGNAL( currentChanged( const Record & ) ), SLOT( hostGroupChanged( const Record & ) ) );
    connect( mOptionsButton, SIGNAL( clicked() ), SLOT( showOptionsMenu() ) );
    connect( mShowMyGroupsOnlyAction, SIGNAL( toggled(bool) ), SLOT( setShowMyGroupsOnly(bool) ) );
    connect( mSaveGroupAction, SIGNAL( triggered() ), SLOT( saveHostGroup() ) );
    connect( mManageGroupsAction, SIGNAL( triggered() ), SLOT( manageHostLists() ) );

    mHostGroupCombo->setColumn( "name" );

    refreshHostGroups();
}

void HostServiceMatrixWindow::saveHostGroup()
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

void HostServiceMatrixWindow::manageHostLists()
{
    HostListsDialog * hld = new HostListsDialog( this );
    hld->show();
    hld->exec();
    delete hld;
}

HostList HostServiceMatrixWindow::hostList() const
{
    HostList hl = mView->getModel()->getRecords( ModelIter::collect( mView->getModel(), ModelIter::Selected, mView->selectionModel() ) );
    LOG_5("Found " + QString::number( hl.size() ) + " selected hosts" );
    return hl;
}

void HostServiceMatrixWindow::setShowMyGroupsOnly(bool toggle)
{
    IniConfig & cfg = userConfig();
    cfg.pushSection( "HostSelector" );
    cfg.writeBool( "ShowMyGroupsOnly", toggle );
    cfg.popSection();
    mShowMyGroupsOnlyAction->setChecked( toggle );
    refreshHostGroups();
}

void HostServiceMatrixWindow::showOptionsMenu()
{
    QMenu * menu = new QMenu(this);
    menu->addAction( mShowMyGroupsOnlyAction );
    menu->addSeparator();
    menu->addAction( mSaveGroupAction );
    menu->addAction( mManageGroupsAction );
    menu->exec( QCursor::pos() );
    delete menu;
}

void HostServiceMatrixWindow::refreshHostGroups()
{
    if( !mHostGroupRefreshPending ) {
        QTimer::singleShot( 0, this, SLOT( performHostGroupRefresh() ) );
        mHostGroupRefreshPending = true;
    }
}

void HostServiceMatrixWindow::performHostGroupRefresh()
{
    mHostGroupRefreshPending = false;

    // Generate the default list (everything)
    HostGroup hg;
    hg.setName( "Default List" );
    HostGroupList hostGroups = HostGroup::select( "fkeyusr=? or private is null or private=false", VarList() << User::currentUser().key() ).sorted( "name" );
    if( mShowMyGroupsOnlyAction->isChecked() )
        hostGroups = hostGroups.filter( "fkeyusr", User::currentUser().key() );
    hostGroups.insert(hostGroups.begin(), hg);
    mHostGroupCombo->setItems( hostGroups );
}

void HostServiceMatrixWindow::hostGroupChanged( const Record & hgr )
{
    HostServiceModel * temp = mView->getModel();
    if( hgr.isRecord() )
        temp->setRootList(HostGroup(hgr).hosts()); 
    else if (HostGroup(hgr).name() == "Default List")
        temp->setRootList(Host::select());
}

void HostServiceMatrixWindow::newService()
{
	bool okay;
	while( 1 ) {
		QString serviceName = QInputDialog::getText( this, "New Service", "Enter the name of the service", QLineEdit::Normal, QString(), &okay );
		if( !okay ) break;
		if( serviceName.isEmpty() ) {
			QMessageBox::warning( this, "Invalid Service Name", "Service name cannot be empty" );
			continue;
		}
		if( Service::recordByName( serviceName ).isRecord() ) {
			QMessageBox::warning( this, "Invalid Service Name", "Service '" + serviceName + "' already exists" );
			continue;
		}
		Service s;
		s.setService( serviceName );
		s.setEnabled( true );
		s.commit();
		break;
	}
}
