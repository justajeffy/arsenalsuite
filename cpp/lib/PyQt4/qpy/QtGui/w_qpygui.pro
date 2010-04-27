# Tell the original .pro file about additional directories.
INCLUDEPATH = ./ /usr/include/python2.5 /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtGui
CONFIG += release
VPATH = /drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtGui
include(/drd/users/barry.robison/arsenalsuite/cpp/lib/PyQt4/qpy/QtGui/qpygui.pro)
