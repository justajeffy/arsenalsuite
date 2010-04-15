
all:
	@(cd sipStonegui; $(MAKE))

install:
	@(cd sipStonegui; $(MAKE) install)
	@test -d $(DESTDIR)/usr/share/sip/blur || mkdir -p $(DESTDIR)/usr/share/sip/blur
	cp -f sip/configdbdialog.sip $(DESTDIR)/usr/share/sip/blur/configdbdialog.sip
	cp -f sip/fieldcheckbox.sip $(DESTDIR)/usr/share/sip/blur/fieldcheckbox.sip
	cp -f sip/fieldlineedit.sip $(DESTDIR)/usr/share/sip/blur/fieldlineedit.sip
	cp -f sip/fieldspinbox.sip $(DESTDIR)/usr/share/sip/blur/fieldspinbox.sip
	cp -f sip/fieldtextedit.sip $(DESTDIR)/usr/share/sip/blur/fieldtextedit.sip
	cp -f sip/lostconnectiondialog.sip $(DESTDIR)/usr/share/sip/blur/lostconnectiondialog.sip
	cp -f sip/modeliter.sip $(DESTDIR)/usr/share/sip/blur/modeliter.sip
	cp -f sip/qvariantcmp.sip $(DESTDIR)/usr/share/sip/blur/qvariantcmp.sip
	cp -f sip/recordcombo.sip $(DESTDIR)/usr/share/sip/blur/recordcombo.sip
	cp -f sip/recorddelegate.sip $(DESTDIR)/usr/share/sip/blur/recorddelegate.sip
	cp -f sip/recordlistmodel.sip $(DESTDIR)/usr/share/sip/blur/recordlistmodel.sip
	cp -f sip/recordlistview.sip $(DESTDIR)/usr/share/sip/blur/recordlistview.sip
	cp -f sip/recordsupermodel.sip $(DESTDIR)/usr/share/sip/blur/recordsupermodel.sip
	cp -f sip/recordtreeview.sip $(DESTDIR)/usr/share/sip/blur/recordtreeview.sip
	cp -f sip/stonegui.sip $(DESTDIR)/usr/share/sip/blur/stonegui.sip
	cp -f sip/supermodel.sip $(DESTDIR)/usr/share/sip/blur/supermodel.sip

clean:
	@(cd sipStonegui; $(MAKE) clean)
