
#ifndef GRAPHITE_H
#define GRAPHITE_H

#include <qdatetime.h>
#include <qstring.h>

#include "blurqt.h"

/**
 *  Path refers to a graphite path consisting of Element[.Element]+
 *  Path can contain %(user) which will be replace by the current username
 *  and %(host) which will be replaced by the current hostname.
 *  Values will be written from a worker thread so this function 
 *  will return immediately.
 **/
STONE_EXPORT void graphiteRecord( const QString & path, double value, const QDateTime & timestamp = QDateTime::currentDateTime() );

#endif // GRAPHITE_H
