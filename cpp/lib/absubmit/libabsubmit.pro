
MOC_DIR        = .out
OBJECTS_DIR    = .out
UI_DIR         = .out

INCLUDEPATH+=include
INCLUDEPATH+=../../lib/stone/include
INCLUDEPATH+=../../lib/classes/autocore ../../lib/classes ../../lib/classes/base

unix:INCLUDEPATH+=/usr/include/stone
unix:INCLUDEPATH+=/usr/include/classes

SOURCES += \
	src/submitter.cpp

HEADERS += \
	include/submitter.h \
	include/absubmit.h

LIBS += -L../../lib/classes -lclasses -L../../lib/stone -lstone
win32:LIBS += -lpsapi -lMpr

DEFINES += AB_SUBMIT_MAKE_DLL

TEMPLATE=lib
CONFIG += qt thread warn_on dll
QT += xml sql network

TARGET=absubmit

DESTDIR=./

target.path=$$(DESTDIR)/usr/local/lib
INSTALLS += target
