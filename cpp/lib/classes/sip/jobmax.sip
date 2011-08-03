
%MappedType MappedJobMax
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobmaxlist.h"
#include "jobmaxtable.h"
#define MappedJobMax JobMax
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobMax(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobMaxSchema::instance() );
%End
};

class JobMax : Job
{
%TypeHeaderCode
#include <jobmax.h>

%End
public:
	JobMax();

	JobMax( uint key );

	JobMax( const JobMax & other );

	JobMax( const Record & r );

	JobMax( RecordImp * imp, bool checkType = true );
	
	MappedJobMax copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString camera() const;
	MappedJobMax & setCamera( const QString & );
	QString elementFile() const;
	MappedJobMax & setElementFile( const QString & );
	QString fileOriginal() const;
	MappedJobMax & setFileOriginal( const QString & );
	uint flag_h() const;
	MappedJobMax & setFlag_h( const uint & );
	uint flag_v() const;
	MappedJobMax & setFlag_v( const uint & );
	uint flag_w() const;
	MappedJobMax & setFlag_w( const uint & );
	uint flag_x2() const;
	MappedJobMax & setFlag_x2( const uint & );
	uint flag_xa() const;
	MappedJobMax & setFlag_xa( const uint & );
	uint flag_xc() const;
	MappedJobMax & setFlag_xc( const uint & );
	uint flag_xd() const;
	MappedJobMax & setFlag_xd( const uint & );
	uint flag_xe() const;
	MappedJobMax & setFlag_xe( const uint & );
	uint flag_xf() const;
	MappedJobMax & setFlag_xf( const uint & );
	uint flag_xh() const;
	MappedJobMax & setFlag_xh( const uint & );
	uint flag_xk() const;
	MappedJobMax & setFlag_xk( const uint & );
	uint flag_xn() const;
	MappedJobMax & setFlag_xn( const uint & );
	uint flag_xo() const;
	MappedJobMax & setFlag_xo( const uint & );
	uint flag_xp() const;
	MappedJobMax & setFlag_xp( const uint & );
	uint flag_xv() const;
	MappedJobMax & setFlag_xv( const uint & );
	uint frameEnd() const;
	MappedJobMax & setFrameEnd( const uint & );
	QString frameList() const;
	MappedJobMax & setFrameList( const QString & );
	uint frameStart() const;
	MappedJobMax & setFrameStart( const uint & );
	QString exrChannels() const;
	MappedJobMax & setExrChannels( const QString & );
	QString exrAttributes() const;
	MappedJobMax & setExrAttributes( const QString & );
	QString startupScript() const;
	MappedJobMax & setStartupScript( const QString & );
	/**
	  * This corrosponds to the MaxOpenExr enum, not the actual bit depth.
	  * Values are 
	  * 0 - "Integer - 8 bits per channel"
	  * 1 - "Half Float - 16 bits per channel"
	  * 2 - "Float - 32 bits per channel"
	  **/
	int exrSaveBitDepth() const;
	MappedJobMax & setExrSaveBitDepth( const int & );


	static MappedJobMaxList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobMax reload( bool lockForUpdate = false );







	static Table * table();
	//static JobMaxSchema * schema();
};


