
%MappedType MappedJobMax6
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax6list.h"
#include "jobmax6table.h"
#define MappedJobMax6 JobMax6
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax6(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax6Schema::instance() );
%End
};

class JobMax6 : Job
{
%TypeHeaderCode
#include <jobmax6.h>

%End
public:
	JobMax6();

	JobMax6( uint key );

	JobMax6( const JobMax6 & other );

	JobMax6( const Record & r );

	JobMax6( RecordImp * imp, bool checkType = true );
	
	MappedJobMax6 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString camera() const;
	MappedJobMax6 & setCamera( const QString & );
	QString elementFile() const;
	MappedJobMax6 & setElementFile( const QString & );
	QString fileOriginal() const;
	MappedJobMax6 & setFileOriginal( const QString & );
	uint flag_h() const;
	MappedJobMax6 & setFlag_h( const uint & );
	uint flag_v() const;
	MappedJobMax6 & setFlag_v( const uint & );
	uint flag_w() const;
	MappedJobMax6 & setFlag_w( const uint & );
	uint flag_x2() const;
	MappedJobMax6 & setFlag_x2( const uint & );
	uint flag_xa() const;
	MappedJobMax6 & setFlag_xa( const uint & );
	uint flag_xc() const;
	MappedJobMax6 & setFlag_xc( const uint & );
	uint flag_xd() const;
	MappedJobMax6 & setFlag_xd( const uint & );
	uint flag_xe() const;
	MappedJobMax6 & setFlag_xe( const uint & );
	uint flag_xf() const;
	MappedJobMax6 & setFlag_xf( const uint & );
	uint flag_xh() const;
	MappedJobMax6 & setFlag_xh( const uint & );
	uint flag_xk() const;
	MappedJobMax6 & setFlag_xk( const uint & );
	uint flag_xn() const;
	MappedJobMax6 & setFlag_xn( const uint & );
	uint flag_xo() const;
	MappedJobMax6 & setFlag_xo( const uint & );
	uint flag_xp() const;
	MappedJobMax6 & setFlag_xp( const uint & );
	uint flag_xv() const;
	MappedJobMax6 & setFlag_xv( const uint & );
	uint frameEnd() const;
	MappedJobMax6 & setFrameEnd( const uint & );
	QString frameList() const;
	MappedJobMax6 & setFrameList( const QString & );
	uint frameStart() const;
	MappedJobMax6 & setFrameStart( const uint & );


	static MappedJobMax6List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax6 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax6Schema * schema();
};


