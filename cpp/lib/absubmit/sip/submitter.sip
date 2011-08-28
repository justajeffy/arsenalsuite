
class Submitter : QObject
{
%TypeHeaderCode
#include <submitter.h>
%End
public:
	Submitter( QObject * parent /TransferThis/ = 0 );

	~Submitter();

	void applyArgs( const QMap<QString,QString> & args );

	Job job();
	void newJobOfType( const JobType & job );
	void setFrameList( const QString & frameList, const QString & taskLabels = QString(), int frameNth = 0, bool frameFill = false );

	void addJobOutput( const QString & outputPath, const QString & outputName = QString(), const QString & frameList = QString(), const QString & taskLabels = QString(), int frameNth = 0, bool frameFill = false );

	void addServices( ServiceList services );
	void addDependencies( JobList deps );

	void setExitAppOnFinish( bool );

	bool submitSuspended() const;

signals:
	void submitError( const QString & error );
	void submitSuccess();

public slots:
	void submit();
	void setSubmitSuspended( bool );

};
