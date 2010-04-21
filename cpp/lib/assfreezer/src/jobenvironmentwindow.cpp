
/* $Header$
 */

#include "jobenvironmentwindow.h"

JobEnvironmentWindow::JobEnvironmentWindow( QWidget * parent )
: QDialog( parent )
{
	setupUi( this );
	resize(600, 800);
}

QString JobEnvironmentWindow::environment()
{
	return textEdit->toPlainText();
}

void JobEnvironmentWindow::setEnvironment(const QString & env)
{
	textEdit->setText( env );
}

