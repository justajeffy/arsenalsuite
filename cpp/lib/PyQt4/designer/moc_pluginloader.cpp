/****************************************************************************
** Meta object code from reading C++ file 'pluginloader.h'
**
** Created: Wed Feb 17 09:49:25 2010
**      by: The Qt Meta Object Compiler version 61 (Qt 4.5.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "pluginloader.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'pluginloader.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 61
#error "This file was generated using the moc from 4.5.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_PyCustomWidgets[] = {

 // content:
       2,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors

       0        // eod
};

static const char qt_meta_stringdata_PyCustomWidgets[] = {
    "PyCustomWidgets\0"
};

const QMetaObject PyCustomWidgets::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_PyCustomWidgets,
      qt_meta_data_PyCustomWidgets, 0 }
};

const QMetaObject *PyCustomWidgets::metaObject() const
{
    return &staticMetaObject;
}

void *PyCustomWidgets::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_PyCustomWidgets))
        return static_cast<void*>(const_cast< PyCustomWidgets*>(this));
    if (!strcmp(_clname, "QDesignerCustomWidgetCollectionInterface"))
        return static_cast< QDesignerCustomWidgetCollectionInterface*>(const_cast< PyCustomWidgets*>(this));
    if (!strcmp(_clname, "com.trolltech.Qt.Designer.CustomWidgetCollection"))
        return static_cast< QDesignerCustomWidgetCollectionInterface*>(const_cast< PyCustomWidgets*>(this));
    return QObject::qt_metacast(_clname);
}

int PyCustomWidgets::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
