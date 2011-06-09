
/*
 *
 * Copyright 2003 Blur Studio Inc.
 *
 * This file is part of libstone.
 *
 * libstone is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * libstone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with libstone; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/*
 * $Id$
 */

#include <qsqlerror.h>
#include <qsqlquery.h>
#include <qregexp.h>

#include "pgconnection.h"
#include "table.h"
#include "tableschema.h"

PGConnection::PGConnection()
: QSqlDbConnection( "QPSQL7" )
, mVersionMajor( 0 )
, mVersionMinor( 0 )
{
}

Connection::Capabilities PGConnection::capabilities() const
{
	Connection::Capabilities ret = static_cast<Connection::Capabilities>(QSqlDbConnection::capabilities() | Cap_Inheritance | Cap_MultipleInsert);// | Cap_MultiTableSelect);
	if( checkVersion( 8, 2 ) )
		ret = static_cast<Connection::Capabilities>(ret | Cap_Returning);
	return ret;
}

static void getVersion( PGConnection * c, int & vMaj, int & vMin )
{
	QSqlQuery q = c->exec( "SELECT version()" );
	if( q.next() ) {
		QString versionString = q.value(0).toString();
		LOG_5( "Got Postgres Version string: " + versionString );
		QRegExp vre( "PostgreSQL (\\d+)\\.(\\d+)" );
		if( versionString.contains( vre ) ) {
			vMaj = vre.cap(1).toInt();
			vMin = vre.cap(2).toInt();
			LOG_5( "Got Postgres Version: " + QString::number( vMaj ) + "." + QString::number( vMin ) );
		}
	}
}

bool PGConnection::checkVersion( int major, int minor ) const
{
	if( !mVersionMajor ) {
		PGConnection * c = const_cast<PGConnection*>(this);
		getVersion( c, c->mVersionMajor, c->mVersionMinor );
	}
	return (mVersionMajor > major) || (mVersionMajor == major && mVersionMinor >= minor);
}

bool PGConnection::reconnect()
{
	if( QSqlDbConnection::reconnect() ) {
		checkVersion(0,0);
		return true;
	}
	return false;
}

uint PGConnection::newPrimaryKey( TableSchema * schema )
{
	QString name = schema->tableName();
	QString sql("SELECT nextval('" + name + "_key" + name + "_seq')" );
	QSqlQuery q = exec( sql );
	if( q.isActive() && q.next() )
		return q.value(0).toUInt();
	return 0;
}

bool pgtypeIsCompat( const QString pg_type, uint enumType )
{
	if( pg_type == "text" )
		return ( enumType==Field::String );
	if( pg_type == "varchar" )
		return ( enumType==Field::String );
	if( pg_type == "int2" )
		return ( enumType==Field::UInt || enumType==Field::Int );
	if( pg_type == "int4" )
		return ( enumType==Field::UInt || enumType==Field::Int );
	if( pg_type == "int8" )
		return ( enumType==Field::UInt || enumType==Field::Int || enumType==Field::UInt8 );
	if( pg_type == "numeric" )
		return ( enumType==Field::Double || enumType==Field::Float );
	if( pg_type == "float4" )
		return (enumType==Field::Float || enumType==Field::Double);
	if( pg_type == "float8" )
		return (enumType==Field::Double || enumType==Field::Float);
	if( pg_type == "timestamp" )
		return ( enumType==Field::DateTime );
	if( pg_type == "date" )
		return ( enumType==Field::Date );
	if( pg_type == "boolean" || pg_type == "bool" )
		return ( enumType==Field::Bool );
	if( pg_type == "bytea" )
		return ( enumType==Field::ByteArray || enumType==Field::Image );
	if( pg_type == "color" )
		return ( enumType==Field::Color );
	if( pg_type == "interval" )
		return ( enumType==Field::Interval );
	return false;
}

