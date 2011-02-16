
MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

SOURCES += \
	src/epaloader.cpp


HEADERS += \
	include/epaloader.h
	
INCLUDEPATH+=include src .out

DEPENDPATH+=src include

DEFINES+=EPA_MAKE_DLL

win32 {
	LIBS+=-lPsapi -lMpr -ladvapi32 -lshell32 -luser32 -lpdh -lUserenv
	LIBS+=-Lc:\IntelLib
	INCLUDEPATH+=$$system("python -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	PY_VERSION=$$system("python -c \"from distutils.sysconfig import get_python_version; print get_python_version().replace('.','')\"")
	LIBS+=-Lc:/python$${PY_VERSION}/libs -lpython$${PY_VERSION}
}

unix {
	PY_VERSION = $$system("python -V 2>&1 | perl -e '$s=<STDIN>; $s =~ s/Python (\d\.\d)\.\d/$1/; print $s'")

	message(Python Version is $$PY_VERSION)
	INCLUDEPATH += /usr/include/python$${PY_VERSION}/
	INCLUDEPATH += ../sip/siplib/
	LIBS+=-lpython$${PY_VERSION}
}

macx{
  INCLUDEPATH += /opt/local/include/python$${PY_VERSION}/
}

TEMPLATE=lib
contains( DEFINES, versioned ) {
	TARGET=epa$$SVNREV
} else {
	TARGET=epa
}

unix {
	target.path=/usr/local/lib
}
win32 {
	target.path=c:/blur/common/
}

INSTALLS += target
CONFIG+=qt thread
QT+=xml

DESTDIR=./

