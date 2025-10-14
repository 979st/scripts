#!/bin/ksh

set -eu

if [[ "$(id -u)" -ne 0 ]]; then
    print "Must be run as root"
    exit 1
fi

cat > /etc/ntpd.conf << 'EOF'
server de.pool.ntp.org
server at.pool.ntp.org
server nl.pool.ntp.org
server time.apple.com
server time.google.com
server time.cloudflare.com

sensor *

constraints from "https://www.google.com"
constraints from "https://www.cloudflare.com"
constraints from "https://www.wikipedia.org"
EOF

rcctl enable ntpd
rcctl restart ntpd

print "Done"