uint fieldTypeFromPgType( const QString & pg_type )
{
	if( pg_type == "text" || pg_type == "varchar" )
		return Field::String;
	if( pg_type == "int2" || pg_type == "int4" )
		return Field::Int;
	if( pg_type == "int8" )
		return Field::UInt8;
	if( pg_type == "numeric" )
		return Field::Double;
	if( pg_type == "float4" )
		return Field::Float;
	if( pg_type == "float8" )
		return Field::Double;
	if( pg_type == "timestamp" )
		return Field::DateTime;
	if( pg_type == "date" )
		return Field::Date;
	if( pg_type == "boolean" || pg_type == "bool" )
		return Field::Bool;
	if( pg_type == "bytea" )
		return Field::ByteArray;
	if( pg_type == "color" )
		return Field::Color;
	if( pg_type == "interval" )
		return Field::Interval;
	return Field::Invalid;
}

QString warnAndRet( const QString & s ) { LOG_3( s ); return s + "\n"; }

bool PGConnection::tableExists( TableSchema * schema )
{
	return exec( "select * from pg_class WHERE pg_class.relname=? AND pg_class.relnamespace=2200", VarList() << schema->tableName().toLower() ).size() >= 1;
}

bool PGConnection::verifyTable( TableSchema * schema, bool createMissingColumns, QString * output )
{
	QString out;
	bool ret = false, updateDocs = false;

	FieldList fl = schema->columns();
	QMap<QString, Field*> fieldMap;
	FieldList updateDesc;

	// pg_class stores all of the tables
	// relnamespace 2200 is the current public database
	// private columns have negative attnums
	QString info_query( "select att.attname, typ.typname, des.description from pg_class cla "
			"inner join pg_attribute att on att.attrelid=cla.oid "
			"inner join pg_type typ on att.atttypid=typ.oid "
			"left join pg_description des on cla.oid=des.classoid AND att.attnum=des.objsubid "
			"where cla.relkind='r' AND cla.relnamespace=2200 AND att.attnum>0 AND cla.relname='" );
			
	info_query += schema->tableName().toLower() + "';";
	
	QSqlQuery q = exec( info_query );
	if( !q.isActive() )
	{
		out += warnAndRet( "Unable to select table information for table: " + schema->tableName() );
		out += warnAndRet( "Error was: " + q.lastError().text() );
		goto OUT;
	}
	
	for( FieldIter it = fl.begin(); it != fl.end(); ++it )
		fieldMap[(*it)->name().toLower()] = *it;
	
	while( q.next() )
	{
		QString fieldName = q.value(0).toString();
		Field * fp = 0;
		QMap<QString, Field*>::Iterator fi = fieldMap.find( fieldName );
		
		if( fi == fieldMap.end() )
			continue;
		
		fp = *fi;
		
		if( !pgtypeIsCompat( q.value(1).toString(), fp->type() ) )
		{
			out += warnAndRet( schema->tableName() + "." + fp->name() + "[" + fp->typeString() + "] not compatible: " + q.value(1).toString() );
			goto OUT;
		}

		if( !fp->docs().isEmpty() && q.value(2).toString() != fp->docs() )
			updateDesc += fp;

		fieldMap.remove ( fieldName );
	}

	if( !fieldMap.isEmpty() )
	{
		out += warnAndRet( "Couldn't find the following columns for " + schema->tableName() + ": " );
		QStringList cols;
		for( QMap<QString, Field*>::Iterator it = fieldMap.begin(); it != fieldMap.end(); ++it )
			cols += it.key();
		LOG_5( cols.join( "," ) );
		if( createMissingColumns ) {
			out += warnAndRet( "Creating missing columns" );
			for( QMap<QString, Field*>::Iterator it = fieldMap.begin(); it != fieldMap.end(); ++it ) {
				Field * f = it.value();
				QString cc = "ALTER TABLE " + schema->tableName() + " ADD COLUMN " + f->name() + " " + f->dbTypeString() + ";";
				QSqlQuery query = exec(cc);
				if( !query.isActive() ) {
					out += warnAndRet( "Unable to create column: " + f->name() );
					out += warnAndRet( "Error was: " + query.lastError().text() );
					goto OUT;
				}
			}
		} else
			goto OUT;
	}
	
	if( updateDocs && updateDesc.size() ) {
		out += warnAndRet( "Updating column descriptions" );
		foreach( Field * f, updateDesc ) {
			QString sql( "COMMENT ON " + schema->tableName().toLower() + "." + f->name().toLower() + " IS '" + f->docs() + "'");
			QSqlQuery query = exec( sql );
			if( !query.isActive() ) {
				out += warnAndRet( "Unable to set description: " + sql );
			}
		}
	}

	ret = true;
	
	OUT:
	if( output )
		*output = out;
	return ret;
}

