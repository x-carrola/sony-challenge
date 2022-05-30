#!/bin/bash

if ([ -f /usr/bin/id ] && [ "$(/usr/bin/id -u)" -eq "0" ]) || [ "`whoami 2>/dev/null`" = "root" ]; then
    IAMROOT="1"
    MAXPATH_FIND_W="3"
else
    IAMROOT=""
    MAXPATH_FIND_W="7"
fi

C=$(printf '\033')
RED="${C}[1;31m"
SED_RED="${C}[1;31m&${C}[0m"
GREEN="${C}[1;32m"
SED_GREEN="${C}[1;32m&${C}[0m"
YELLOW="${C}[1;33m"
SED_YELLOW="${C}[1;33m&${C}[0m"
SED_RED_YELLOW="${C}[1;31;103m&${C}[0m"
BLUE="${C}[1;34m"
SED_BLUE="${C}[1;34m&${C}[0m"
ITALIC_BLUE="${C}[1;34m${C}[3m"
LIGHT_MAGENTA="${C}[1;95m"
SED_LIGHT_MAGENTA="${C}[1;95m&${C}[0m"
LIGHT_CYAN="${C}[1;96m"
SED_LIGHT_CYAN="${C}[1;96m&${C}[0m"
LG="${C}[1;37m" #LightGray
SED_LG="${C}[1;37m&${C}[0m"
DG="${C}[1;90m" #DarkGray
SED_DG="${C}[1;90m&${C}[0m"
NC="${C}[0m"
UNDERLINED="${C}[5m"
ITALIC="${C}[3m"

MyUID=$(id -u $(whoami))
if [ "$MyUID" ]; then myuid=$MyUID; elif [ $(id -u $(whoami) 2>/dev/null) ]; then myuid=$(id -u $(whoami) 2>/dev/null); elif [ "$(id 2>/dev/null | cut -d "=" -f 2 | cut -d "(" -f 1)" ]; then myuid=$(id 2>/dev/null | cut -d "=" -f 2 | cut -d "(" -f 1); fi
if [ $myuid -gt 2147483646 ]; then baduid="|$myuid"; fi
idB="euid|egid$baduid"
sudovB="[01].[012345678].[0-9]+|1.9.[01234]|1.9.5p1"

SEDOVERFLOW=true
for grp in $(groups $USER 2>/dev/null | cut -d ":" -f2); do
    wgroups="$wgroups -group $grp -or "
done
wgroups="$(echo $wgroups | sed -e 's/ -or$//')"
while $SEDOVERFLOW; do
    WF=$(find / -maxdepth $MAXPATH_FIND_W -type d ! -path "/proc/*" '(' '(' -user $USER ')' -or '(' -perm -o=w ')' -or  '(' -perm -g=w -and '(' $wgroups ')' ')' ')'  2>/dev/null | sort) #OpenBSD find command doesn't have "-writable" option
    Wfolders=$(printf "%s" "$WF" | tr '\n' '|')"|[a-zA-Z]+[a-zA-Z0-9]* +\*"
    Wfolder="$(printf "%s" "$WF" | grep "tmp\|shm\|home\|Users\|root\|etc\|var\|opt\|bin\|lib\|mnt\|private\|Applications" | head -n1)"
    printf "test\ntest\ntest\ntest"| sed -E "s,$Wfolders|\./|\.:|:\.,${SED_RED_YELLOW},g" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        SEDOVERFLOW=false
    else
        MAXPATH_FIND_W=$(($MAXPATH_FIND_W-1)) #If overflow of directories, check again with MAXPATH_FIND_W - 1
    fi
    if [ $MAXPATH_FIND_W -lt 1 ] ; then # prevent infinite loop
        SEDOVERFLOW=false
    fi
done

sh_usrs=$(cat /etc/passwd 2>/dev/null | grep -v "^root:" | grep -i "sh$" | cut -d ":" -f 1 | tr '\n' '|' | sed 's/|bin|/|bin[\\\s:]|^bin$|/' | sed 's/|sys|/|sys[\\\s:]|^sys$|/' | sed 's/|daemon|/|daemon[\\\s:]|^daemon$|/')"ImPoSSssSiBlEee" #Modified bin, sys and daemon so they are not colored everywhere
nosh_usrs=$(cat /etc/passwd 2>/dev/null | grep -i -v "sh$" | sort | cut -d ":" -f 1 | tr '\n' '|' | sed 's/|bin|/|bin[\\\s:]|^bin$|/')"ImPoSSssSiBlEee"
knw_usrs='_amavisd|_analyticsd|_appinstalld|_appleevents|_applepay|_appowner|_appserver|_appstore|_ard|_assetcache|_astris|_atsserver|_avbdeviced|_calendar|_captiveagent|_ces|_clamav|_cmiodalassistants|_coreaudiod|_coremediaiod|_coreml|_ctkd|_cvmsroot|_cvs|_cyrus|_datadetectors|_demod|_devdocs|_devicemgr|_diskimagesiod|_displaypolicyd|_distnote|_dovecot|_dovenull|_dpaudio|_driverkit|_eppc|_findmydevice|_fpsd|_ftp|_fud|_gamecontrollerd|_geod|_hidd|_iconservices|_installassistant|_installcoordinationd|_installer|_jabber|_kadmin_admin|_kadmin_changepw|_knowledgegraphd|_krb_anonymous|_krb_changepw|_krb_kadmin|_krb_kerberos|_krb_krbtgt|_krbfast|_krbtgt|_launchservicesd|_lda|_locationd|_logd|_lp|_mailman|_mbsetupuser|_mcxalr|_mdnsresponder|_mobileasset|_mysql|_nearbyd|_netbios|_netstatistics|_networkd|_nsurlsessiond|_nsurlstoraged|_oahd|_ondemand|_postfix|_postgres|_qtss|_reportmemoryexception|_rmd|_sandbox|_screensaver|_scsd|_securityagent|_softwareupdate|_spotlight|_sshd|_svn|_taskgated|_teamsserver|_timed|_timezone|_tokend|_trustd|_trustevaluationagent|_unknown|_update_sharing|_usbmuxd|_uucp|_warmd|_webauthserver|_windowserver|_www|_wwwproxy|_xserverdocs|daemon\W|^daemon$|message\+|syslog|www|www-data|mail|noboby|Debian\-\+|rtkit|systemd\+'
USER=$(whoami 2>/dev/null || echo "UserUnknown")
