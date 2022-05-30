#!/bin/bash

source $(dirname $0)/common.sh

# Current user info
echo "Current user info"
(id || (whoami && groups)) 2>/dev/null | sed -E "s,$groupsB,${SED_RED},g" | sed -E "s,$groupsVB,${SED_RED_YELLOW},g" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN},g" | sed "s,$USER,${SED_LIGHT_MAGENTA},g" | sed -E "s,$nosh_usrs,${SED_BLUE},g" | sed -E "s,$knw_usrs,${SED_GREEN},g" | sed "s,root,${SED_RED}," | sed -E "s,$knw_grps,${SED_GREEN},g" | sed -E "s,$idB,${SED_RED},g"
echo ""

# Superusers
echo "Superusers"
awk -F: '($3 == "0") {print}' /etc/passwd 2>/dev/null | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed -E "s,$nosh_usrs,${SED_BLUE}," | sed -E "s,$knw_usrs,${SED_GREEN}," | sed "s,$USER,${SED_RED_YELLOW}," | sed "s,root,${SED_RED},"
echo ""

# Users with console
echo "Users with console"
no_shells=$(grep -Ev "sh$" /etc/passwd 2>/dev/null | cut -d ':' -f 7 | sort | uniq)
unexpected_shells=""
printf "%s\n" "$no_shells" | while read f; do
if $f -c 'whoami' 2>/dev/null | grep -q "$USER"; then
    unexpected_shells="$f\n$unexpected_shells"
fi
done
grep "sh$" /etc/passwd 2>/dev/null | sort | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed "s,root,${SED_RED},"
if [ "$unexpected_shells" ]; then
printf "%s" "These unexpected binaries are acting like shells:\n$unexpected_shells" | sed -E "s,/.*,${SED_RED},g"
echo "Unexpected users with shells:"
printf "%s\n" "$unexpected_shells" | while read f; do
    if [ "$f" ]; then
    grep -E "${f}$" /etc/passwd | sed -E "s,/.*,${SED_RED},g"
    fi
done
fi
echo ""

# All users & groups
echo "All users & groups"
cut -d":" -f1 /etc/passwd 2>/dev/null| while read i; do id $i;done 2>/dev/null | sort | sed -E "s,$groupsB,${SED_RED},g" | sed -E "s,$groupsVB,${SED_RED},g" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN},g" | sed "s,$USER,${SED_LIGHT_MAGENTA},g" | sed -E "s,$nosh_usrs,${SED_BLUE},g" | sed -E "s,$knw_usrs,${SED_GREEN},g" | sed "s,root,${SED_RED}," | sed -E "s,$knw_grps,${SED_GREEN},g"
echo ""

# Current login
echo "Current login"
(w || who || finger || users) 2>/dev/null | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed -E "s,$nosh_usrs,${SED_BLUE}," | sed -E "s,$knw_usrs,${SED_GREEN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed "s,root,${SED_RED},"
echo ""

# Last logins
echo "Last logons"
(last -Faiw || last) 2>/dev/null | tail | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN}," | sed -E "s,$nosh_usrs,${SED_RED}," | sed -E "s,$knw_usrs,${SED_GREEN}," | sed "s,$USER,${SED_LIGHT_MAGENTA}," | sed "s,root,${SED_RED},"
echo ""