bool PGConnection::createTable( TableSchema * schema, QString * output )
{
	QString out;
	bool ret = false;
	QString cre("CREATE TABLE ");
	cre += schema->tableName().toLower() + "  (";
	QStringList columns;
	FieldList fl = schema->ownedColumns();
	foreach( Field * f, fl ) {
		QString ct("\"" + f->name().toLower() + "\"");
		if( f->flag( Field::PrimaryKey ) ) {
			ct += " SERIAL PRIMARY KEY";
			columns.push_front( ct );
		} else {
			ct += " " + f->dbTypeString();
			columns += ct;
		}
	}
	cre += columns.join(",") + ")";
	if( schema->parent() )
		cre += " INHERITS (" + schema->parent()->tableName().toLower() + ")";
	cre += ";";
	out += warnAndRet( "Creating table: " + cre );
	
	QSqlQuery query = exec( cre );
	if( !query.isActive() ){
		out += warnAndRet( "Unable to create table: " + schema->tableName() );
		out += warnAndRet( "Error was: " + query.lastError().text() );
		goto OUT;
	}
	
	ret = true;
	OUT:
	if( output )
		*output = out;
	return ret;
}

TableSchema * PGConnection::importTableSchema()
{
	return 0;
}

Schema * PGConnection::importDatabaseSchema()
{
	return 0;
}

static QString tableQuoted( const QString & table )
{
	if( table.contains( "-" ) || table == "user" )
		return "\"" + table + "\"";
	return table;
}

QString PGConnection::getSqlFields( TableSchema * schema )
{
	QHash<TableSchema*,QString>::iterator it = mSqlFields.find( schema );
	if( it == mSqlFields.end() ) {
		QStringList fields;
		foreach( Field * f, schema->columns() )
			fields += f->name().toLower();
		QString tableName = tableQuoted(schema->tableName());
		QString sql = tableName + ".\"" + fields.join( "\", " + tableName + ".\"" ) + "\"";
		mSqlFields.insert( schema, sql );
		return sql;
	}
	return it.value();
}

QString PGConnection::generateSelectSql( TableSchema * schema )
{
	return "SELECT " + getSqlFields(schema) + " FROM ONLY " + tableQuoted(schema->tableName());
}

RecordList PGConnection::selectOnly( Table * table, const QString & where, const QList<QVariant> & args )
{
	TableSchema * schema = table->schema();
	RecordList ret;
	
	QString select( generateSelectSql(schema) ), w(where);

	if( !w.isEmpty() ) {
		if( !w.contains("WHERE") )
			select += " WHERE";
		select += " " + w;
	}

	select += ";";

	QSqlQuery sq = exec( select, args, true /*retry*/, table );
	while( sq.next() )
		ret += Record( new RecordImp( table, sq ), false );
	return ret;
}

