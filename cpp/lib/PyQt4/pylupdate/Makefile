TARGET = pylupdate4
OFILES = fetchtr.o merge.o numberh.o sametexth.o main.o metatranslator.o proparser.o translator.o simtexth.o moc_translator.o
HFILES = metatranslator.h proparser.h simtexth.h

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_CORE_LIB -DQT_GUI_LIB -DQT_XML_LIB -I. -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtXml -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -O2 -Wall -W -D_REENTRANT
LFLAGS = -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtXml -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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

moc_translator.cpp: translator.h
	$(MOC) -o moc_translator.cpp translator.h

$(TARGET): $(OFILES)
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/bin || mkdir -p $(DESTDIR)/usr/bin
	cp -f $(TARGET) $(DESTDIR)/usr/bin/$(TARGET)

clean:
	-rm -f $(TARGET)
	-rm -f fetchtr.o
	-rm -f merge.o
	-rm -f numberh.o
	-rm -f sametexth.o
	-rm -f main.o
	-rm -f metatranslator.o
	-rm -f proparser.o
	-rm -f translator.o
	-rm -f simtexth.o
	-rm -f moc_translator.o
	-rm -f moc_translator.cpp
