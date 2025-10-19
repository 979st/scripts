#!/bin/bash

set -eu

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Must be run as root"
    exit 1
fi

cat > /etc/systemd/timesyncd.conf << 'EOF'
[Time]
NTP=de.pool.ntp.org at.pool.ntp.org nl.pool.ntp.org time.apple.com time.google.com time.cloudflare.com
EOF

timedatectl set-ntp true
systemctl restart systemd-timesyncd

echo "Done"