QMap<Table *, RecordList> PGConnection::selectMulti( QList<Table*> tables,
	const QString & innerWhere, const QList<QVariant> & innerArgs,
	const QString & outerWhere, const QList<QVariant> & outerArgs )
{
	QMap<Table*,RecordList> ret;
	QMap<Table*,FieldList> fieldsByTable;
	QMap<Table*,QVector<int> > positionsByTable;
	QVector<int> typesByPosition(1);
	QList<QVariant> allArgs;
	QMap<Table*,QStringList> colsByTable;
	QStringList selects;
	QString innerW(innerWhere), outerW(outerWhere);
	if( !innerW.isEmpty() && !innerW.toLower().contains("where") )
		innerW = "WHERE " + innerW;
	if( !outerW.isEmpty() && !outerW.toLower().contains("where") )
		outerW = "WHERE " + outerW;

	bool colsNeedTableName = innerW.toLower().contains( "join" );

	// First position is the table position
	typesByPosition[0] = Field::Int;
	int tablePos = 0;

	foreach( Table * table, tables ) {
		TableSchema * schema = table->schema();
		FieldList fields = schema->columns();
		fieldsByTable[table] = fields;
		QVector<int> positions(fields.size());
		int pos = 1, i = 0;
		QStringList sql;
		QString tableName = schema->tableName();
		sql << QString::number(tablePos);
		foreach( Field * f, fields ) {
			while( pos < typesByPosition.size() && typesByPosition[pos] != f->type() ) {
				if( tablePos == 0 )
					sql << "NULL::" + Field::dbTypeString(Field::Type(typesByPosition[pos]));
				else
					sql << "NULL";
				pos++;
			}
			if( pos >= typesByPosition.size() ) {
				typesByPosition.resize(pos+1);
				typesByPosition[pos] = f->type();
			}
			if( colsNeedTableName )
				sql << tableName + ".\"" + f->name().toLower() + "\"";
			else
				sql << "\"" + f->name().toLower() + "\"";
			positions[i] = pos;
			i++;
			pos++;
		}
		tablePos++;
		colsByTable[table] = sql;
		allArgs << innerArgs;
		positionsByTable[table] = positions;
	}

	tablePos = 0;
	foreach( Table * t, tables ) {
		QStringList cols = colsByTable[t];
		while( cols.size() < typesByPosition.size() ) {
			if( tablePos == 0 )
				cols << "NULL::" + Field::dbTypeString(Field::Type(typesByPosition[cols.size()]));
			else
				cols << "NULL";
		}

		QString w(innerW);
		w.replace( tables[0]->schema()->tableName() + ".", t->schema()->tableName() + ".", Qt::CaseInsensitive);
		selects << "SELECT " + cols.join(", ") + " FROM ONLY " + t->schema()->tableName() + " " + w;
		
		tablePos++;
	}
	allArgs << outerArgs;
	QString select = "SELECT * FROM ( (" + selects.join(") UNION (") + ") ) AS IQ " + outerW;
	QSqlQuery sq = exec( select, allArgs, true, tables[0] );
	while( sq.next() ) {
		Table * t = tables[sq.value(0).toInt()];
		ret[t] += Record( new RecordImp( t, sq, positionsByTable[t].data() ), false );
	}
	return ret;
}

