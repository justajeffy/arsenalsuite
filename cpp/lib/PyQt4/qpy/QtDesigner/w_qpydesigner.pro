# Tell the original .pro file about additional directories.
INCLUDEPATH = ./ /usr/include/python2.5 /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtDesigner
CONFIG += release
VPATH = /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtDesigner
include(/drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtDesigner/qpydesigner.pro)
