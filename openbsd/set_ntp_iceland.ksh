#!/bin/ksh

set -eu

if [[ "$(id -u)" -ne 0 ]]; then
    print "Must be run as root"
    exit 1
fi

cat > /etc/ntpd.conf << 'EOF'
servers is.pool.ntp.org
servers europe.pool.ntp.org
servers time.cloudflare.com

sensor *

constraints from "https://www.google.com"
constraints from "https://www.cloudflare.com"
constraints from "https://www.wikipedia.org"
EOF

rcctl set ntpd flags -s
rcctl enable ntpd
rcctl restart ntpd

if ! grep -q "^block in proto udp to port 123" /etc/pf.conf; then
    print "# Block external NTP queries for security" >> /etc/pf.conf
    print "block in proto udp to port 123" >> /etc/pf.conf
    pfctl -f /etc/pf.conf
fi

print "Done"