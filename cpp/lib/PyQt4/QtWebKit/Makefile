TARGET = QtWebKit.so
OFILES = sipQtWebKitcmodule.o sipQtWebKitQList0100QWebDatabase.o sipQtWebKitQList0100QWebSecurityOrigin.o sipQtWebKitQList0100QWebPluginFactoryPlugin.o sipQtWebKitQList0100QWebHistoryItem.o sipQtWebKitQMultiMap0100QString0100QString.o sipQtWebKitQList0101QWebFrame.o sipQtWebKitQList0100QWebPluginFactoryMimeType.o sipQtWebKitQWebView.o sipQtWebKitQWebSettings.o sipQtWebKitQWebSecurityOrigin.o sipQtWebKitQWebPluginFactoryExtensionReturn.o sipQtWebKitQWebPluginFactoryExtensionOption.o sipQtWebKitQWebPluginFactoryPlugin.o sipQtWebKitQWebPluginFactoryMimeType.o sipQtWebKitQWebPluginFactory.o sipQtWebKitQWebPageChooseMultipleFilesExtensionReturn.o sipQtWebKitQWebPageChooseMultipleFilesExtensionOption.o sipQtWebKitQWebPageExtensionReturn.o sipQtWebKitQWebPageExtensionOption.o sipQtWebKitQWebPageFindFlags.o sipQtWebKitQWebPage.o sipQtWebKitQWebHistoryInterface.o sipQtWebKitQWebHistory.o sipQtWebKitQWebHistoryItem.o sipQtWebKitQWebFrame.o sipQtWebKitQWebHitTestResult.o sipQtWebKitQWebDatabase.o
HFILES = sipAPIQtWebKit.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_WEBKIT_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtWebKit -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtNetwork -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtWebKit.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtWebKit -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lphonon -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtDBus -pthread -L/lib64 -pthread -pthread -pthread -pthread -pthread -lQtXml -pthread -pthread -pthread -pthread -pthread -pthread -pthread -pthread -L/usr/X11R6/lib64 -pthread -pthread -pthread -pthread -pthread -pthread -pthread -pthread -lQtGui -pthread -lfreetype -lgobject-2.0 -lSM -lICE -pthread -pthread -lXrender -lfontconfig -lXext -lX11 -lQtNetwork -pthread -pthread -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtNetwork -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtWebKit; local: *; };' > QtWebKit.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit
	cp -f ../sip/QtWebKit/qwebpluginfactory.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebpluginfactory.sip
	cp -f ../sip/QtWebKit/qwebframe.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebframe.sip
	cp -f ../sip/QtWebKit/qwebview.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebview.sip
	cp -f ../sip/QtWebKit/QtWebKitmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/QtWebKitmod.sip
	cp -f ../sip/QtWebKit/qwebpage.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebpage.sip
	cp -f ../sip/QtWebKit/qwebsecurityorigin.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebsecurityorigin.sip
	cp -f ../sip/QtWebKit/qwebsettings.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebsettings.sip
	cp -f ../sip/QtWebKit/qwebhistory.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebhistory.sip
	cp -f ../sip/QtWebKit/qwebhistoryinterface.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebhistoryinterface.sip
	cp -f ../sip/QtWebKit/qwebdatabase.sip $(DESTDIR)/usr/share/sip/PyQt4/QtWebKit/qwebdatabase.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtWebKitcmodule.o
	-rm -f sipQtWebKitQList0100QWebDatabase.o
	-rm -f sipQtWebKitQList0100QWebSecurityOrigin.o
	-rm -f sipQtWebKitQList0100QWebPluginFactoryPlugin.o
	-rm -f sipQtWebKitQList0100QWebHistoryItem.o
	-rm -f sipQtWebKitQMultiMap0100QString0100QString.o
	-rm -f sipQtWebKitQList0101QWebFrame.o
	-rm -f sipQtWebKitQList0100QWebPluginFactoryMimeType.o
	-rm -f sipQtWebKitQWebView.o
	-rm -f sipQtWebKitQWebSettings.o
	-rm -f sipQtWebKitQWebSecurityOrigin.o
	-rm -f sipQtWebKitQWebPluginFactoryExtensionReturn.o
	-rm -f sipQtWebKitQWebPluginFactoryExtensionOption.o
	-rm -f sipQtWebKitQWebPluginFactoryPlugin.o
	-rm -f sipQtWebKitQWebPluginFactoryMimeType.o
	-rm -f sipQtWebKitQWebPluginFactory.o
	-rm -f sipQtWebKitQWebPageChooseMultipleFilesExtensionReturn.o
	-rm -f sipQtWebKitQWebPageChooseMultipleFilesExtensionOption.o
	-rm -f sipQtWebKitQWebPageExtensionReturn.o
	-rm -f sipQtWebKitQWebPageExtensionOption.o
	-rm -f sipQtWebKitQWebPageFindFlags.o
	-rm -f sipQtWebKitQWebPage.o
	-rm -f sipQtWebKitQWebHistoryInterface.o
	-rm -f sipQtWebKitQWebHistory.o
	-rm -f sipQtWebKitQWebHistoryItem.o
	-rm -f sipQtWebKitQWebFrame.o
	-rm -f sipQtWebKitQWebHitTestResult.o
	-rm -f sipQtWebKitQWebDatabase.o
	-rm -f QtWebKit.exp
