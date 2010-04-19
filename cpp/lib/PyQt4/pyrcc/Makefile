TARGET = pyrcc4
OFILES = main.o rcc.o
HFILES = rcc.h

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_CORE_LIB -DQT_XML_LIB -I. -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include/QtXml -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -O2 -Wall -W -D_REENTRANT
LFLAGS = -Wl,-O1 -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib
LIBS = -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lQtXml -L/usr/local/Trolltech/Qt-4.5.3/lib -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)
	./$(TARGET) -py2 -o ../examples/activeqt/webbrowser/mainwindow_rc.py ../examples/activeqt/webbrowser/mainwindow.qrc
	./$(TARGET) -py2 -o ../examples/dialogs/configdialog/configdialog_rc.py ../examples/dialogs/configdialog/configdialog.qrc
	./$(TARGET) -py2 -o ../examples/dialogs/classwizard/classwizard_rc.py ../examples/dialogs/classwizard/classwizard.qrc
	./$(TARGET) -py2 -o ../examples/opengl/textures/textures_rc.py ../examples/opengl/textures/textures.qrc
	./$(TARGET) -py2 -o ../examples/draganddrop/fridgemagnets/fridgemagnets_rc.py ../examples/draganddrop/fridgemagnets/fridgemagnets.qrc
	./$(TARGET) -py2 -o ../examples/draganddrop/draggableicons/draggableicons_rc.py ../examples/draganddrop/draggableicons/draggableicons.qrc
	./$(TARGET) -py2 -o ../examples/draganddrop/puzzle/puzzle_rc.py ../examples/draganddrop/puzzle/puzzle.qrc
	./$(TARGET) -py2 -o ../examples/draganddrop/draggabletext/draggabletext_rc.py ../examples/draganddrop/draggabletext/draggabletext.qrc
	./$(TARGET) -py2 -o ../examples/network/ftp/ftp_rc.py ../examples/network/ftp/ftp.qrc
	./$(TARGET) -py2 -o ../examples/richtext/syntaxhighlighter/syntaxhighlighter_rc.py ../examples/richtext/syntaxhighlighter/syntaxhighlighter.qrc
	./$(TARGET) -py2 -o ../examples/graphicsview/padnavigator/padnavigator_rc.py ../examples/graphicsview/padnavigator/padnavigator.qrc
	./$(TARGET) -py2 -o ../examples/graphicsview/collidingmice/mice_rc.py ../examples/graphicsview/collidingmice/mice.qrc
	./$(TARGET) -py2 -o ../examples/graphicsview/diagramscene/diagramscene_rc.py ../examples/graphicsview/diagramscene/diagramscene.qrc
	./$(TARGET) -py2 -o ../examples/graphicsview/dragdroprobot/dragdroprobot_rc.py ../examples/graphicsview/dragdroprobot/dragdroprobot.qrc
	./$(TARGET) -py2 -o ../examples/mainwindows/sdi/sdi_rc.py ../examples/mainwindows/sdi/sdi.qrc
	./$(TARGET) -py2 -o ../examples/mainwindows/application/application_rc.py ../examples/mainwindows/application/application.qrc
	./$(TARGET) -py2 -o ../examples/mainwindows/dockwidgets/dockwidgets_rc.py ../examples/mainwindows/dockwidgets/dockwidgets.qrc
	./$(TARGET) -py2 -o ../examples/mainwindows/mdi/mdi_rc.py ../examples/mainwindows/mdi/mdi.qrc
	./$(TARGET) -py2 -o ../examples/tools/i18n/i18n_rc.py ../examples/tools/i18n/i18n.qrc
	./$(TARGET) -py2 -o ../examples/tools/qtdemo/qtdemo_rc.py ../examples/tools/qtdemo/qtdemo.qrc
	./$(TARGET) -py2 -o ../examples/widgets/tooltips/tooltips_rc.py ../examples/widgets/tooltips/tooltips.qrc
	./$(TARGET) -py2 -o ../examples/widgets/movie/movie_rc.py ../examples/widgets/movie/movie.qrc
	./$(TARGET) -py2 -o ../examples/demos/embeddeddialogs/embeddeddialogs_rc.py ../examples/demos/embeddeddialogs/embeddeddialogs.qrc
	./$(TARGET) -py2 -o ../examples/painting/svgviewer/svgviewer_rc.py ../examples/painting/svgviewer/svgviewer.qrc
	./$(TARGET) -py2 -o ../examples/painting/basicdrawing/basicdrawing_rc.py ../examples/painting/basicdrawing/basicdrawing.qrc
	./$(TARGET) -py2 -o ../examples/desktop/systray/systray_rc.py ../examples/desktop/systray/systray.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/chart/chart_rc.py ../examples/itemviews/chart/chart.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/sortingmodel/sortingmodel_rc.py ../examples/itemviews/sortingmodel/sortingmodel.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/pixelator/images_rc.py ../examples/itemviews/pixelator/images.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/pixelator/pixelator_rc.py ../examples/itemviews/pixelator/pixelator.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/puzzle/puzzle_rc.py ../examples/itemviews/puzzle/puzzle.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/editabletreemodel/editabletreemodel_rc.py ../examples/itemviews/editabletreemodel/editabletreemodel.qrc
	./$(TARGET) -py2 -o ../examples/itemviews/simpletreemodel/simpletreemodel_rc.py ../examples/itemviews/simpletreemodel/simpletreemodel.qrc

install: $(TARGET)
	@test -d $(DESTDIR)/usr/bin || mkdir -p $(DESTDIR)/usr/bin
	cp -f $(TARGET) $(DESTDIR)/usr/bin/$(TARGET)

clean:
	-rm -f $(TARGET)
	-rm -f main.o
	-rm -f rcc.o
