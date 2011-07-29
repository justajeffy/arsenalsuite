
%MappedType MappedJobMax5
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmax5list.h"
#include "jobmax5table.h"
#define MappedJobMax5 JobMax5
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax5(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMax5Schema::instance() );
%End
};

class JobMax5 : Job
{
%TypeHeaderCode
#include <jobmax5.h>

%End
public:
	JobMax5();

	JobMax5( uint key );

	JobMax5( const JobMax5 & other );

	JobMax5( const Record & r );

	JobMax5( RecordImp * imp, bool checkType = true );
	
	MappedJobMax5 copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString camera() const;
	MappedJobMax5 & setCamera( const QString & );
	QString fileOriginal() const;
	MappedJobMax5 & setFileOriginal( const QString & );
	uint flag_h() const;
	MappedJobMax5 & setFlag_h( const uint & );
	uint frameStart() const;
	MappedJobMax5 & setFrameStart( const uint & );
	uint frameEnd() const;
	MappedJobMax5 & setFrameEnd( const uint & );
	uint flag_w() const;
	MappedJobMax5 & setFlag_w( const uint & );
	uint flag_xv() const;
	MappedJobMax5 & setFlag_xv( const uint & );
	uint flag_x2() const;
	MappedJobMax5 & setFlag_x2( const uint & );
	uint flag_xa() const;
	MappedJobMax5 & setFlag_xa( const uint & );
	uint flag_xe() const;
	MappedJobMax5 & setFlag_xe( const uint & );
	uint flag_xk() const;
	MappedJobMax5 & setFlag_xk( const uint & );
	uint flag_xd() const;
	MappedJobMax5 & setFlag_xd( const uint & );
	uint flag_xh() const;
	MappedJobMax5 & setFlag_xh( const uint & );
	uint flag_xo() const;
	MappedJobMax5 & setFlag_xo( const uint & );
	uint flag_xf() const;
	MappedJobMax5 & setFlag_xf( const uint & );
	uint flag_xn() const;
	MappedJobMax5 & setFlag_xn( const uint & );
	uint flag_xp() const;
	MappedJobMax5 & setFlag_xp( const uint & );
	uint flag_xc() const;
	MappedJobMax5 & setFlag_xc( const uint & );
	uint flag_v() const;
	MappedJobMax5 & setFlag_v( const uint & );
	QString elementFile() const;
	MappedJobMax5 & setElementFile( const QString & );
	QString frameList() const;
	MappedJobMax5 & setFrameList( const QString & );


	static MappedJobMax5List select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax5 reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMax5Schema * schema();
};


