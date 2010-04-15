TARGET = QtDesigner.so
OFILES = sipQtDesignercmodule.o sipQtDesignerQList0101QDesignerCustomWidgetInterface.o sipQtDesignerQPyDesignerCustomWidgetCollectionPlugin.o sipQtDesignerQPyDesignerPropertySheetExtension.o sipQtDesignerQPyDesignerTaskMenuExtension.o sipQtDesignerQPyDesignerMemberSheetExtension.o sipQtDesignerQPyDesignerCustomWidgetPlugin.o sipQtDesignerQPyDesignerContainerExtension.o sipQtDesignerQDesignerTaskMenuExtension.o sipQtDesignerQExtensionManager.o sipQtDesignerQDesignerPropertySheetExtension.o sipQtDesignerQDesignerMemberSheetExtension.o sipQtDesignerQFormBuilder.o sipQtDesignerQAbstractExtensionManager.o sipQtDesignerQExtensionFactory.o sipQtDesignerQAbstractExtensionFactory.o sipQtDesignerQDesignerCustomWidgetCollectionInterface.o sipQtDesignerQDesignerCustomWidgetInterface.o sipQtDesignerQDesignerContainerExtension.o sipQtDesignerQDesignerWidgetBoxInterface.o sipQtDesignerQDesignerPropertyEditorInterface.o sipQtDesignerQDesignerObjectInspectorInterface.o sipQtDesignerQDesignerFormWindowManagerInterface.o sipQtDesignerQDesignerFormWindowCursorInterface.o sipQtDesignerQDesignerFormWindowInterfaceFeature.o sipQtDesignerQDesignerFormWindowInterface.o sipQtDesignerQDesignerFormEditorInterface.o sipQtDesignerQAbstractFormBuilder.o sipQtDesignerQDesignerActionEditorInterface.o
HFILES = sipAPIQtDesigner.h 

CC = gcc
CXX = g++
LINK = g++
CPPFLAGS = -DNDEBUG -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I. -I/drd/users/barry.robison/blur/branches/concurrent_burn/cpp/lib/PyQt4/qpy/QtDesigner -I/usr/include/python2.5 -I/usr/local/Trolltech/Qt-4.5.3/mkspecs/default -I/usr/local/Trolltech/Qt-4.5.3/include/QtDesigner -I/usr/local/Trolltech/Qt-4.5.3/include/QtGui -I/usr/local/Trolltech/Qt-4.5.3/include/QtCore -I/usr/local/Trolltech/Qt-4.5.3/include -I/usr/X11R6/include
CFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
CXXFLAGS = -pipe -fPIC -O2 -Wall -W -D_REENTRANT
LFLAGS = -shared -Wl,-O1 -Wl,-rpath,/drd/users/barry.robison/blur/branches/concurrent_burn/cpp/lib/PyQt4/qpy/QtDesigner -Wl,-rpath,/usr/local/Trolltech/Qt-4.5.3/lib -Wl,--version-script=QtDesigner.exp
LIBS = -L/drd/users/barry.robison/blur/branches/concurrent_burn/cpp/lib/PyQt4/qpy/QtDesigner -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -lqpydesigner -lQtDesigner -lQtGui -L/usr/local/Trolltech/Qt-4.5.3/lib -L/usr/X11R6/lib64 -pthread -L/lib64 -lfreetype -lgobject-2.0 -lSM -lICE -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -pthread -lgthread-2.0 -lglib-2.0 -lrt -lpthread -lXrender -lfontconfig -lXext -lX11 -lm -ldl -lQtCore -L/usr/local/Trolltech/Qt-4.5.3/lib -lz -lm -pthread -L/lib64 -lgthread-2.0 -lglib-2.0 -lrt -lpthread -ldl -lXext -lX11 -lm -lpthread
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
	@echo '{ global: initQtDesigner; local: *; };' > QtDesigner.exp
	$(LINK) $(LFLAGS) -o $(TARGET) $(OFILES) $(LIBS)

