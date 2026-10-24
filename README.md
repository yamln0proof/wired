# Wired
A tool for reconnaissance and information gathering

## Subdomain fuzzing

Source the fuzzing library and pass a domain you are authorized to assess. The
function uses `res/subdomain.txt`, limits the scan to 20 requests per second,
and writes ffuf's readable report to `example.com_subdomains.txt` by default.
An optional second argument sets the output file.

```bash
source lib/fuzzing.lib
```

The `ffuf` executable must be installed and available in `PATH`.

## WHOIS lookup

Source the DNS library and run a WHOIS lookup for a domain. Results are saved
to `<domain>_whois.txt` by default; an optional second argument sets the output
file.

```bash
source lib/dns.lib
```

The `whois` command must be installed and available in `PATH`.

## DNS lookup

Source the DNS library and query a domain with `nslookup`. Results are saved
to `<domain>_nslookup.txt` by default; an optional second argument sets the
output file.

```bash
source lib/dns.lib

```

The `nslookup` command must be installed and available in `PATH`.

## Traceroute

Source the DNS library and trace the network route to a domain. Results are
saved to `<domain>_netroute.txt` by default; an optional second argument sets
the output file.

```bash
source lib/dns.lib
```

The `traceroute` command must be installed and available in `PATH`.

## Running Wired

Run Wired with a domain to create `reports/<domain>/` and save the WHOIS,
nslookup, traceroute, and Nmap outputs there. Wired asks for authorization
confirmation before each scan. A scan runs only when you confirm; without an
interactive terminal, all scans are skipped. The corresponding system
commands must be installed and available in `PATH`.

```bash
bin/wired example.com
```

Use `wired -h` or `wired --help` to display command usage.

On confirmation, Nmap scans for common TCP ports using its polite
timing profile and saves a normal-format report in the same folder.

## Installation

Run these commands from the repository root. `make install` installs Wired and
its required command-line tools:

```bash
make install
```

### macOS

Install [Homebrew](https://brew.sh) first, then run:

```bash
make install
```

The Makefile installs WHOIS, Nmap, and ffuf with Homebrew. `nslookup` and
`traceroute` are expected to be available as system commands. If `wired`
isn't found after installation, add its default bin directory to your shell
path (for zsh):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Debian or Ubuntu

Run:

```bash
make install
```

The Makefile installs WHOIS, DNS utilities (`nslookup`), traceroute, Nmap, and
ffuf using `apt-get` and `sudo`. The app itself installs under `$HOME/.local`,
without requiring root privileges.

### Install app or tools separately

```bash
make install-app
make install-tools
```

`make install-app` installs only Wired; `make install-tools` installs only its
external tools. The default app command is `$HOME/.local/bin/wired`. Check
that required commands are available with:

```bash
command -v whois nslookup traceroute nmap ffuf
```

Uninstall Wired (this does not remove the external tools):

```bash
make uninstall
```

Override `PREFIX` to install under a different prefix, or set `DESTDIR` when
running `make install-app` to stage the installation in another directory.
Use the same `PREFIX` and `DESTDIR` values with `make uninstall`.
After installation, run Wired with a domain:

```bash
wired example.com
```
