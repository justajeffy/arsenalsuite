
#include <qpushbutton.h>
#include <qtablewidget.h>
#include <qlabel.h>
#include <qstringlist.h>
#include <qregexp.h>

#include "blurqt.h"
#include "createdatabasedialog.h"
#include "configdbdialog.h"
#include "connection.h"
#include "database.h"
#include "freezercore.h"
#include "iniconfig.h"

CreateDatabaseDialog::CreateDatabaseDialog( Schema * schema, QWidget * parent )
: QDialog( parent )
, mSchema( schema )
, mDatabase( new Database( schema, Connection::createFromIni( config(), "Database" ) ) )
{
	mUI.setupUi( this );

	connect( mUI.mVerifyButton, SIGNAL( clicked() ), SLOT( verifyDatabase() ) );
	connect( mUI.mCreateButton, SIGNAL( clicked() ), SLOT( createDatabase() ) );
	connect( mUI.mCloseButton, SIGNAL( clicked() ), SLOT( reject() ) );
	connect( mUI.mEditConnectionButton, SIGNAL( clicked() ), SLOT( editConnection() ) );

	updateConnectionLabel();
}

void CreateDatabaseDialog::editConnection()
{
	ConfigDBDialog * cdb = new ConfigDBDialog( this );
	if( cdb->exec() == QDialog::Accepted ) {
		Connection * c = Connection::createFromIni( config(), "Database" );
		c->checkConnection();
		mDatabase->setConnection( c );
		updateConnectionLabel();
	}
	delete cdb;
}

void addStringListView( QTableWidget * tw, const QString & string )
{
	tw->clear();
	QStringList ol = string.split('\n');
	int row = 0;
	for( QStringList::Iterator it = ol.begin(); it != ol.end(); ++it ) {
		QTableWidgetItem * twi = new QTableWidgetItem( *it );
		tw->setItem( row++, 0, twi );
	}
}

void CreateDatabaseDialog::verifyDatabase()
{
	QString output;
	mDatabase->verifyTables( &output );
	addStringListView( mUI.mTableWidget, output );
}

void CreateDatabaseDialog::createDatabase()
{
	QString output;
	mDatabase->createTables( &output );
	addStringListView( mUI.mTableWidget, output );
}

void CreateDatabaseDialog::updateConnectionLabel()
{
	QString text;
	mDatabase->connection()->checkConnection();
	IniConfig & cfg = config();
	cfg.pushSection( "Database" );
	if( mDatabase->connection()->isConnected() ) {
		text = "Connected: ";
	} else
		text = "Connection Failed: ";
	text += cfg.readString( "DatabaseName" ) + " on " + cfg.readString( "User" ) + ":" + cfg.readString( "Password" ).replace( QRegExp("."), "x" ) +
		"@"  + cfg.readString( "Host" );
	mUI.mConnectionStatus->setText( text );
	cfg.popSection();
}
