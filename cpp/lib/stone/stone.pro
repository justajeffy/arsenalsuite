
MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

SOURCES += \
	src/blurqt.cpp \
	src/connection.cpp \
	src/dateutil.cpp \
	src/iniconfig.cpp \
	src/recordproxy.cpp \
	src/renderelements.cpp \
	src/database.cpp \
	src/field.cpp \
	src/freezercore.cpp \
	src/index.cpp \
	src/indexschema.cpp \
	src/interval.cpp \
	src/path.cpp \
	src/packetsocket.cpp \
	src/pgconnection.cpp \
	src/process.cpp \
	src/process_win.cpp \
	src/pyembed.cpp \
	src/quickdatastream.cpp \
	src/recentvalues.cpp \
	src/record.cpp \
	src/recordlist.cpp \
	src/recordimp.cpp \
	src/recordxml.cpp \
	src/remotelogserver.cpp \
	src/schema.cpp \
	src/sqlerrorhandler.cpp \
	src/table.cpp \
	src/tableschema.cpp \
	src/transactionmgr.cpp \
	src/updatemanager.cpp \
	src/undomanager.cpp \
	src/multilog.cpp \
	src/md5_globalstuff.cpp \
	src/md5.cpp \
	src/bt.cpp

	
HEADERS += \
	include/blurqt.h \
	include/connection.h \
	include/dateutil.h \
	include/iniconfig.h \
	include/recordproxy.h \
	include/renderelements.h \
	include/database.h \
	include/field.h \
	include/freezercore.h \
	include/index.h \
	include/indexschema.h \
	include/interval.h \
	include/path.h \
	include/packetsocket.h \
	include/pgconnection.h \
	include/process.h \
	include/pyembed.h \
	include/quickdatastream.h \
	include/recentvalues.h \
	include/record.h \
	include/recordimp.h \
	include/recordlist.h \
	include/recordxml.h \
	include/remotelogserver.h \
	include/schema.h \
	include/sqlerrorhandler.h \
	include/table.h \
	include/tableschema.h \
	include/transactionmgr.h \
	include/updatemanager.h \
	include/undomanager.h \
	include/multilog.h \
	include/md5_bithelp.h \
	include/md5_globalstuff.h \ 
	include/md5.h
	
INCLUDEPATH+=include src .out

DEPENDPATH+=src include

DEFINES+=STONE_MAKE_DLL

win32 {
	LIBS+=-lPsapi -lMpr -ladvapi32 -lshell32 -luser32 -lpdh -lUserenv
	LIBS+=-Lc:\IntelLib
	PY_PATH=$$system("python -c \"from distutils.sysconfig import get_config_vars; print get_config_vars()['prefix']\"")
	INCLUDEPATH+=$$system("python -c \"from distutils.sysconfig import get_python_inc; print get_python_inc()\"")
	PY_VERSION=$$system("python -c \"from distutils.sysconfig import get_python_version; print get_python_version().replace('.','')\"")
	message(Python Version is $$PY_VERSION Python lib path is $$PY_LIB_PATH)
	LIBS+=-L$${PY_PATH}\libs -lpython$${PY_VERSION}
}

isEmpty( PYTHON ) {
    PYTHON="python"
}

unix {
    PY_CMD =  $$PYTHON " -V 2>&1 | perl -e '$s=<STDIN>; $s =~ s/Python (\d\.\d)\.\d/$1/; print $s'"
    PY_VERSION = $$system($$PY_CMD)
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
	TARGET=stone$$SVNREV
} else {
	TARGET=stone
}

unix {
	target.path=$$(DESTDIR)/usr/local/lib
}
win32 {
	target.path=c:/blur/common/
}

INSTALLS += target
CONFIG+=qt thread
QT+=sql xml network

DESTDIR=./
