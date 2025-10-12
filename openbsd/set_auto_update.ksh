#!/bin/ksh

set -eu

if [[ "$(id -u)" -ne 0 ]]; then
    print "Must be run as root"
    exit 1
fi

cat > /usr/local/bin/auto_update.ksh << 'EOF'
#!/bin/ksh

LOG_FILE="/var/log/auto_update.log"

print "auto_update.ksh started $(date)" >> $LOG_FILE

syspatch >> $LOG_FILE 2>&1
pkg_add -u >> $LOG_FILE 2>&1
fw_update >> $LOG_FILE 2>&1

print "auto_update.ksh finished $(date)" >> $LOG_FILE
reboot
EOF

chmod +x /usr/local/bin/auto_update.ksh

touch /var/log/auto_update.log
chmod 644 /var/log/auto_update.log

if ! crontab -l | grep -q "auto_update.ksh"; then
    (crontab -l; print "0 6 * * * /usr/local/bin/auto_update.ksh") | crontab -
fi

print "Done"