
all:
	@(cd sipStone; $(MAKE))

install:
	@(cd sipStone; $(MAKE) install)
	@test -d $(DESTDIR)/usr/share/sip/blur || mkdir -p $(DESTDIR)/usr/share/sip/blur
	cp -f sip/pgconnection.sip $(DESTDIR)/usr/share/sip/blur/pgconnection.sip
	cp -f sip/table.sip $(DESTDIR)/usr/share/sip/blur/table.sip
	cp -f sip/indexschema.sip $(DESTDIR)/usr/share/sip/blur/indexschema.sip
	cp -f sip/path.sip $(DESTDIR)/usr/share/sip/blur/path.sip
	cp -f sip/schema.sip $(DESTDIR)/usr/share/sip/blur/schema.sip
	cp -f sip/iniconfig.sip $(DESTDIR)/usr/share/sip/blur/iniconfig.sip
	cp -f sip/index.sip $(DESTDIR)/usr/share/sip/blur/index.sip
	cp -f sip/recordlist.sip $(DESTDIR)/usr/share/sip/blur/recordlist.sip
	cp -f sip/freezercore.sip $(DESTDIR)/usr/share/sip/blur/freezercore.sip
	cp -f sip/updatemanager.sip $(DESTDIR)/usr/share/sip/blur/updatemanager.sip
	cp -f sip/process.sip $(DESTDIR)/usr/share/sip/blur/process.sip
	cp -f sip/recordproxy.sip $(DESTDIR)/usr/share/sip/blur/recordproxy.sip
	cp -f sip/pyembed.sip $(DESTDIR)/usr/share/sip/blur/pyembed.sip
	cp -f sip/multilog.sip $(DESTDIR)/usr/share/sip/blur/multilog.sip
	cp -f sip/connection.sip $(DESTDIR)/usr/share/sip/blur/connection.sip
	cp -f sip/undomanager.sip $(DESTDIR)/usr/share/sip/blur/undomanager.sip
	cp -f sip/database.sip $(DESTDIR)/usr/share/sip/blur/database.sip
	cp -f sip/sqlerrorhandler.sip $(DESTDIR)/usr/share/sip/blur/sqlerrorhandler.sip
	cp -f sip/tableschema.sip $(DESTDIR)/usr/share/sip/blur/tableschema.sip
	cp -f sip/blurqt.sip $(DESTDIR)/usr/share/sip/blur/blurqt.sip
	cp -f sip/dateutil.sip $(DESTDIR)/usr/share/sip/blur/dateutil.sip
	cp -f sip/record.sip $(DESTDIR)/usr/share/sip/blur/record.sip
	cp -f sip/field.sip $(DESTDIR)/usr/share/sip/blur/field.sip
	cp -f sip/recordimp.sip $(DESTDIR)/usr/share/sip/blur/recordimp.sip
	cp -f sip/interval.sip $(DESTDIR)/usr/share/sip/blur/interval.sip
	cp -f sip/recordxml.sip $(DESTDIR)/usr/share/sip/blur/recordxml.sip
	@test -d $(DESTDIR)/usr/lib/python2.5/site-packages || mkdir -p $(DESTDIR)/usr/lib/python2.5/site-packages
	cp -f stoneconfig.py $(DESTDIR)/usr/lib/python2.5/site-packages/stoneconfig.py

clean:
	@(cd sipStone; $(MAKE) clean)
