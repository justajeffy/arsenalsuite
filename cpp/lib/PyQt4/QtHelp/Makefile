TARGET = QtHelp.so
OFILES = sipQtHelpcmodule.o sipQtHelpQList0100QHelpSearchQuery.o sipQtHelpQMap0100QString0100QUrl.o sipQtHelpQList0100QStringList.o sipQtHelpQHelpSearchResultWidget.o sipQtHelpQHelpSearchQueryWidget.o sipQtHelpQHelpSearchEngine.o sipQtHelpQHelpSearchQuery.o sipQtHelpQHelpIndexWidget.o sipQtHelpQHelpIndexModel.o sipQtHelpQHelpEngine.o sipQtHelpQHelpEngineCore.o sipQtHelpQHelpContentWidget.o sipQtHelpQHelpContentModel.o sipQtHelpQHelpContentItem.o
HFILES = sipAPIQtHelp.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtHelp -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtHelp.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtHelp -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCLucene -L/usr/local/Trolltech/Qt-4.5.3/lib -pthread -L/lib64 -pthread -lQtSql -L/usr/lib64 -lpq -pthread -pthread -lQtXml -pthread -pthread -lQtGui -L/usr/X11R6/lib64 -pthread -lfreetype -lgobject-2.0 -lSM -lICE -pthread -pthread -lXrender -lfontconfig -lXext -lX11 -lQtNetwork -pthread -pthread -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtHelp; local: *; };' > QtHelp.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtHelp || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtHelp
	cp -f ../sip/QtHelp/qhelpindexwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpindexwidget.sip
	cp -f ../sip/QtHelp/qhelpsearchengine.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpsearchengine.sip
	cp -f ../sip/QtHelp/qhelpcontentwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpcontentwidget.sip
	cp -f ../sip/QtHelp/qhelpenginecore.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpenginecore.sip
	cp -f ../sip/QtHelp/qhelpsearchquerywidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpsearchquerywidget.sip
	cp -f ../sip/QtHelp/QtHelpmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/QtHelpmod.sip
	cp -f ../sip/QtHelp/qhelpengine.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpengine.sip
	cp -f ../sip/QtHelp/qhelpsearchresultwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtHelp/qhelpsearchresultwidget.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtHelpcmodule.o
	-rm -f sipQtHelpQList0100QHelpSearchQuery.o
	-rm -f sipQtHelpQMap0100QString0100QUrl.o
	-rm -f sipQtHelpQList0100QStringList.o
	-rm -f sipQtHelpQHelpSearchResultWidget.o
	-rm -f sipQtHelpQHelpSearchQueryWidget.o
	-rm -f sipQtHelpQHelpSearchEngine.o
	-rm -f sipQtHelpQHelpSearchQuery.o
	-rm -f sipQtHelpQHelpIndexWidget.o
	-rm -f sipQtHelpQHelpIndexModel.o
	-rm -f sipQtHelpQHelpEngine.o
	-rm -f sipQtHelpQHelpEngineCore.o
	-rm -f sipQtHelpQHelpContentWidget.o
	-rm -f sipQtHelpQHelpContentModel.o
	-rm -f sipQtHelpQHelpContentItem.o
	-rm -f QtHelp.exp
