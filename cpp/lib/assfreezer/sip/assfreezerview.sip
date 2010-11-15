
class AssfreezerView : QWidget
{
%TypeHeaderCode
#include <assfreezerview.h>
%End
public:
	AssfreezerView( QWidget * parent );
	~AssfreezerView();

	virtual QString viewType() const = 0;

	QString viewName() const;
	void setViewName( const QString & );

	IniConfig & viewConfig();
	
	void restorePopup( QWidget * );

	virtual QToolBar * toolBar( QMainWindow * );

	virtual void populateViewMenu( QMenu * );

	virtual void applyOptions();

	virtual void save( IniConfig & ini );
	virtual void restore( IniConfig & ini );

	QString statusBarMessage() const;
	void setStatusBarMessage( const QString & );
	void clearStatusBar();

	int refreshCount() const;

public slots:
	void refresh();

signals:
	void statusBarMessageChanged( const QString & );

};