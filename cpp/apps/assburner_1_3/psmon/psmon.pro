
MOC_DIR        = .out
OBJECTS_DIR    = .out
UI_DIR         = .out


INCLUDEPATH+=../../../lib/stone/include

unix {
	INCLUDEPATH+=/usr/include/stone

	PY_VERSION = $$system("python -V 2>&1 | perl -e '$s=<STDIN>; $s =~ s/Python (\d\.\d)\.\d/$1/; print $s'")

	message(Python Version is $$PY_VERSION)
	INCLUDEPATH += /usr/include/python$${PY_VERSION}/
	LIBS+=-lpython$${PY_VERSION}
}

LIBS+=-L../../../lib/stone -lstone

SOURCES += \
	psmon.cpp

win32:LIBS += -lpsapi -lMpr -lws2_32 -lgdi32

CONFIG += qt warn_on
QT-= gui
QT+= network

TARGET=abpsmon

win32 {
	debug {
		CONFIG += console
	}
}

DESTDIR=./

unix {
	target.path=/usr/bin/
	INSTALLS += target
}
macx:CONFIG-=app_bundle
