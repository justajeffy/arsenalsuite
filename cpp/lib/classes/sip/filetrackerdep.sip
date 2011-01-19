
%MappedType MappedFileTrackerDep
{
%TypeHeaderCode
#include <record.h>
#include <pyembed.h>
#include "filetrackerdeplist.h"
#include "filetrackerdeptable.h"
#define MappedFileTrackerDep FileTrackerDep
%End

%ConvertToTypeCode
	if (sipIsErr == NULL)
		return isPythonRecordInstance(sipPy) ? 1 : 0;

	*sipCppPtr = new FileTrackerDep(sipUnwrapRecord(sipPy));

	return sipGetState(sipTransferObj);
%End

%ConvertFromTypeCode
	return sipWrapRecord( sipCpp, true, FileTrackerDepSchema::instance() );
%End
};

class FileTrackerDep : Record
{
%TypeHeaderCode
#include <filetrackerdep.h>
#include "filetracker.h"
#include "filetracker.h"

%End
public:
	FileTrackerDep();

	FileTrackerDep( uint key );

	FileTrackerDep( const FileTrackerDep & other );

	FileTrackerDep( const Record & r );

	FileTrackerDep( RecordImp * imp, bool checkType = true );
	
	MappedFileTrackerDep copy() const;

	bool operator==( const Record & other ) const;

	bool operator!=( const Record & other ) const;
	
	bool operator <( const Record & other ) const;

	long __hash__() const;
%MethodCode
		sipRes = sipCpp->key();
%End

	MappedFileTracker input() const;
	MappedFileTrackerDep & setInput( const FileTracker & );
	MappedFileTracker output() const;
	MappedFileTrackerDep & setOutput( const FileTracker & );


	static MappedFileTrackerDepList select( const QString & where = QString::null, const QList<QVariant> & args = QList<QVariant>() );

	MappedFileTrackerDep reload( bool lockForUpdate = false );

	static MappedFileTrackerDepList recordsByInput( const FileTracker &fkeyInput );
	static MappedFileTrackerDepList recordsByOutput( const FileTracker &fkeyOutput );
	static MappedFileTrackerDep recordByInputAndOutput( const FileTracker &fkeyInput, const FileTracker &fkeyOutput );






	static Table * table();
	//static FileTrackerDepSchema * schema();
};


