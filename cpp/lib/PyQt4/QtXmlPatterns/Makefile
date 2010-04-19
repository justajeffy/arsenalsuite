TARGET = QtXmlPatterns.so
OFILES = sipQtXmlPatternscmodule.o sipQtXmlPatternsQVector0100QXmlNodeModelIndex.o sipQtXmlPatternsQVector0100QXmlName.o sipQtXmlPatternsQXmlResultItems.o sipQtXmlPatternsQXmlQuery.o sipQtXmlPatternsQXmlNamePool.o sipQtXmlPatternsQXmlName.o sipQtXmlPatternsQXmlFormatter.o sipQtXmlPatternsQXmlSerializer.o sipQtXmlPatternsQSourceLocation.o sipQtXmlPatternsQSimpleXmlNodeModel.o sipQtXmlPatternsQAbstractXmlReceiver.o sipQtXmlPatternsQXmlItem.o sipQtXmlPatternsQAbstractXmlNodeModel.o sipQtXmlPatternsQXmlNodeModelIndex.o sipQtXmlPatternsQAbstractUriResolver.o sipQtXmlPatternsQAbstractMessageHandler.o
HFILES = sipAPIQtXmlPatterns.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_XMLPATTERNS_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtXmlPatterns -I/usr/local/Trolltech/Qt-4.5.3/include/QtNetwork -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtXmlPatterns.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtXmlPatterns -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtNetwork -L/usr/local/Trolltech/Qt-4.5.3/lib -pthread -L/lib64 -pthread -lQtCore -lz -lm -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtNetwork -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtXmlPatterns; local: *; };' > QtXmlPatterns.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns
	cp -f ../sip/QtXmlPatterns/qxmlformatter.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlformatter.sip
	cp -f ../sip/QtXmlPatterns/QtXmlPatternsmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/QtXmlPatternsmod.sip
	cp -f ../sip/QtXmlPatterns/qabstracturiresolver.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qabstracturiresolver.sip
	cp -f ../sip/QtXmlPatterns/qabstractmessagehandler.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qabstractmessagehandler.sip
	cp -f ../sip/QtXmlPatterns/qxmlquery.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlquery.sip
	cp -f ../sip/QtXmlPatterns/qabstractxmlreceiver.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qabstractxmlreceiver.sip
	cp -f ../sip/QtXmlPatterns/qsourcelocation.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qsourcelocation.sip
	cp -f ../sip/QtXmlPatterns/qxmlserializer.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlserializer.sip
	cp -f ../sip/QtXmlPatterns/qabstractxmlnodemodel.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qabstractxmlnodemodel.sip
	cp -f ../sip/QtXmlPatterns/qxmlnamepool.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlnamepool.sip
	cp -f ../sip/QtXmlPatterns/qsimplexmlnodemodel.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qsimplexmlnodemodel.sip
	cp -f ../sip/QtXmlPatterns/qxmlname.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlname.sip
	cp -f ../sip/QtXmlPatterns/qxmlresultitems.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXmlPatterns/qxmlresultitems.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtXmlPatternscmodule.o
	-rm -f sipQtXmlPatternsQVector0100QXmlNodeModelIndex.o
	-rm -f sipQtXmlPatternsQVector0100QXmlName.o
	-rm -f sipQtXmlPatternsQXmlResultItems.o
	-rm -f sipQtXmlPatternsQXmlQuery.o
	-rm -f sipQtXmlPatternsQXmlNamePool.o
	-rm -f sipQtXmlPatternsQXmlName.o
	-rm -f sipQtXmlPatternsQXmlFormatter.o
	-rm -f sipQtXmlPatternsQXmlSerializer.o
	-rm -f sipQtXmlPatternsQSourceLocation.o
	-rm -f sipQtXmlPatternsQSimpleXmlNodeModel.o
	-rm -f sipQtXmlPatternsQAbstractXmlReceiver.o
	-rm -f sipQtXmlPatternsQXmlItem.o
	-rm -f sipQtXmlPatternsQAbstractXmlNodeModel.o
	-rm -f sipQtXmlPatternsQXmlNodeModelIndex.o
	-rm -f sipQtXmlPatternsQAbstractUriResolver.o
	-rm -f sipQtXmlPatternsQAbstractMessageHandler.o
	-rm -f QtXmlPatterns.exp
