
%MappedType MappedHostLoad
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "hostloadlist.h"
#include "hostloadtable.h"
#define MappedHostLoad HostLoad
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new HostLoad(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, HostLoadSchema::instance() );
%End
};

class HostLoad : Record
{
%TypeHeaderCode
#include <hostload.h>
#include "host.h"

%End
public:
	HostLoad();

	HostLoad( uint key );

	HostLoad( const HostLoad & other );

	HostLoad( const Record & r );

	HostLoad( RecordImp * imp, bool checkType = true );
	
	MappedHostLoad copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedHost host() const;
	MappedHostLoad & setHost( const Host & );
	float loadAvg() const;
	MappedHostLoad & setLoadAvg( const float & );
	float loadAvgAdjust() const;
	MappedHostLoad & setLoadAvgAdjust( const float & );


	static MappedHostLoadList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedHostLoad reload( bool lockForUpdate = false );

	static MappedHostLoad recordByHost( const Host &fkeyHost );






	static Table * table();
	//static HostLoadSchema * schema();
};