bool PGConnection::insert( Table * table, const RecordList & rl, bool newPrimaryKey )
{
	if( rl.size() <= 0 )
		return true;

	TableSchema * schema = table->schema();

	// We can't insert a record with a 0 key !!!
	foreach( Record r, rl )
		if( !newPrimaryKey && !r.key() )
			return false;

	bool multiInsert = checkVersion( 8, 2 );

	FieldList fields = schema->columns();
	// Generate the first half of the statement INSERT INTO table (col1, col2, col3) VALUES
	QString sql( "INSERT INTO " + tableQuoted(schema->tableName()) + " ( " );
	{
		QStringList cols;
		foreach( Field * f, fields ) {
			if( !(f->flag( Field::PrimaryKey ) && newPrimaryKey) )
				cols += f->name().toLower();
		}
		sql += "\"" + cols.join( "\", \"" ) + "\" ) VALUES ";
	}

	if( multiInsert ) {
        // multiInsert means the database supports inserting multiple rows with on statement
        // INSERT INTO table (column1,column2) VALUES ( (data1,data2), (data11,data22) );
		QSqlQuery q( mDb );
		QStringList recVals;
		st_foreach( RecordIter, it, rl )
		{
			QStringList vals;
			RecordImp * rb = it.imp();
			foreach( Field * f, fields )
			{
				int pos = f->pos();
				// A deleted record wont have any columns marked as modified, so we'll commit them all
				if( !(newPrimaryKey && f->flag( Field::PrimaryKey )) ) {
					if( (rb->isColumnModified( pos ) || rb->mState == RecordImp::COMMIT_ALL_FIELDS) ) {
						if( rb->isColumnLiteral( pos ) )
							vals += rb->getColumn( pos ).toString();
						else {
                            vals += "?";
						}
					} else
						vals += "DEFAULT";
				}
			}
			recVals +="( " + vals.join( "," ) + " ) ";
		}
		sql += recVals.join( ", " );

        // if we generated a new primary key, return it for the key cache
		if( newPrimaryKey )
			sql += "RETURNING \"" + schema->primaryKey().toLower() + "\";";

		q.prepare( sql );

		st_foreach( RecordIter, it, rl )
		{
			RecordImp * rb = it.imp();
			foreach( Field * f, fields ) {
				int pos = f->pos();
				if( !(newPrimaryKey && f->flag( Field::PrimaryKey )) && (rb->isColumnModified( pos ) || rb->mState == RecordImp::COMMIT_ALL_FIELDS) && !rb->isColumnLiteral( pos ) ) {
					QVariant v = f->dbPrepare( rb->getColumn( f->pos() ) );
					q.addBindValue( v );
				}
			}
		}

		if( exec( q, true/*retry*/, table ) ) {
			if( newPrimaryKey ) {
                // if we're getting new primary keys back from the database
                // we want to update the Records with the new value
                // and the Record should be "cleaned up" internally
				uint i = 0;
				while( q.next() && i < rl.size() ) {
					Record r = rl[i];
					r.setValue( schema->primaryKeyIndex(), q.value(0).toUInt() );
					r.imp()->mState = RecordImp::COMMITTED;
					r.imp()->clearModifiedBits();
					r.imp()->clearColumnLiterals();
					i++;
				}
			}
		}
	} else {
		st_foreach( RecordIter, it, rl )
		{
			RecordImp * rb = (*it).imp();
			QString sql( "INSERT INTO %1 (" ), values( ") VALUES (" );
			sql = sql.arg( tableQuoted(schema->tableName()) );
			FieldList fields = schema->columns();

			bool nc = false;
			foreach( Field * f, fields )
			{
				int pos = f->pos();
				// A deleted record wont have any columns marked as modified, so we'll commit them all
				if( !(newPrimaryKey && f->flag( Field::PrimaryKey )) && (rb->isColumnModified( pos ) || rb->mState == RecordImp::COMMIT_ALL_FIELDS) ){
					if( nc ) { // Need a comma ?
						sql += ", ";
						values += ", ";
					}
					sql += "\"" + f->name().toLower() + "\"";
					if( rb->isColumnLiteral( pos ) )
						values += rb->getColumn( pos ).toString();
					else {
						values += f->placeholder();
					}
					nc = true;
				}
			}

			if( values.isEmpty() ) continue;

			sql = sql + values + ")";

			TableSchema * base = schema;
			if( schema->inherits().size() )
				base = schema->inherits()[0];

			if( newPrimaryKey ) {
				if( checkVersion( 8, 2 ) )
					sql += " RETURNING \"" + schema->primaryKey() + "\";";
				else
					sql += "; SELECT currval('" + base->tableName() + "_" + schema->primaryKey() + "_seq');";
			}

			QSqlQuery q(mDb);
			q.prepare( sql );

			foreach( Field * f, fields ) {
				int pos = f->pos();
				if( !(newPrimaryKey && f->flag( Field::PrimaryKey )) && ((rb->isColumnModified( pos ) || rb->mState == RecordImp::COMMIT_ALL_FIELDS) && !rb->isColumnLiteral( pos )) ) {
					QVariant v = f->dbPrepare( rb->getColumn( pos ) );
					q.bindValue( f->placeholder(), v );
				}
			}

			if( exec( q, true /*retry*/, table ) ) {
				if( newPrimaryKey ){
					if( q.next() ) {
		//				qWarning( "Table::insert: Setting primary key to " + QString::number( q.value(0).toUInt() ) );
						rb->setColumn( schema->primaryKeyIndex(), q.value(0).toUInt() );
					} else {
						LOG_1( "Table::insert: Failed to get primary key after insert" );
						return false;
					}
				}
				rb->mState = RecordImp::COMMITTED;
				rb->clearModifiedBits();
				rb->clearColumnLiterals();
			}
		}
	}

	return true;
}

