

SOURCES+=test.cpp

INCLUDEPATH+=../include
LIBS+=-L.. -lstone
TARGET=tests
CONFIG=qt thread warn_on debug
QT+=xml network sql gui
DESTDIR=./
