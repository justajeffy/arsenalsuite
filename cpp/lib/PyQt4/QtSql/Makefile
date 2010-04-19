TARGET = QtSql.so
OFILES = sipQtSqlcmodule.o sipQtSqlQVector0100QVariant.o sipQtSqlQSqlResult.o sipQtSqlQSqlRelationalTableModel.o sipQtSqlQSqlTableModel.o sipQtSqlQSqlRelation.o sipQtSqlQSqlRelationalDelegate.o sipQtSqlQSqlQueryModel.o sipQtSqlQSqlQuery.o sipQtSqlQSqlIndex.o sipQtSqlQSqlRecord.o sipQtSqlQSqlField.o sipQtSqlQSqlError.o sipQtSqlQSqlDriver.o sipQtSqlQSqlDatabase.o sipQtSqlQSqlDriverCreatorBase.o sipQtSqlQSqlParamType.o sipQtSqlQSql.o
HFILES = sipAPIQtSql.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_SQL_LIB -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtSql -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtSql.exp
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtSql -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/lib64 -lpq -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtSql; local: *; };' > QtSql.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtSql || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtSql
	cp -f ../sip/QtSql/qsqldatabase.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqldatabase.sip
	cp -f ../sip/QtSql/qsqlquery.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlquery.sip
	cp -f ../sip/QtSql/qsqlrelationaldelegate.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlrelationaldelegate.sip
	cp -f ../sip/QtSql/qsqlquerymodel.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlquerymodel.sip
	cp -f ../sip/QtSql/qsqlindex.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlindex.sip
	cp -f ../sip/QtSql/qsqltablemodel.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqltablemodel.sip
	cp -f ../sip/QtSql/qsqlerror.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlerror.sip
	cp -f ../sip/QtSql/qsqldriver.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqldriver.sip
	cp -f ../sip/QtSql/qsqlrecord.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlrecord.sip
	cp -f ../sip/QtSql/qsqlresult.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlresult.sip
	cp -f ../sip/QtSql/qsql.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsql.sip
	cp -f ../sip/QtSql/QtSqlmod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/QtSqlmod.sip
	cp -f ../sip/QtSql/qsqlfield.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlfield.sip
	cp -f ../sip/QtSql/qsqlrelationaltablemodel.sip $(DESTDIR)/usr/share/sip/PyQt4/QtSql/qsqlrelationaltablemodel.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtSqlcmodule.o
	-rm -f sipQtSqlQVector0100QVariant.o
	-rm -f sipQtSqlQSqlResult.o
	-rm -f sipQtSqlQSqlRelationalTableModel.o
	-rm -f sipQtSqlQSqlTableModel.o
	-rm -f sipQtSqlQSqlRelation.o
	-rm -f sipQtSqlQSqlRelationalDelegate.o
	-rm -f sipQtSqlQSqlQueryModel.o
	-rm -f sipQtSqlQSqlQuery.o
	-rm -f sipQtSqlQSqlIndex.o
	-rm -f sipQtSqlQSqlRecord.o
	-rm -f sipQtSqlQSqlField.o
	-rm -f sipQtSqlQSqlError.o
	-rm -f sipQtSqlQSqlDriver.o
	-rm -f sipQtSqlQSqlDatabase.o
	-rm -f sipQtSqlQSqlDriverCreatorBase.o
	-rm -f sipQtSqlQSqlParamType.o
	-rm -f sipQtSqlQSql.o
	-rm -f QtSql.exp
