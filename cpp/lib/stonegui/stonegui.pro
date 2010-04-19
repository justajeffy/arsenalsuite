
MOC_DIR=.out
OBJECTS_DIR=.out
UI_DIR=.out

FORMS+=ui/lostconnectiondialogui.ui \
	ui/configdbdialogui.ui \
	ui/imagesequencewidget.ui \
	ui/remotetailwindowui.ui

SOURCES += \
	src/actions.cpp \
	src/configdbdialog.cpp \
	src/ffimagesequenceprovider.cpp \
#	src/phononimagesequenceprovider.cpp \
	src/fieldcheckbox.cpp \
	src/fieldlineedit.cpp \
	src/fieldtextedit.cpp \
	src/fieldspinbox.cpp \
	src/glutil.cpp \
	src/iconserver.cpp \
	src/imagesequenceprovider.cpp \
	src/lostconnectiondialog.cpp \
	src/modeliter.cpp \
	src/qvariantcmp.cpp \
	src/recordcombo.cpp \
	src/recorddelegate.cpp \
	src/recorddrag.cpp \
	src/recordlistmodel.cpp \
	src/recordlistview.cpp \
#	src/tardstyle.cpp \
	src/recentvaluesui.cpp \
	src/recordpropvalmodel.cpp \
	src/recordpropvaltree.cpp \
	src/recordsupermodel.cpp \
	src/recordtreeview.cpp \
	src/stonegui.cpp \
	src/supermodel.cpp \
	src/remotetailwidget.cpp \
	src/remotetailwindow.cpp \
	src/imagesequencewidget.cpp \
	src/undotoolbutton.cpp \
	src/viewcolors.cpp

HEADERS += \
	include/actions.h \
	include/configdbdialog.h \
	include/ffimagesequenceprovider.h \
#	include/phononimagesequenceprovider.h \
	include/fieldcheckbox.h \
	include/fieldlineedit.h \
	include/fieldtextedit.h \
	include/fieldspinbox.h \
	include/glutil.h \
	include/iconserver.h \
	include/imagesequenceprovider.h \
	include/lostconnectiondialog.h \
	include/modeliter.h \
	include/qvariantcmp.h \
	include/recentvaluesui.h \
	include/recordcombo.h \
	include/recorddelegate.h \
	include/recorddrag.h \
	include/recordlistmodel.h \
	include/recordlistview.h \
	include/recordpropvalmodel.h \
	include/recordpropvaltree.h \
	include/recordsupermodel.h \
#	include/tardstyle.h \
	include/recordtreeview.h \
	include/stonegui.h \
	include/supermodel.h \
	include/remotetailwidget.h \
	include/remotetailwindow.h \
	include/imagesequencewidget.h \
	include/undotoolbutton.h \
	include/viewcolors.h

INCLUDEPATH+=include src .out ../stone/include ../stone/.out

DEPENDPATH+=src include ui

win32 {
	LIBS += -lPsapi -lMpr -ladvapi32 
	LIBS+=-Lc:\IntelLib
	LIBS+=-L../stone -lstone
}

macx{
	INCLUDEPATH+=/Developer/SDKs/MacOSX10.4u.sdk/usr/X11R6/include/
	LIBS+=-L../stone -lstone
}

# FFmpeg support
unix:DEFINES-=USE_FFMPEG
#win32:DEFINES+=USE_FFMPEG

contains( DEFINES, USE_FFMPEG ) {
	win32 {
		INCLUDEPATH += c:/msys/1.0/local/include/ffmpeg
		LIBS+=-Lc:/msys/1.0/local/lib -lavcodec -lavformat -lavutil
	}
	
	unix {
		INCLUDEPATH += /usr/local/include/ffmpeg/
		LIBS+=-L/usr/local/lib/ -lavcodec -lavutil -lavformat
	}
}

# Phonon support
unix:DEFINES-=USE_PHONON
contains( DEFINES, USE_PHONON ) {
	QT+=phonon
}

DEFINES+=STONEGUI_MAKE_DLL
TEMPLATE=lib
TARGET=stonegui
target.path=$$(DESTDIR)/usr/local/lib
INSTALLS += target
CONFIG+=qt thread
QT+=sql xml gui network opengl

DESTDIR=./
