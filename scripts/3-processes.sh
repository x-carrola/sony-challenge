#!/bin/bash

source $(dirname $0)/common.sh

# Binary processes permissions
if [ "$(command -v ps auxwww 2>/dev/null)" ] ; then
    echo "Processes that are non 'root root' and do not belong to current user"
    binW="IniTialiZZinnggg"
    ps auxwww 2>/dev/null | awk '{print $11}' | xargs ls -la 2>/dev/null |awk '!x[$0]++' 2>/dev/null | grep -v " root root " | grep -v " $USER " | sed -E "s,$Wfolders,${SED_RED_YELLOW},g" | sed -E "s,$binW,${SED_RED_YELLOW},g" | sed -E "s,$sh_usrs,${SED_RED}," | sed -E "s,$nosh_usrs,${SED_BLUE}," | sed -E "s,$knw_usrs,${SED_GREEN}," | sed "s,$USER,${SED_RED}," | sed "s,root,${SED_GREEN},"
    echo ""
fi

# Files opened by processes belonging to other users
if ! [ "$IAMROOT" ]; then
    echo "Files opened by processes belonging to other users"
    lsof 2>/dev/null | grep -v "$USER" | grep -iv "permission denied" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed -E "s,$nosh_usrs,${SED_BLUE}," | sed "s,root,${SED_RED},"
    echo ""
fi

# Check scheduled CRON jobs
if [ "$(command -v crontab 2>/dev/null)" ] ; then
    echo "Scheduled CRON jobs"
    cronjobsG=".placeholder|0anacron|0hourly|110.clean-tmps|130.clean-msgs|140.clean-rwho|199.clean-fax|199.rotate-fax|200.accounting|310.accounting|400.status-disks|420.status-network|430.status-rwho|999.local|anacron|apache2|apport|apt|aptitude|apt-compat|bsdmainutils|certwatch|cracklib-runtime|debtags|dpkg|e2scrub_all|fake-hwclock|fstrim|john|locate|logrotate|man-db.cron|man-db|mdadm|mlocate|ntp|passwd|php|popularity-contest|raid-check|rwhod|samba|standard|sysstat|ubuntu-advantage-tools|update-notifier-common|upstart|"
    cronjobsB="centreon"
    crontab -l 2>/dev/null | tr -d "\r" | sed -E "s,$Wfolders,${SED_RED_YELLOW},g" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed -E "s,$nosh_usrs,${SED_BLUE}," | sed "s,root,${SED_RED},"
    ls -alR /etc/cron* /var/spool/cron/crontabs /var/spool/anacron 2>/dev/null | sed -E "s,$cronjobsG,${SED_GREEN},g" | sed "s,$cronjobsB,${SED_RED},g"
    cat /etc/cron* /etc/at* /etc/anacrontab /var/spool/cron/crontabs/* /etc/incron.d/* /var/spool/incron/* 2>/dev/null | tr -d "\r" | grep -v "^#" | sed -E "s,$Wfolders,${SED_RED_YELLOW},g" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed -E "s,$nosh_usrs,${SED_BLUE},"  | sed "s,root,${SED_RED},"
    echo ""
fi
