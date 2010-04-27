# Tell the original .pro file about additional directories.
INCLUDEPATH = ./ /usr/include/python2.5 ../../QtCore /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtCore
CONFIG += release
VPATH = /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtCore
include(/drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtCore/qpycore.pro)