bool PGConnection::update( Table * table, RecordImp * imp, Record * returnValues )
{
	TableSchema * schema = table->schema();
	bool needComma = false, selectAfterUpdate = false;
	FieldList fields = schema->columns();

	QString up("UPDATE %1 SET ");
	up = up.arg( tableQuoted(schema->tableName()) );
	for( FieldIter it = fields.begin(); it != fields.end(); ++it ){
		Field * f = *it;
        // if the field is the primary key we don't want to change it
        // or if the field hasn't been modified locally, don't change it
		if( f->flag( Field::PrimaryKey ) || !imp->isColumnModified( f->pos() ) )
			continue;
		if( needComma ) up += ", ";

        // column name is wrapped in quotes
		up += "\"" + f->name().toLower() + "\"";

        // if we're updating to a literal value ( such as NOW() or something )
        // put that value in, otherwise put in a bind marker
		if( imp->isColumnLiteral( f->pos() ) ) {
			up += "=" + imp->getColumn( f->pos() ).toString();
			selectAfterUpdate = true;
		} else
			up += "="+f->placeholder();
		needComma = true;
	}

	// There were no columns to update
	if( !needComma ) {
		//qWarning( "Table::update: Record had MODIFIED field set, but no modified columns" );
		return false;
	}

	up += QString(" WHERE ") + schema->primaryKey() + "=:primarykey"; // + QString::number( imp->key() );

	if( returnValues )
		up += " RETURNING " + getSqlFields( schema );
	up += ";";

	QSqlQuery q( mDb );
	q.prepare( up );
	for( FieldIter it = fields.begin(); it != fields.end(); ++it ){
		Field * f = *it;
		if( f->flag( Field::PrimaryKey ) || !imp->isColumnModified( f->pos() ) || imp->isColumnLiteral( f->pos() ) )
			continue;
		QVariant var = f->dbPrepare( imp->getColumn(f->pos()) );
		q.bindValue( f->placeholder(), var );
	}
    q.bindValue( ":primarykey", imp->key() );

	if( exec( q, true /*retryLostConn*/, table ) ) {
		if( returnValues && q.next() )
			*returnValues = Record( new RecordImp( table, q ), false );
		return true;
	}
	return false;
}

int PGConnection::remove( Table * table, const QStringList & keys )
{
	TableSchema * schema = table->schema();
	TableSchema * base = schema;
    // is this an inherited table? if so remove from the base class
	if( schema->inherits().size() )
		base = schema->inherits()[0];
	QString del("DELETE FROM ");
	del += tableQuoted(base->tableName());
	del += " WHERE ";
	del += base->primaryKey();
	del += " IN(" + keys.join(",") + ");";
	QSqlQuery q = exec( del, QList<QVariant>(), true /*retryLostConn*/, table );
	if( !q.isActive() ) return -1;
	return q.numRowsAffected();
}

bool PGConnection::createIndex( IndexSchema * schema )
{
	QString cmd;
	QStringList cols;
	foreach( Field * f, schema->columns() )
		cols += f->name();
	cmd += "CREATE INDEX " + schema->name();
	cmd += " ON TABLE " + tableQuoted(schema->table()->tableName()) + "(" + cols.join(",") + ")";
	if( !schema->databaseWhere().isEmpty() )
		cmd += " WHERE " + schema->databaseWhere();
	cmd += ";";

	return exec( cmd ).isActive();
}