install: $(TARGET)
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4 || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4
	cp -f $(TARGET) $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	strip $(DESTDIR)/usr/lib/python2.5/site-packages/PyQt4/$(TARGET)
	@test -d $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner || mkdir -p $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner
	cp -f ../sip/QtDesigner/taskmenu.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/taskmenu.sip
	cp -f ../sip/QtDesigner/abstractformeditor.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractformeditor.sip
	cp -f ../sip/QtDesigner/formbuilder.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/formbuilder.sip
	cp -f ../sip/QtDesigner/abstractformwindowmanager.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractformwindowmanager.sip
	cp -f ../sip/QtDesigner/qpydesignerpropertysheetextension.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignerpropertysheetextension.sip
	cp -f ../sip/QtDesigner/qextensionmanager.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qextensionmanager.sip
	cp -f ../sip/QtDesigner/qpydesignercontainerextension.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignercontainerextension.sip
	cp -f ../sip/QtDesigner/abstractformbuilder.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractformbuilder.sip
	cp -f ../sip/QtDesigner/qpydesignertaskmenuextension.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignertaskmenuextension.sip
	cp -f ../sip/QtDesigner/membersheet.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/membersheet.sip
	cp -f ../sip/QtDesigner/QtDesignermod.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/QtDesignermod.sip
	cp -f ../sip/QtDesigner/default_extensionfactory.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/default_extensionfactory.sip
	cp -f ../sip/QtDesigner/abstractactioneditor.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractactioneditor.sip
	cp -f ../sip/QtDesigner/qpydesignercustomwidgetplugin.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignercustomwidgetplugin.sip
	cp -f ../sip/QtDesigner/qpydesignermembersheetextension.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignermembersheetextension.sip
	cp -f ../sip/QtDesigner/extension.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/extension.sip
	cp -f ../sip/QtDesigner/abstractformwindowcursor.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractformwindowcursor.sip
	cp -f ../sip/QtDesigner/propertysheet.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/propertysheet.sip
	cp -f ../sip/QtDesigner/customwidget.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/customwidget.sip
	cp -f ../sip/QtDesigner/abstractpropertyeditor.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractpropertyeditor.sip
	cp -f ../sip/QtDesigner/abstractformwindow.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractformwindow.sip
	cp -f ../sip/QtDesigner/abstractwidgetbox.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractwidgetbox.sip
	cp -f ../sip/QtDesigner/abstractobjectinspector.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/abstractobjectinspector.sip
	cp -f ../sip/QtDesigner/container.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/container.sip
	cp -f ../sip/QtDesigner/qpydesignercustomwidgetcollectionplugin.sip $(DESTDIR)/usr/share/sip/PyQt4/QtDesigner/qpydesignercustomwidgetcollectionplugin.sip

clean:
	-rm -f $(TARGET)
	-rm -f sipQtDesignercmodule.o
	-rm -f sipQtDesignerQList0101QDesignerCustomWidgetInterface.o
	-rm -f sipQtDesignerQPyDesignerCustomWidgetCollectionPlugin.o
	-rm -f sipQtDesignerQPyDesignerPropertySheetExtension.o
	-rm -f sipQtDesignerQPyDesignerTaskMenuExtension.o
	-rm -f sipQtDesignerQPyDesignerMemberSheetExtension.o
	-rm -f sipQtDesignerQPyDesignerCustomWidgetPlugin.o
	-rm -f sipQtDesignerQPyDesignerContainerExtension.o
	-rm -f sipQtDesignerQDesignerTaskMenuExtension.o
	-rm -f sipQtDesignerQExtensionManager.o
	-rm -f sipQtDesignerQDesignerPropertySheetExtension.o
	-rm -f sipQtDesignerQDesignerMemberSheetExtension.o
	-rm -f sipQtDesignerQFormBuilder.o
	-rm -f sipQtDesignerQAbstractExtensionManager.o
	-rm -f sipQtDesignerQExtensionFactory.o
	-rm -f sipQtDesignerQAbstractExtensionFactory.o
	-rm -f sipQtDesignerQDesignerCustomWidgetCollectionInterface.o
	-rm -f sipQtDesignerQDesignerCustomWidgetInterface.o
	-rm -f sipQtDesignerQDesignerContainerExtension.o
	-rm -f sipQtDesignerQDesignerWidgetBoxInterface.o
	-rm -f sipQtDesignerQDesignerPropertyEditorInterface.o
	-rm -f sipQtDesignerQDesignerObjectInspectorInterface.o
	-rm -f sipQtDesignerQDesignerFormWindowManagerInterface.o
	-rm -f sipQtDesignerQDesignerFormWindowCursorInterface.o
	-rm -f sipQtDesignerQDesignerFormWindowInterfaceFeature.o
	-rm -f sipQtDesignerQDesignerFormWindowInterface.o
	-rm -f sipQtDesignerQDesignerFormEditorInterface.o
	-rm -f sipQtDesignerQAbstractFormBuilder.o
	-rm -f sipQtDesignerQDesignerActionEditorInterface.o
	-rm -f QtDesigner.exp
