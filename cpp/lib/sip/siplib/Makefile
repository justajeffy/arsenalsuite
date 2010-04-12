TARGET = libsip.a
OFILES = siplib.o apiversions.o descriptors.o qtlib.o threads.o objmap.o bool.o
HFILES = sip.h sipint.h 

AR = ar cqs
CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DSIP_STATIC_MODULE -I. -I/usr/include/python2.5
CFLAGS = -m64 -pipe -O2 -w
CXXFLAGS = -m64 -pipe -O2 -w
LFLAGS = -m64
LIBS = 
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
	-rm -f $(TARGET)
	$(AR) $(TARGET) $(OFILES)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/$(TARGET)
	@test -d $(DESTDIR)/usr/include/python2.5 || mkdir -p $(DESTDIR)/usr/include/python2.5
	cp -f sip.h $(DESTDIR)/usr/include/python2.5/sip.h

clean:
	-rm -f $(TARGET)
	-rm -f siplib.o
	-rm -f apiversions.o
	-rm -f descriptors.o
	-rm -f qtlib.o
	-rm -f threads.o
	-rm -f objmap.o
	-rm -f bool.o
