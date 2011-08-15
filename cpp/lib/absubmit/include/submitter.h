

#ifndef SUBMITTER_H
#define SUBMITTER_H

#include "employee.h"
#include "host.h"
#include "job.h"
#include "jobdep.h"
#include "joboutput.h"
#include "jobstat.h"
#include "jobservice.h"
#include "jobtask.h"
#include "jobtype.h"
#include "path.h"
#include "project.h"
#include "user.h"

#include "database.h"
#include "md5.h"
#include "table.h"

#include "absubmit.h"


class QFtp;
class QFile;

/// Returns the error number, where the error file is
/// c:/blur/absubmit/errors/ERROR_NUMBER.txt
AB_SUBMIT_EXPORT int writeErrorFile( const QString & error );

class AB_SUBMIT_EXPORT Submitter : public QObject
{
Q_OBJECT
public:
	Submitter( QObject * parent = 0 );

	~Submitter();

    /// the main function that needs to be called on the instanced Submitter object
	void applyArgs( const QMap<QString,QString> & args );

	Job job();

    /// does some magic so that mJob is the correct class
	void newJobOfType( const JobType & job );

	// Only use this if you have already added 1 or more job outputs, otherwise use addJobOutput
	void setFrameList( const QString & frameList, const QString & taskLabels = QString(), int frameNth = 0, bool frameFill = false );

	void addJobOutput( const QString & outputPath, const QString & outputName = QString(), const QString & frameList = QString(), const QString & taskLabels = QString(), int frameNth = 0, bool frameFill = false );

    /// jobs may need multiple JobService entries if they require licenses or the like
	void addServices( ServiceList services );

    /// adds an entry to the JobDep table, mapping two jobs together
    /// depType == 1 is for hard dependencies, when parent job is complete the child will be able to run
    /// depType == 2 is for soft or "linked" jobs, meaning when task N from the parent job is done
    ///    then task N from the child job can run 
	void addDependencies( JobList deps, uint depType=1 );

    /// should we do a real exit(), or is this being used as a library where more submissions might follow
	void setExitAppOnFinish( bool );

	bool submitSuspended() const;

signals:
    /// clients of this library should hook into these signals to get notified when things are done
	void submitError( const QString & error );
	void submitSuccess();

public slots:
    /// does a couple final checks and submits
	void submit();
	void setSubmitSuspended( bool );

protected slots:
	void ftpStateChange( int );
	void ftpDone(bool);
	void ftpTransferProgress(qint64,qint64);
	void ftpCommandStarted(int);
	void ftpCommandFinished(int,bool);
	void checkJobStatus();

protected:
	bool checkFarmReady();
	void startCopy();
	void postCopy();
	void checkFileFree();
	void checkMd5();
	void preCopy();
	void ftpCleanup();
	void issueFtpCommands( bool makeUserDir );

	void printJobInfo();

	int submitCheck();

	int createTasks( QList<int> taskNumbers, QStringList labels, JobOutputList outputs, int frameNth, bool frameFill );

	void exitWithError( const QString & );

	bool mUploadEnabled;
	Job mJob;
	JobOutputList mOutputs;
	JobDepList mJobDeps;
	JobTaskList mTasks;
    JobServiceList mServices;

	QFtp * mFtp;
	QFile * mFile;
	QFile * mFile2;

	QString mHost;
	int mPort, mRetries, mTimeout;
	int mCdCmdId, mMkDirCmdId, mPutCmdId, mPutCmdId2;
	bool mCreateDirTried;
	bool mHaveJobInfoFile;
	bool mSubmitSuspended;
	QString mSrc, mFileName, mDest, mSrc2, mDest2;
	// Percentage
	int mProgress;
	QTimer * mVerifyTimer;
	bool mExitAppOnFinish;
    QString mInitialTaskStatus;
};

#endif // SUBMITTER_H

