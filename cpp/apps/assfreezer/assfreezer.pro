
MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

INCLUDEPATH += .out include
INCLUDEPATH += ../../lib/stone/include ../../lib/stone
INCLUDEPATH += ../../lib/stonegui/include ../../lib/stonegui/.out/
INCLUDEPATH += ../../lib/classes/autocore ../../lib/classes/autoimp ../../lib/classes
INCLUDEPATH += ../../lib/classesui/include ../../lib/classesui/.out/
INCLUDEPATH += ../../lib/absubmit/include ../../lib/absubmit/.out
INCLUDEPATH += ../../lib/assfreezer/include ../../lib/assfreezer/.out

INCLUDEPATH += /usr/include/stone /usr/include/stonegui /usr/include/classes /usr/include/classesui /usr/include/assfreezer

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

	LIBS+=-L..\..\lib\assfreezer -lassfreezer
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
#	Link libassfreezer and libblurqt statically
#	Link them dynamically
#	LIBS+=-lCgGL -Wl,-rpath . -L../libassfreezer -L../libblurqt -lassfreezer -lblurqt
	LIBS+=-L../../lib/assfreezer -lassfreezer
	LIBS+=-L../../lib/classesui -lclassesui
	LIBS+=-L../../lib/stonegui -lstonegui
	LIBS+=-L../../lib/classes -lclasses
	LIBS+=-L../../lib/stone -lstone
	LIBS+=-L../../lib/absubmit -labsubmit

	unix!macx: LIBS+=-L/drd/software/ext/imageMagick/lin64/current/lib
	macx: LIBS+=-L/drd/software/ext/imageMagick/osx/current/lib

    #LIBS+=-Wl,-rpath .
    LIBS+=-lMagick++

    PY_CMD =  $$PYTHON " -V 2>&1 | perl -e '$s=<STDIN>; $s =~ s/Python (\d\.\d)\.\d/$1/; print $s'"
    PY_VERSION = $$system($$PY_CMD)
	message(Python Version is $$PY_VERSION)
	INCLUDEPATH += /usr/include/python$${PY_VERSION}/
	LIBS+=-lpython$${PY_VERSION}
}

# Python modules
win32 {
	LIBS+=-L../../lib/assfreezer/sipAssfreezer -lpyAssfreezer
	LIBS+=-L../../lib/classes/sipClasses -lpyClasses
	LIBS+=-L../../lib/stone/sipStone -lpyStone
	LIBS+=-L../../lib/absubmit/sipAbsubmit -lpyAbsubmit
	LIBS+=-L../../lib/sip/siplib -lsip
}

macx: CONFIG-=app_bundle

RESOURCES+=assfreezer.qrc

CONFIG += qt thread warn_on opengl
QT+=opengl xml sql network
DESTDIR=./
RC_FILE = assfreezer.rc
TARGET = assfreezer

unix {
	target.path=$$(DESTDIR)/usr/local/bin
}
win32 {
	target.path=$$(DESTDIR)/blur/common/
}

INSTALLS += target
