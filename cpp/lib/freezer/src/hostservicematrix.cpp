
#include <qcombobox.h>
#include <qevent.h>
#include <qheaderview.h>
#include <qinputdialog.h>
#include <qmessagebox.h>
#include <qmenu.h>

#include "hostservicematrix.h"
#include "qvariantcmp.h"
#include "syslog.h"
#include "syslogrealm.h"
#include "syslogseverity.h"
#include "user.h"

struct HostServiceItem : public RecordItem
{
	Host mHost;
	HostStatus mHostStatus;
    HostServiceList mHostServices;
    QVector<HostService> mHostServiceByColumn;
    HostServiceItem() {}
    HostServiceItem( const Host & h, HostServiceList hsl, ServiceList services )
    : mHostServiceByColumn(services.size())
    {
        mHost = h;
        mHostStatus = mHost.hostStatus();
        mHostServices = hsl;
        foreach( HostService hs, hsl ) {
            int col = services.findIndex( hs.service() );
            if( col >= 0 )
            mHostServiceByColumn[col] = hs;
        }
    }
    HostService hostServiceByColumn( int col ) const {
        if( col > 0 && (col-1) < mHostServiceByColumn.size() )
            return mHostServiceByColumn[col-1];
        return HostService();
    }
    QVariant serviceData( int column ) const
    {
        HostService hs = hostServiceByColumn( column );
        if( hs.isRecord() )
            return hs.enabled() ? "Enabled" : "Disabled";
        return "No Service";
    }

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
    HostService hs = hostServiceByColumn( column );
    HostService ohs = HostServiceTranslator::data(b).hostServiceByColumn( column );
	return compareRetI( hsSortVal( hs ), hsSortVal( ohs ) );
}

