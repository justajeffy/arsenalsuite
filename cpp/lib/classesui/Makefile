
all:
	@(cd sipClassesui; $(MAKE))

install:
	@(cd sipClassesui; $(MAKE) install)
	@test -d $(DESTDIR)/usr/share/sip/blur || mkdir -p $(DESTDIR)/usr/share/sip/blur
	cp -f sip/projectcombo.sip $(DESTDIR)/usr/share/sip/blur/projectcombo.sip
	cp -f sip/dialogfactory.sip $(DESTDIR)/usr/share/sip/blur/dialogfactory.sip
	cp -f sip/elementui.sip $(DESTDIR)/usr/share/sip/blur/elementui.sip
	cp -f sip/elementmodel.sip $(DESTDIR)/usr/share/sip/blur/elementmodel.sip
	cp -f sip/assettemplatecombo.sip $(DESTDIR)/usr/share/sip/blur/assettemplatecombo.sip
	cp -f sip/classesui.sip $(DESTDIR)/usr/share/sip/blur/classesui.sip
	cp -f sip/shotdialog.sip $(DESTDIR)/usr/share/sip/blur/shotdialog.sip
	cp -f sip/hostselector.sip $(DESTDIR)/usr/share/sip/blur/hostselector.sip
	cp -f sip/assetdialog.sip $(DESTDIR)/usr/share/sip/blur/assetdialog.sip
	cp -f sip/datechooser.sip $(DESTDIR)/usr/share/sip/blur/datechooser.sip
	cp -f sip/thumbnailui.sip $(DESTDIR)/usr/share/sip/blur/thumbnailui.sip

clean:
	@(cd sipClassesui; $(MAKE) clean)
