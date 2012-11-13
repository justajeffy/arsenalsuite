


%MappedType MappedJobFusionVideoMakerList
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "jobfusionvideomakerlist.h"
#include "jobfusionvideomakertable.h"
#define MappedJobFusionVideoMakerList JobFusionVideoMakerList
%End

%ConvertToTypeCode
	return 0;
%End

%ConvertFromTypeCode
	return sipWrapRecordList( sipCpp, true, JobFusionVideoMakerSchema::instance() );
%End
};

class JobFusionVideoMakerList : JobFusionList
{
%TypeHeaderCode
#include <jobfusionvideomakerlist.h>

%End
public:
	JobFusionVideoMakerList() /HoldGIL/;
	JobFusionVideoMakerList( const RecordList &, Table * t = 0 ) /HoldGIL/;
	JobFusionVideoMakerList( const JobFusionVideoMakerList & ) /HoldGIL/;
	JobFusionVideoMakerList( const Record &, Table * t = 0 ) /HoldGIL/;
	JobFusionVideoMakerList( SIP_PYLIST );
%MethodCode
	sipCpp = new JobFusionVideoMakerList( recordListFromPyList(a0), JobFusionVideoMaker::table() );
%End

	~JobFusionVideoMakerList() /HoldGIL/;

//	void insert( JobFusionVideoMakerIter, const JobFusionVideoMaker & );

//	JobFusionVideoMakerIter at( uint );

//	JobFusionVideoMakerIter find( const Record & );

//	JobFusionVideoMakerIter remove( const JobFusionVideoMakerIter & );

	int remove( const Record & ) /HoldGIL/;
	
	int remove() throw(SqlException,LostConnectionException,PythonException);
	
	//JobFusionVideoMakerIter begin();

	//JobFusionVideoMakerIter end();

	Table * table() const /HoldGIL/;
	TableSchema * schema() const /HoldGIL/;

	MappedJobFusionVideoMakerList filter( const QString & column, const QRegExp & re, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobFusionVideoMakerList filter( const QString & column, const QVariant & value, bool keepMatches = true ) const throw(SqlException,LostConnectionException,PythonException);
	MappedJobFusionVideoMakerList sorted( const QString & c, bool a = true ) const throw(SqlException,LostConnectionException,PythonException);

	MappedJobFusionVideoMakerList unique() const;
	MappedJobFusionVideoMakerList reversed() const;
	MappedJobFusionVideoMakerList reloaded() const;

	QMap<QString,RecordList> groupedBy( const QString & column ) const throw(SqlException,LostConnectionException,PythonException);

	PyObject * groupedBy( SIP_PYCALLABLE callable ) const throw(SqlException,LostConnectionException,PythonException);
%MethodCode
		sipRes = recordListGroupByCallable( sipCpp, a0, JobFusionVideoMaker::schema() );
%End

	QStringList codecs() const /HoldGIL/;
	MappedJobFusionVideoMakerList & setCodecs( const QString & );
	QStringList inputFramePaths() const /HoldGIL/;
	MappedJobFusionVideoMakerList & setInputFramePaths( const QString & );
	QList<uint> sequenceFrameStarts() const /HoldGIL/;
	MappedJobFusionVideoMakerList & setSequenceFrameStarts( const uint & );
	QList<uint> sequenceFrameEnds() const /HoldGIL/;
	MappedJobFusionVideoMakerList & setSequenceFrameEnds( const uint & );


};


