# For Debian packaging, set environment variable $DESTDIR to 'debian/tmp' and
# set alternative values for following variables

prefix = /usr
sysconfdir = /etc

binary:
	# NOP


install:
	echo prefix=$(prefix)
	echo sysconfdir=$(sysconfdir)
	echo DESTDIR=$(DESTDIR)
	mkdir -p $(DESTDIR)$(prefix)/bin
	sed -e 's,@SYSCONFDIR@,$(sysconfdir),g' <rsbu > \
		$(DESTDIR)$(prefix)/bin/rsbu
	chown 0:0 $(DESTDIR)$(prefix)/bin/rsbu
	chmod 755 $(DESTDIR)$(prefix)/bin/rsbu
	install -m 644 -D rsbu.conf \
		$(DESTDIR)$(sysconfdir)/rsbu.conf
	install -m 644 -D README.md \
		$(DESTDIR)$(prefix)/share/doc/rsbu/README.md
	install -m 644 -D .rsbu.conf \
		$(DESTDIR)$(prefix)/share/doc/rsbu/examples/.rsbu.conf

clean:
	: # do nothing

distclean: clean

uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/rsbu
	-rm -f $(DESTDIR)$(sysconfdir)/rsbu.conf
	-rm -rf $(DESTDIR)$(prefix)/share/doc/rsbu

.PHONY: install clean distclean uninstall

