
#include <qcombobox.h>
#include <qheaderview.h>
#include <qinputdialog.h>
#include <qmessagebox.h>
#include <qmenu.h>

#include "hostservicematrix.h"
#include "qvariantcmp.h"

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
		if( idx.column() == 0 ) return mHost.name() + " [" + mHostStatus.slaveStatus() + "]";
		HostServiceModel * m = model(idx);
		if( role == Qt::EditRole )
			return qVariantFromValue<Record>(m->findHostService( mHost, idx.column() ));
		QVariant d = m->serviceData( mHost, idx.column(), role );
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
		HostService hs = m->findHostService( mHost, idx.column() );
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

	// Set HostService index to cache
	updateServices();
}

void HostServiceModel::updateServices()
{
	Index * i = HostService::table()->index( "HostAndService" );
	if( i ) i->setCacheEnabled( true );
	HostService::schema()->setPreloadEnabled( true );
	mServices = Service::select().sorted( "service" );
	LOG_5( mServices.services().join(",") );
	setHeaderLabels( QStringList() << "Host" << mServices.services() );
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
	return findHostService( getRecord(idx), idx.column() );
}

QVariant HostServiceModel::serviceData ( const Host & host, int column, int ) const
{
	HostService hs = findHostService( host, column );
	if( hs.isRecord() )
		return hs.enabled() ? "Enabled" : "Disabled";
	return "No Service";
}

void HostServiceModel::setHostFilter( const QString & filter )
{
	setRootList( Host::select().filter( "name", QRegExp( filter ) ) );
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
	setSelectionBehavior( QAbstractItemView::SelectItems );
	header()->setStretchLastSection( false );

	connect( Service::table(), SIGNAL( added(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( removed(RecordList) ), SLOT( updateServices() ) );
	connect( Service::table(), SIGNAL( updated(Record,Record) ), SLOT( updateServices() ) );
}

void HostServiceMatrix::setHostFilter( const QString & filter )
{
	mHostFilter = filter;
	mModel->setHostFilter( filter );
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
			if( result == en || result == dis )
				toUpdate.commit();
			else
				toUpdate.remove();
		}
		delete menu;
	}
}

HostServiceMatrixWindow::HostServiceMatrixWindow( QWidget * parent )
: QMainWindow( parent )
{
	setupUi(this);

	setWindowTitle( "Edit Host Services" );

	mView = new HostServiceMatrix( mCentralWidget );
	mCentralWidget->layout()->addWidget(mView);
	mView->show();
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
