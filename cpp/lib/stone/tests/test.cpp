
#include <qapplication.h>

#include "blurqt.h"
#include "connection.h"
#include "database.h"
#include "freezercore.h"
#include "record.h"
#include "schema.h"

bool test1();
bool test2();
bool test3();
bool test4();
bool test5();
bool test6();
bool test7();
bool test8();

#define TEST(x)	{ if( !test##x() ) abort(); }

int main( int argc, char * argv [] )
{
	QApplication a( argc, argv );
	initConfig( "resin.ini" );
	TEST(1);
	TEST(2);
	TEST(3);
	TEST(4);
	TEST(5);
	TEST(6);
	TEST(7);
	TEST(8);
	shutdown();
}

bool testString( const QString & target, const QString & actual, const QString test, bool expectEqual = true )
{
	if( (target != actual) == expectEqual ) {
		LOG_5( "Test " + test + " failed" );
		LOG_5( "Expected: " + target );
		LOG_5( "Got: " + actual );
		return false;
	}
	return true;
}

bool testInt( int target, int actual, const QString & test, bool expectEqual = true )
{
	if( (target != actual) == expectEqual ) {
		LOG_5( "Test " + test + " failed" );
		LOG_5( "Expected: " + QString::number( target ) );
		LOG_5( "Got: " + QString::number( actual ) );
		return false;
	}
	return true;
}

Connection * conn = 0;
Schema * schema = 0;
bool test1()
{
	QString test( "Database Connection" );
	schema = new Schema();
	conn = Connection::createFromIni( config(), "Database" );
	Database::setCurrent( new Database( schema, conn ) );
	return testInt( (int)conn->checkConnection(), 1, test );
}

Table * t = 0;
Database * d = 0;
bool test2()
{
	QString test( "Table::mergeSchema" );
	d = Database::current();
	schema->mergeXmlSchema( "../../classes/schema.xml" );
	d->setEchoMode( Database::EchoInsert | Database::EchoSelect | Database::EchoUpdate );
	t = schema->tableByName( "JobTask" )->table();
	return testInt( 0, (int)t, test, false );
}

Record r;
bool test3()
{
	QString test( "JobTask insertion" );
	r = t->load();
	r.setValue( "jobTask", 666 );
	r.setValue( "fkeyHost", 777 );
	r.setValue( "fkeyJob", 111 );
	r.commit();
	return testInt( 0, r.key(), test, false );
}

#define RETFAIL(x) do{ if( !x ) return false; } while(0)
bool test4()
{
	QString test( "JobTask values" );
	RETFAIL( testInt( 666, r.getValue( "jobTask" ).toInt(), test + " jobTask" ) );
	RETFAIL( testInt( 777, r.getValue( "fkeyHost" ).toInt(), test + " fkeyHost" ) );
	RETFAIL( testInt( 111, r.getValue( "fkeyJob" ).toInt(), test + " fkeyJob" ) );
	return true;
}

bool test5()
{
	QString test( "Record Ref Counting" );
	RETFAIL( testInt( 2, r.imp()->refCount(), test + " 1" ) );
	Record mod = r;
	RETFAIL( testInt( 3, r.imp()->refCount(), test + " 2" ) );
	mod.setValue( "fkeyJob", 112 );
	RETFAIL( testInt( 1, mod.imp()->refCount(), test + " 3" ) );
	RETFAIL( testInt( 2, r.imp()->refCount(), test + " 4" ) );
	mod.commit();
	RETFAIL( testInt( 112, r.getValue( "fkeyJob" ).toInt(), test + " 5" ) );
	mod = t->record( r.key(), true, false );
	RETFAIL( testInt( (int)mod.imp(), (int)r.imp(), test + " 6" ) );
	return true;
}

bool test6()
{
	QString test( "checkForUpdate test" );
	Record same = t->record( r.key(), true, false );
	RETFAIL( testInt( (int)r.imp(), (int)same.imp(), test + " 1" ) );
	int key = r.key();
	same = Record();
	r = Record();
	same = t->record( key, false, true );
	RETFAIL( testInt( (int)same.isRecord(), 0, test + " 2" ) );
	return true;
}

bool test7()
{
	// Host
	Record h = d->tableByName( "Host" )->load();
	h.setValue( "name", "Test7" );

	// JobTask
	Record jt = t->load();
	jt.setValue( "jobTask", 666 );
	jt.setValue( "fkeyJob", 111 );
	jt.setForeignKey( "host", h );

	jt.commit();
	h.commit();
	RETFAIL( testInt( jt.foreignKey("host").key(), h.key(), "Uncommitted foreign key relationships" ) );
	return true;
}

bool test8()
{
	Schema * schema = new Schema();
	delete schema;
	return true;
}

