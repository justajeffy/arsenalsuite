
%MappedType MappedConfig
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "configlist.h"
#include "configtable.h"
#define MappedConfig Config
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Config(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, ConfigSchema::instance() );
%End
};

class Config : Record
{
%TypeHeaderCode
#include <config.h>

%End
public:
	Config();

	Config( uint key );

	Config( const Config & other );

	Config( const Record & r );

	Config( RecordImp * imp, bool checkType = true );
	
	MappedConfig copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString config() const;
	MappedConfig & setConfig( const QString & );
	QString value() const;
	MappedConfig & setValue( const QString & );


	static MappedConfigList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedConfig reload( bool lockForUpdate = false );

	static MappedConfig recordByName( const QString &config );





	//static bool getBool( const QString & key );
	static int getInt( const QString & key, int def = 0 );
	static uint getUInt( const QString & key, uint def = 0 );
	static float getFloat( const QString & key, float def = 0.0 );
	static QString getString( const QString & key, const QString & def = QString() );
	static bool getBool( const QString & key, bool def = false );





	static Table * table();
	//static ConfigSchema * schema();
};


