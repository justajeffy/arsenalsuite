TARGET = QtXml.so
OFILES = sipQtXmlcmodule.o sipQtXmlQXmlDefaultHandler.o sipQtXmlQXmlDeclHandler.o sipQtXmlQXmlLexicalHandler.o sipQtXmlQXmlEntityResolver.o sipQtXmlQXmlDTDHandler.o sipQtXmlQXmlErrorHandler.o sipQtXmlQXmlContentHandler.o sipQtXmlQXmlLocator.o sipQtXmlQXmlSimpleReader.o sipQtXmlQXmlReader.o sipQtXmlQXmlParseException.o sipQtXmlQXmlInputSource.o sipQtXmlQXmlAttributes.o sipQtXmlQXmlNamespaceSupport.o sipQtXmlQDomProcessingInstruction.o sipQtXmlQDomEntityReference.o sipQtXmlQDomEntity.o sipQtXmlQDomNotation.o sipQtXmlQDomCDATASection.o sipQtXmlQDomComment.o sipQtXmlQDomText.o sipQtXmlQDomElement.o sipQtXmlQDomAttr.o sipQtXmlQDomCharacterData.o sipQtXmlQDomDocumentFragment.o sipQtXmlQDomNamedNodeMap.o sipQtXmlQDomDocument.o sipQtXmlQDomDocumentType.o sipQtXmlQDomNodeList.o sipQtXmlQDomNode.o sipQtXmlQDomImplementation.o
HFILES = sipAPIQtXml.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_XML_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtXml -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtXml.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtXml -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtXml; local: *; };' > QtXml.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtXml || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtXml
	cp -f ../sip/QtXml/qxmlstream.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXml/qxmlstream.sip
	cp -f ../sip/QtXml/QtXmlmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXml/QtXmlmod.sip
	cp -f ../sip/QtXml/qdom.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXml/qdom.sip
	cp -f ../sip/QtXml/qxml.sip $(DESTDIR)/usr/share/sip/PyQt4/QtXml/qxml.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtXmlcmodule.o
	-rm -f sipQtXmlQXmlDefaultHandler.o
	-rm -f sipQtXmlQXmlDeclHandler.o
	-rm -f sipQtXmlQXmlLexicalHandler.o
	-rm -f sipQtXmlQXmlEntityResolver.o
	-rm -f sipQtXmlQXmlDTDHandler.o
	-rm -f sipQtXmlQXmlErrorHandler.o
	-rm -f sipQtXmlQXmlContentHandler.o
	-rm -f sipQtXmlQXmlLocator.o
	-rm -f sipQtXmlQXmlSimpleReader.o
	-rm -f sipQtXmlQXmlReader.o
	-rm -f sipQtXmlQXmlParseException.o
	-rm -f sipQtXmlQXmlInputSource.o
	-rm -f sipQtXmlQXmlAttributes.o
	-rm -f sipQtXmlQXmlNamespaceSupport.o
	-rm -f sipQtXmlQDomProcessingInstruction.o
	-rm -f sipQtXmlQDomEntityReference.o
	-rm -f sipQtXmlQDomEntity.o
	-rm -f sipQtXmlQDomNotation.o
	-rm -f sipQtXmlQDomCDATASection.o
	-rm -f sipQtXmlQDomComment.o
	-rm -f sipQtXmlQDomText.o
	-rm -f sipQtXmlQDomElement.o
	-rm -f sipQtXmlQDomAttr.o
	-rm -f sipQtXmlQDomCharacterData.o
	-rm -f sipQtXmlQDomDocumentFragment.o
	-rm -f sipQtXmlQDomNamedNodeMap.o
	-rm -f sipQtXmlQDomDocument.o
	-rm -f sipQtXmlQDomDocumentType.o
	-rm -f sipQtXmlQDomNodeList.o
	-rm -f sipQtXmlQDomNode.o
	-rm -f sipQtXmlQDomImplementation.o
	-rm -f QtXml.exp
