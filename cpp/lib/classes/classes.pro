
include( auto.pri )

MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

INCLUDES += \
	classes.h

SOURCES += \
	classes.cpp

INCLUDEPATH+=../stone/include autocore autoimp base /usr/include/stone .

DESTDIR=$$(DESTDIR)

win32 {
	LIBS+=-lMpr -lws2_32 -ladvapi32
	PY_PATH=$$system("python -c \"from distutils.sysconfig import get_config_vars; print get_config_vars()['prefix']\"")
	INCLUDEPATH+=$$system("python -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	PY_VERSION=$$system("python -c \"from distutils.sysconfig import get_python_version; print get_python_version().replace('.','')\"")
	message(Python Version is $$PY_VERSION Python lib path is $$PY_PATH\libs)
	LIBS+=-L$${PY_PATH}\libs -lpython$${PY_VERSION}
}

isEmpty( PYTHON ) {
    PYTHON="python"
}

unix {
	PY_VERSION=$$system($$PYTHON " -c \"from distutils.sysconfig import get_python_version; print get_python_version()\"")
	message(Python Version is $$PY_VERSION)
	INCLUDEPATH+=$$system($$PYTHON " -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	LIBS+=-lpython$${PY_VERSION}
    count ( DESTDIR, 1 ) {
        INCLUDEPATH+=$${DESTDIR}/usr/include/python$${PY_VERSION}
    }
}

DEFINES+=CLASSES_MAKE_DLL
TEMPLATE=lib
CONFIG+=qt thread
TARGET=classes
LIBS+=-L../stone -lstone

unix {
	target.path=$$(DESTDIR)/usr/local/lib
}
win32 {
	target.path=$$(DESTDIR)/blur/common/
}

INSTALLS += target

QT+=xml sql network

DESTDIR=./
