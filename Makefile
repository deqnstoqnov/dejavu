NAME=dejavu
VERSION=1.0
DIST=dist

.PHONY: package

package: compile
	fpm -s dir -t deb -n dejavu -v 1.0 -a all --prefix /usr/lib/dejavu --after-install after-install.sh --after-remove after-remove.sh -C $(DIST) .

$(DIST):
	mkdir $(DIST)

compile: $(DIST)
	cp Confluence.pm  Database.pm  dejavu.cfg  dejavu.pl  dejavu.sql  install.sh  Makefile  README.md $(DIST)

clean: 
	rm -f *.deb
	rm -rf $(DIST)