QVariant HostServiceItem::modelData( const QModelIndex & idx, int role ) const
{
	if( role == Qt::DisplayRole || role == Qt::EditRole || role == Qt::ForegroundRole ) {
		if( idx.column() == 0 ) return mHost.name() + " [" + mHostStatus.slaveStatus() + "]";
		if( role == Qt::EditRole )
            return qVariantFromValue<Record>(hostServiceByColumn( idx.column() ));
        QVariant d = serviceData( idx.column() );
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
	if( role == Qt::EditRole && idx.column() > 0 ) {
		HostServiceModel * m = model(idx);
		HostService hs = hostServiceByColumn( idx.column() );
		switch( v.toInt() ) {
			case 0:
			case 1:
                if( !hs.isRecord() ) {
                    hs.setHost( mHost );
                    hs.setService( m->serviceByColumn( idx.column() ) );
                }
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
	return idx.column() == 0 ? ret : Qt::ItemFlags(ret | Qt::ItemIsEditable);
}

Record HostServiceItem::getRecord()
{
	return mHost;
}

HostServiceModel::HostServiceModel( QObject * parent )
: RecordSuperModel( parent )
{
	new HostServiceTranslator(treeBuilder());

    connect( HostService::table(), SIGNAL( added(RecordList) ), SLOT( hostServicesAdded(RecordList) ) );
    connect( HostService::table(), SIGNAL( removed(RecordList) ), SLOT( hostServicesRemoved(RecordList) ) );
    connect( HostService::table(), SIGNAL( updated(Record,Record) ), SLOT( hostServiceUpdated(Record,Record) ) );

	// Set HostService index to cache
	updateServices();
}

void HostServiceModel::hostServicesAdded(RecordList rl)
{
    HostServiceList hsl(rl);
    HostList hosts = hsl.hosts();
    mHostServices += hsl;
    mHostServicesByHost = mHostServices.groupedByForeignKey<Host,HostServiceList>("fkeyhost");
    updateHosts(hosts);
    }

void HostServiceModel::hostServicesRemoved(RecordList rl)
{
    HostServiceList hsl(rl);
    HostList hosts = hsl.hosts();
    mHostServices -= hsl;
    mHostServicesByHost = mHostServices.groupedByForeignKey<Host,HostServiceList>("fkeyhost");
    updateHosts(hosts);
}

void HostServiceModel::hostServiceUpdated(Record up, Record)
{
    QModelIndex idx = findIndex(up);
    dataChanged( idx.sibling( idx.row(), 0 ), idx.sibling( idx.row(), columnCount() - 1 ) );
}


void HostServiceModel::updateServices()
{
	//Index * i = HostService::table()->index( "HostAndService" );
	//if( i ) i->setCacheEnabled( true );
	//HostService::schema()->setPreloadEnabled( true );
    mHostServices = HostService::select();
    mHostServicesByHost = mHostServices.groupedByForeignKey<Host,HostServiceList>("fkeyhost");
	mServices = Service::select().sorted( "service" );
	LOG_5( mServices.services().join(",") );
	setHeaderLabels( QStringList() << "Host" << mServices.services() );
	// Keep the list in memory until the items can store each hoststatus record
    mStatuses = HostStatus::select();

    setHostList( Host::select() );
}

Service HostServiceModel::serviceByColumn( int column ) const
{
    if( column < 0 || column >= (int)mServices.size() ) return Service();
    return mServices[column];
}

void HostServiceModel::setHostList( HostList hosts )
{
    LOG_5( "Adding " + QString::number(hosts.size()) + " hosts" );
    clear();
    SuperModel::InsertClosure closure(this);
    HostServiceTranslator * hst = (HostServiceTranslator*)treeBuilder()->defaultTranslator();
    QModelIndexList ret = append( QModelIndex(), hosts.size(), hst );
    for( int i=0; i < hosts.size(); ++i ) {
        Host h = hosts[i];
        LOG_5( "Host " + h.name() + " has services " + mHostServicesByHost[h].services().services().join(",") );
        hst->data(ret[i]) = HostServiceItem( h, mHostServicesByHost[h], mServices );
    }
}

HostService HostServiceModel::findHostService( const QModelIndex & idx )
{
    HostService hs;
    if( idx.isValid() ) {
        HostServiceItem & item = ((HostServiceTranslator*)treeBuilder()->defaultTranslator())->data(idx);
        hs = item.hostServiceByColumn( idx.column() );
        if( !hs.isRecord() ) {
            hs.setHost( item.mHost );
            hs.setService( serviceByColumn( idx.column() ) );
        }
    }
    return hs;
}

void HostServiceModel::updateHosts( HostList hosts )
{
    refreshIndexes( findIndexes( hosts ) );
}

void HostServiceModel::refreshIndexes( QModelIndexList indexes )
{
    HostServiceTranslator * hst = (HostServiceTranslator*)treeBuilder()->defaultTranslator();
    for( int i=0; i < indexes.size(); ++i ) {
        QModelIndex idx = indexes[i];
        HostServiceItem & item = hst->data(idx);
        item = HostServiceItem( item.mHost, mHostServicesByHost[item.mHost], mServices );
        dataChange( idx.sibling( idx.row(), 0 ), idx.sibling( idx.row(), columnCount()-1 ) );
    }
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
, mHostFilterCS( false )
, mServiceFilterCS( false )
{
	mModel = new HostServiceModel(this);
	setModel( mModel );
	setItemDelegate( new HostServiceDelegate(this) );
	connect( this, SIGNAL( showMenu( const QPoint &, const QModelIndex & ) ), SLOT( slotShowMenu( const QPoint &, const QModelIndex & ) ) );
	setSelectionBehavior( QAbstractItemView::SelectItems );
	header()->setStretchLastSection( false );

	connect( Service::table(), SIGNAL( added(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( removed(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( updated(Record,Record) ), SLOT( updateServices() ) );
}

void HostServiceMatrix::setHostFilter( const QString & filter )
{
	mHostFilter = filter;
    QRegExp re( filter, mHostFilterCS ? Qt::CaseSensitive : Qt::CaseInsensitive );
    for( ModelIter it(mModel); it.isValid(); ++it )
        setRowHidden( (*it).row(), QModelIndex(), !Host(mModel->getRecord(*it)).name().contains( re ) );

}

void HostServiceMatrix::setServiceFilter( const QString & filter )
{
	mServiceFilter = filter;
	QHeaderView * h = header();
    QRegExp re(filter, mServiceFilterCS ? Qt::CaseSensitive : Qt::CaseInsensitive);
	for( int i=1; i < h->count(); i++ )
		h->setSectionHidden( i, !model()->headerData(i, Qt::Horizontal, Qt::DisplayRole ).toString().contains( re ) );
}

void HostServiceMatrix::setHostFilterCS( bool cs )
{
    mHostFilterCS = cs;
    setHostFilter( mHostFilter );
}

void HostServiceMatrix::setServiceFilterCS( bool cs )
{
    mServiceFilterCS = cs;
    setServiceFilter( mServiceFilter );
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

bool HostServiceMatrixWindow::eventFilter( QObject * o, QEvent * e )
{
    if( o == mHostFilterEdit && e->type() == QEvent::ContextMenu ) {
        QMenu * menu = mHostFilterEdit->createStandardContextMenu();
        QAction * first = menu->actions()[0];
        QAction * cs = new QAction( "Case Sensitive Filter", menu );
        cs->setCheckable( true );
        cs->setChecked( mView->hostFilterCS() );
        menu->insertAction( first, cs );
        menu->insertSeparator( first );
        if( menu->exec(((QContextMenuEvent*)e)->globalPos()) == cs )
            mView->setHostFilterCS( cs->isChecked() );
        delete menu;
        return true;
    }
    else if( o == mServiceFilterEdit && e->type() == QEvent::ContextMenu ) {
        QMenu * menu = mServiceFilterEdit->createStandardContextMenu();
        QAction * first = menu->actions()[0];
        QAction * cs = new QAction( "Case Sensitive Filter", menu );
        cs->setCheckable( true );
        cs->setChecked( mView->serviceFilterCS() );
        menu->insertAction( first, cs );
        menu->insertSeparator( first );
        if( menu->exec(((QContextMenuEvent*)e)->globalPos()) == cs )
            mView->setServiceFilterCS( cs->isChecked() );
        delete menu;
        return true;
    }
    return false;
}

HostServiceMatrixWindow::HostServiceMatrixWindow( QWidget * parent )
: QMainWindow( parent )
{
	setupUi(this);

	setWindowTitle( "Edit Host Services" );

	mView = new HostServiceMatrix( mCentralWidget );
	mCentralWidget->layout()->addWidget(mView);
	mView->show();
    mHostFilterEdit->installEventFilter(this);
    mServiceFilterEdit->installEventFilter(this);
	connect( mHostFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setHostFilter( const QString & ) ) );
	connect( mServiceFilterEdit, SIGNAL( textChanged( const QString & ) ), mView, SLOT( setServiceFilter( const QString & ) ) );
	QMenu * fileMenu = menuBar()->addMenu( "&File" );
	fileMenu->addAction( "&New Service", this, SLOT( newService() ) );
	fileMenu->addSeparator();
	fileMenu->addAction( "&Close", this, SLOT( close() ) );
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
