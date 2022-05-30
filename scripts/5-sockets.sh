#!/bin/bash

source $(dirname $0)/common.sh

if ! [ "$IAMROOT" ]; then
    # Writable .socket files
    echo "Analyzing .socket files"
    printf "%s\n" "$PSTORAGE_SOCKET" | while read s; do
        if ! [ "$IAMROOT" ] && [ -w "$s" ] && [ -f "$s" ]; then
            echo "Writable .socket file: $s" | sed "s,/.*,${SED_RED},g"
        fi
        socketsbinpaths=$(grep -Eo '^(Exec).*?=[!@+-]*/[a-zA-Z0-9_/\-]+' "$s" 2>/dev/null | cut -d '=' -f2 | sed 's,^[@\+!-]*,,')
        printf "%s\n" "$socketsbinpaths" | while read sb; do
            if [ -w "$sb" ]; then
                echo "$s is calling this writable executable: $sb" | sed "s,writable.*,${SED_RED},g"
            fi
        done
        socketslistpaths=$(grep -Eo '^(Listen).*?=[!@+-]*/[a-zA-Z0-9_/\-]+' "$s" 2>/dev/null | cut -d '=' -f2 | sed 's,^[@\+!-]*,,')
        printf "%s\n" "$socketslistpaths" | while read sl; do
            if [ -w "$sl" ]; then
                echo "$s is calling this writable listener: $sl" | sed "s,writable.*,${SED_RED},g";
            fi
        done
    done
    echo ""

    # Searching socket files
    echo "Searching socket files"
    unix_scks_list2=$(find / -type s 2>/dev/null)
    (printf "%s\n" "$unix_scks_list" && printf "%s\n" "$unix_scks_list2") | sort | uniq | while read l; do
        perms=""
        if [ -r "$l" ]; then
        perms="Read "
        fi
        if [ -w "$l" ];then
        perms="${perms}Write"
        fi
        if ! [ "$perms" ]; then echo "$l" | sed -E "s,$l,${SED_GREEN},g";
        else 
        echo "$l" | sed -E "s,$l,${SED_RED},g"
        echo "  └─(${RED}${perms}${NC})"
        # Try to contact the socket
        socketcurl=$(curl --max-time 2 --unix-socket "$s" http:/index 2>/dev/null)
        if [ $? -eq 0 ]; then
            owner=$(ls -l "$s" | cut -d ' ' -f 3)
            echo "Socket $s owned by $owner uses HTTP. Response to /index: (limt 30)" | sed -E "s,$groupsB,${SED_RED},g" | sed -E "s,$groupsVB,${SED_RED},g" | sed -E "s,$sh_usrs,${SED_LIGHT_CYAN},g" | sed "s,$USER,${SED_LIGHT_MAGENTA},g" | sed -E "s,$nosh_usrs,${SED_BLUE},g" | sed -E "s,$knw_usrs,${SED_GREEN},g" | sed "s,root,${SED_RED}," | sed -E "s,$knw_grps,${SED_GREEN},g" | sed -E "s,$idB,${SED_RED},g"
            echo "$socketcurl" | head -n 30
        fi
        fi
    done
    echo ""
fi
