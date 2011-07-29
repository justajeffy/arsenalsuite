
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
, mTableSchema( 0 )
{
	mUI.setupUi( this );

	connect( mUI.mVerifyButton, SIGNAL( clicked() ), SLOT( verify() ) );
	connect( mUI.mCreateButton, SIGNAL( clicked() ), SLOT( create() ) );
	connect( mUI.mCloseButton, SIGNAL( clicked() ), SLOT( reject() ) );
	connect( mUI.mEditConnectionButton, SIGNAL( clicked() ), SLOT( editConnection() ) );

	updateConnectionLabel();
}

void CreateDatabaseDialog::setTableSchema( TableSchema * tableSchema )
{
	mTableSchema = tableSchema;
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

void CreateDatabaseDialog::verify()
{
	QString output;
	if( mTableSchema ) {
		Table * table = mDatabase->tableFromSchema( mTableSchema );
		table->verifyTable( false, &output );
	} else {
		mDatabase->verifyTables( &output );
	}
	mUI.mHistoryEdit->setText( output );
}

void CreateDatabaseDialog::create()
{
	QString output;
	if( mTableSchema ) {
		Table * table = mDatabase->tableFromSchema( mTableSchema );
		if( table->exists() )
			table->verifyTable( true, &output );
		else
			table->createTable( &output );
	} else {
		mDatabase->createTables( &output );
	}
	mUI.mHistoryEdit->setText( output );
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
