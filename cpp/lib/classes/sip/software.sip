
%MappedType MappedSoftware
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "softwarelist.h"
#include "softwaretable.h"
#define MappedSoftware Software
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new Software(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, SoftwareSchema::instance() );
%End
};

class Software : Record
{
%TypeHeaderCode
#include <software.h>
#include "hostsoftware.h"

%End
public:
	Software();

	Software( uint key );

	Software( const Software & other );

	Software( const Record & r );

	Software( RecordImp * imp, bool checkType = true );
	
	MappedSoftware copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString name() const;
	MappedSoftware & setName( const QString & );
	QString version() const;
	MappedSoftware & setVersion( const QString & );
	QString installedPath() const;
	MappedSoftware & setInstalledPath( const QString & );
	QString executable() const;
	MappedSoftware & setExecutable( const QString & );
	bool sixtyfourbit() const;
	MappedSoftware & setSixtyfourbit( const bool & );
	bool active() const;
	MappedSoftware & setActive( const bool & );
	MappedHostSoftwareList hostSoftwares() const;


	static MappedSoftwareList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedSoftware reload( bool lockForUpdate = false );







	static Table * table();
	//static SoftwareSchema * schema();
};


