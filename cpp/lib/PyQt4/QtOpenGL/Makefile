TARGET = QtOpenGL.so
OFILES = sipQtOpenGLcmodule.o sipQtOpenGLQGLPixelBuffer.o sipQtOpenGLQGLFramebufferObject.o sipQtOpenGLQGLColormap.o sipQtOpenGLQGLWidget.o sipQtOpenGLQGLContext.o sipQtOpenGLQGLFormatOpenGLVersionFlags.o sipQtOpenGLQGLFormat.o sipQtOpenGLQGLFormatOptions.o sipQtOpenGLQGL.o
HFILES = sipAPIQtOpenGL.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_OPENGL_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtOpenGL -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtOpenGL.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtOpenGL -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lGLU -lGL -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -pthread -pthread -lXrender -lfontconfig -lXext -lX11 -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lGLU -lGL -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtOpenGL; local: *; };' > QtOpenGL.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL
	cp -f ../sip/QtOpenGL/QtOpenGLmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL/QtOpenGLmod.sip
	cp -f ../sip/QtOpenGL/qglframebufferobject.sip $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL/qglframebufferobject.sip
	cp -f ../sip/QtOpenGL/qglpixelbuffer.sip $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL/qglpixelbuffer.sip
	cp -f ../sip/QtOpenGL/qglcolormap.sip $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL/qglcolormap.sip
	cp -f ../sip/QtOpenGL/qgl.sip $(DESTDIR)/usr/share/sip/PyQt4/QtOpenGL/qgl.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtOpenGLcmodule.o
	-rm -f sipQtOpenGLQGLPixelBuffer.o
	-rm -f sipQtOpenGLQGLFramebufferObject.o
	-rm -f sipQtOpenGLQGLColormap.o
	-rm -f sipQtOpenGLQGLWidget.o
	-rm -f sipQtOpenGLQGLContext.o
	-rm -f sipQtOpenGLQGLFormatOpenGLVersionFlags.o
	-rm -f sipQtOpenGLQGLFormat.o
	-rm -f sipQtOpenGLQGLFormatOptions.o
	-rm -f sipQtOpenGLQGL.o
	-rm -f QtOpenGL.exp
