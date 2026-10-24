PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
APPDIR ?= $(PREFIX)/lib/wired
DESTDIR ?=
SUDO ?= sudo
APT_GET ?= apt-get

.PHONY: install install-app install-tools uninstall

install: install-tools install-app

install-tools:
	@case "$$(uname -s)" in \
		Darwin) \
			command -v brew >/dev/null 2>&1 || { echo "Error: install Homebrew first: https://brew.sh" >&2; exit 1; }; \
			brew install whois nmap ffuf; \
			for tool in nslookup traceroute; do \
				command -v "$$tool" >/dev/null 2>&1 || { echo "Error: macOS system command $$tool is not available in PATH." >&2; exit 1; }; \
			done ;; \
		Linux) \
			command -v "$(APT_GET)" >/dev/null 2>&1 || { echo "Error: $(APT_GET) is required to install tools." >&2; exit 1; }; \
			$(SUDO) $(APT_GET) update && $(SUDO) $(APT_GET) install -y whois dnsutils traceroute nmap ffuf ;; \
		*) \
			echo "Error: automatic tool installation is supported on macOS (Homebrew) and Debian/Ubuntu (apt)." >&2; \
			exit 1 ;; \
	esac

install-app:
	install -d "$(DESTDIR)$(APPDIR)/bin" "$(DESTDIR)$(APPDIR)/lib" "$(DESTDIR)$(APPDIR)/res" "$(DESTDIR)$(BINDIR)"
	install -m 755 bin/wired "$(DESTDIR)$(APPDIR)/bin/wired"
	install -m 644 lib/dns.lib lib/fuzzing.lib lib/options.lib "$(DESTDIR)$(APPDIR)/lib/"
	install -m 644 res/subdomain.txt res/directory.txt "$(DESTDIR)$(APPDIR)/res/"
	printf '%s\n' '#!/bin/sh' 'exec "$(APPDIR)/bin/wired" "$$@"' > "$(DESTDIR)$(BINDIR)/wired"
	chmod 755 "$(DESTDIR)$(BINDIR)/wired"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/wired" \
		"$(DESTDIR)$(APPDIR)/bin/wired" \
		"$(DESTDIR)$(APPDIR)/lib/dns.lib" \
		"$(DESTDIR)$(APPDIR)/lib/fuzzing.lib" \
		"$(DESTDIR)$(APPDIR)/lib/options.lib" \
		"$(DESTDIR)$(APPDIR)/res/subdomain.txt" \
		"$(DESTDIR)$(APPDIR)/res/directory.txt"
	@for directory in \
		"$(DESTDIR)$(APPDIR)/bin" \
		"$(DESTDIR)$(APPDIR)/lib" \
		"$(DESTDIR)$(APPDIR)/res" \
		"$(DESTDIR)$(APPDIR)"; do \
		if [ -d "$$directory" ] && ! rmdir "$$directory" 2>/dev/null; then \
			echo "Leaving non-empty or inaccessible directory: $$directory" >&2; \
		fi; \
	done