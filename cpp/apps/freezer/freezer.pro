
MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

INCLUDEPATH += .out include
INCLUDEPATH += ../../lib/stone/include ../../lib/stone
INCLUDEPATH += ../../lib/stonegui/include ../../lib/stonegui/.out/
INCLUDEPATH += ../../lib/classes/autocore ../../lib/classes/autoimp ../../lib/classes
INCLUDEPATH += ../../lib/classesui/include ../../lib/classesui/.out/
INCLUDEPATH += ../../lib/absubmit/include ../../lib/absubmit/.out
INCLUDEPATH += ../../lib/freezer/include ../../lib/freezer/.out

INCLUDEPATH += /usr/include/stone /usr/include/stonegui /usr/include/classes /usr/include/classesui /usr/include/freezer

SOURCES+= \
	src/main.cpp

win32{
	INCLUDEPATH+=c:/source/sip/siplib
	PY_PATH=$$system("python -c \"from distutils.sysconfig import get_config_vars; print get_config_vars()['prefix']\"")
	INCLUDEPATH+=$$system("python -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	PY_VERSION=$$system("python -c \"from distutils.sysconfig import get_python_version; print get_python_version().replace('.','')\"")
	message(Python Version is $$PY_VERSION Python lib path is $$PY_LIB_PATH)
	LIBS+=-L$${PY_PATH}\libs -lpython$${PY_VERSION}
	LIBS += -lpsapi -lMpr -lws2_32 -lgdi32

	LIBS+=-L..\..\lib\freezer -lfreezer
	LIBS+=-L..\..\lib\classesui -lclassesui
	LIBS+=-L..\..\lib\stonegui -lstonegui
	LIBS+=-L..\..\lib\classes -lclasses
	LIBS+=-L..\..\lib\stone -lstone

	INCLUDEPATH+=c:\nvidia\cg\include
	LIBS+=-lpsapi -lMpr
	LIBS+=-lws2_32
	LIBS+=-lopengl32
}

isEmpty( PYTHON ) {
    PYTHON="python"
}

unix{
	LIBS+=-L../../lib/freezer -lfreezer
	LIBS+=-L../../lib/classesui -lclassesui
	LIBS+=-L../../lib/stonegui -lstonegui
	LIBS+=-L../../lib/classes -lclasses
	LIBS+=-L../../lib/stone -lstone
	LIBS+=-L../../lib/absubmit -labsubmit
	LIBS+=-lutil

	unix: LIBS+=-L$$(MAGICK_ROOT)/lib
	unix: LIBS+=-Wl,-rpath,$$(MAGICK_ROOT)/lib

    LIBS+=-lMagick++

	PY_VERSION=$$system($$PYTHON " -c \"from distutils.sysconfig import get_python_version; print get_python_version()\"")
	message(Python Version is $$PY_VERSION)
	INCLUDEPATH+=$$system($$PYTHON " -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	LIBS+=-lpython$${PY_VERSION}
}

# Python modules
win32 {
	LIBS+=-L../../lib/freezer/sipFreezer -lpyFreezer
	LIBS+=-L../../lib/classes/sipClasses -lpyClasses
	LIBS+=-L../../lib/classes/sipClassesui -lpyClassesui
	LIBS+=-L../../lib/stone/sipStone -lpyStone
	LIBS+=-L../../lib/stone/sipStonegui -lpyStonegui
	LIBS+=-L../../lib/absubmit/sipAbsubmit -lpyAbsubmit
	LIBS+=-L../../lib/sip/siplib -lsip
}

macx: CONFIG-=app_bundle
QMAKE_MACOSX_DEPLOYMENT_TARGET=10.5

RESOURCES+=freezer.qrc

CONFIG += qt thread warn_on opengl
QT+=opengl xml sql network
DESTDIR=./
RC_FILE = freezer.rc
TARGET=af

unix {
	target.path=$$(DESTDIR)/usr/local/bin
}
win32 {
	target.path=$$(DESTDIR)/blur/common/
}

INSTALLS += target
