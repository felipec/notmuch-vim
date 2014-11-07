prefix = $(HOME)/.vim

INSTALL = install -v -D -m644
D = $(DESTDIR)

all:
	@echo "Nothing to build"

install:
	@$(foreach file,$(wildcard plugin/*), \
		$(INSTALL) $(CURDIR)/$(file) $(D)$(prefix)/$(file);)
	@$(foreach file,$(wildcard doc/*), \
		$(INSTALL) $(CURDIR)/$(file) $(D)$(prefix)/$(file);)
	@$(foreach file,$(wildcard syntax/*), \
		$(INSTALL) $(CURDIR)/$(file) $(D)$(prefix)/$(file);)

build:
	@cd $(notmuch)/bindings/ruby; ruby extconf.rb; make
	@cp $(notmuch)/bindings/ruby/notmuch.so .
	@echo -e "\nCopy notmuch.so to an appropriate location (e.g. /usr/lib/ruby/site_ruby/2.0.0/x86_64-linux)"

.PHONY: all install
