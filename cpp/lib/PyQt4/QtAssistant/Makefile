TARGET = QtAssistant.so
OFILES = sipQtAssistantcmodule.o sipQtAssistantQAssistantClient.o
HFILES = sipAPIQtAssistant.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtAssistant -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtNetwork -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtAssistant.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtAssistantClient -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtNetwork -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtAssistant; local: *; };' > QtAssistant.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtAssistant || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtAssistant
	cp -f ../sip/QtAssistant/qassistantclient.sip $(DESTDIR)/usr/share/sip/PyQt4/QtAssistant/qassistantclient.sip
	cp -f ../sip/QtAssistant/QtAssistantmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtAssistant/QtAssistantmod.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtAssistantcmodule.o
	-rm -f sipQtAssistantQAssistantClient.o
	-rm -f QtAssistant.exp
