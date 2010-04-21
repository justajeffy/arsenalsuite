

/* $Header$
 */

#ifndef BATCH_SUBMIT_DIALOG_H
#define BATCH_SUBMIT_DIALOG_H

#include <qdialog.h>

#include "ui_batchsubmitdialogui.h"

#include "afcommon.h"
#include "host.h"

class ASSFREEZER_EXPORT BatchSubmitDialog : public QDialog, public Ui::BatchSubmitDialogUI
{
Q_OBJECT
public:
	BatchSubmitDialog( QWidget * parent );
	~BatchSubmitDialog();

	void setHostList( const HostList & );
	void setName( const QString & );
	void setCommand( const QString & );
	void setDisableWow64FsRedirect( bool dfsr );
	void setCannedBatchGroup( const QString & );

	void setSaveCannedBatchMode( bool );

	void accept();
public slots:
	void addFiles();
	void removeFiles();
	void clearFiles();

protected:
	HostList mHosts;
	bool mSaveCannedBatchMode;
};

#endif // BATCH_SUBMIT_DIALOG_H

