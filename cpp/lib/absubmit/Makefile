
all:
	@(cd sipAbsubmit; $(MAKE))

install:
	@(cd sipAbsubmit; $(MAKE) install)
	@test -d $(DESTDIR)/usr/share/sip/blur || mkdir -p $(DESTDIR)/usr/share/sip/blur
	cp -f sip/submitter.sip $(DESTDIR)/usr/share/sip/blur/submitter.sip
	cp -f sip/absubmit.sip $(DESTDIR)/usr/share/sip/blur/absubmit.sip

clean:
	@(cd sipAbsubmit; $(MAKE) clean)
