TARGET = QtSvg.so
OFILES = sipQtSvgcmodule.o sipQtSvgQSvgWidget.o sipQtSvgQSvgRenderer.o sipQtSvgQSvgGenerator.o sipQtSvgQGraphicsSvgItem.o
HFILES = sipAPIQtSvg.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtSvg -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtSvg.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtSvg -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -pthread -pthread -lXrender -lfontconfig -lXext -lX11 -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
MOC = /usr/local/Trolltech/Qt-4.5.3/bin/moc
.SUFFIXES: .c .o .cpp .cc .cxx .C


.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.cc.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.cxx.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.C.o:
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

.c.o:
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

all: $(TARGET)

$(OFILES): $(HFILES)

$(TARGET): $(OFILES)
	@echo '{ global: initQtSvg; local: *; };' > QtSvg.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtSvg || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtSvg
	cp -f ../sip/QtSvg/qsvggenerator.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSvg/qsvggenerator.sip
	cp -f ../sip/QtSvg/qsvgrenderer.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSvg/qsvgrenderer.sip
	cp -f ../sip/QtSvg/qgraphicssvgitem.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSvg/qgraphicssvgitem.sip
	cp -f ../sip/QtSvg/QtSvgmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSvg/QtSvgmod.sip
	cp -f ../sip/QtSvg/qsvgwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSvg/qsvgwidget.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtSvgcmodule.o
	-rm -f sipQtSvgQSvgWidget.o
	-rm -f sipQtSvgQSvgRenderer.o
	-rm -f sipQtSvgQSvgGenerator.o
	-rm -f sipQtSvgQGraphicsSvgItem.o
	-rm -f QtSvg.exp
