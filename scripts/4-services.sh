#!/bin/bash

source $(dirname $0)/common.sh

# Check write permissions in systemd PATH
echo "Check write permissions in systemd PATH"
systemctl show-environment 2>/dev/null | grep "PATH" | sed -E "s,$Wfolders\|\./\|\.:\|:\.,${SED_RED_YELLOW},g"
WRITABLESYSTEMDPATH=$(systemctl show-environment 2>/dev/null | grep "PATH" | grep -E "$Wfolders")
if [ ! "$WRITABLESYSTEMDPATH" ]; then 
    echo "You can't write on systemd PATH" | sed -E "s,.*,${SED_GREEN},";
fi
echo ""

# Analysing .service files
echo "Analysing .service files"
printf "%s\n" "$PSTORAGE_SYSTEMD" | while read s; do
  if [ ! -O "$s" ]; then #Remove services that belongs to the current user
    if ! [ "$IAMROOT" ] && [ -w "$s" ] && [ -f "$s" ]; then
      echo "$s"
    fi
    servicebinpaths=$(grep -Eo '^Exec.*?=[!@+-]*[a-zA-Z0-9_/\-]+' "$s" 2>/dev/null | cut -d '=' -f2 | sed 's,^[@\+!-]*,,') #Get invoked paths
    printf "%s\n" "$servicebinpaths" | while read sp; do
      if [ -w "$sp" ]; then
        echo "$s is calling this writable executable: $sp"
      fi
    done
    relpath1=$(grep -E '^Exec.*=(?:[^/]|-[^/]|\+[^/]|![^/]|!![^/]|)[^/@\+!-].*' "$s" 2>/dev/null | grep -Iv "=/")
    relpath2=$(grep -E '^Exec.*=.*/bin/[a-zA-Z0-9_]*sh ' "$s" 2>/dev/null | grep -Ev "/[a-zA-Z0-9_]+/")
    if [ "$relpath1" ] || [ "$relpath2" ]; then
      if [ "$WRITABLESYSTEMDPATH" ]; then
        echo "$s is executing some relative path" | sed -E "s,.*,${SED_RED},";
      else
        echo "$s is executing some relative path"
      fi
    fi
  fi
done
