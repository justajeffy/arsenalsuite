
%MappedType MappedJobFusionVideoMaker
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionvideomakerlist.h"
#include "jobfusionvideomakertable.h"
#define MappedJobFusionVideoMaker JobFusionVideoMaker
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new JobFusionVideoMaker(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, JobFusionVideoMakerSchema::instance() );
%End
};

class JobFusionVideoMaker : JobFusion
{
%TypeHeaderCode
#include <jobfusionvideomaker.h>

%End
public:
	JobFusionVideoMaker();

	JobFusionVideoMaker( uint key );

	JobFusionVideoMaker( const JobFusionVideoMaker & other );

	JobFusionVideoMaker( const Record & r );

	JobFusionVideoMaker( RecordImp * imp, bool checkType = true );
	
	MappedJobFusionVideoMaker copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	QString codec() const;
	MappedJobFusionVideoMaker & setCodec( const QString & );
	QString inputFramePath() const;
	MappedJobFusionVideoMaker & setInputFramePath( const QString & );
	uint sequenceFrameStart() const;
	MappedJobFusionVideoMaker & setSequenceFrameStart( const uint & );
	uint sequenceFrameEnd() const;
	MappedJobFusionVideoMaker & setSequenceFrameEnd( const uint & );


	static MappedJobFusionVideoMakerList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedJobFusionVideoMaker reload( bool lockForUpdate = false );






static QStringList outputFormats();
static QStringList outputCodecs(const QString & format);
static QString formatFromExtension(const QString & ext);
static QString formatToExtension(const QString & format);
static QString updatePathToFormat(const QString & path, const QString & format);

QString format();


	static Table * table();
	//static JobFusionVideoMakerSchema * schema();
};


