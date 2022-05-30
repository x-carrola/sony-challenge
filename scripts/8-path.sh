#!/bin/bash

source $(dirname $0)/common.sh

# Writable folders in PATH
echo "Writable folders in PATH"
for dir in ${PATH//:/ }; do
    [ -L "$dir" ] && printf "%b" "symlink, "
    if [ ! -d "$dir" ]; then
        printf "%b" "missing\t\t"
          (( exit_code++ ))
    elif [ "$(ls -lLd $dir | grep '^d.......w. ')" ]; then
          printf "%b" "world writable\t"
          (( exit_code++ ))
    else
          printf "%b" "ok\t\t"
    fi
    printf "%b" "$dir\n"
done
echo ""

# Searching SUID binaries
echo "Searching SUID binaries"
suids_files=$(find / -perm -4000 -type f ! -path "/dev/*" 2>/dev/null)
for s in $suids_files; do
  s=$(ls -lahtr "$s")
  #If starts like "total 332K" then no SUID bin was found and xargs just executed "ls" in the current folder
  if echo "$s" | grep -qE "^total"; then break; fi

  sname="$(echo $s | awk '{print $9}')"
  if [ "$sname" = "."  ] || [ "$sname" = ".."  ]; then
    true #Don't do nothing
  elif ! [ "$IAMROOT" ] && [ -O "$sname" ]; then
    echo "You own the SUID file: $sname" | sed -E "s,.*,${SED_RED},"
  elif ! [ "$IAMROOT" ] && [ -w "$sname" ]; then #If write permision, win found (no check exploits)
    echo "You can write SUID file: $sname" | sed -E "s,.*,${SED_RED_YELLOW},"
  fi
done;
echo ""

# Searching SGID binaries
echo "Searching SGID binaries"
sgids_files=$(find / -perm -2000 -type f ! -path "/dev/*" 2>/dev/null)
for s in $sgids_files; do
  s=$(ls -lahtr "$s")
  #If starts like "total 332K" then no SUID bin was found and xargs just executed "ls" in the current folder
  if echo "$s" | grep -qE "^total";then break; fi

  sname="$(echo $s | awk '{print $9}')"
  if [ "$sname" = "."  ] || [ "$sname" = ".."  ]; then
    true #Don't do nothing
  elif ! [ "$IAMROOT" ] && [ -O "$sname" ]; then
    echo "You own the SGID file: $sname" | sed -E "s,.*,${SED_RED},"
  elif ! [ "$IAMROOT" ] && [ -w "$sname" ]; then #If write permision, win found (no check exploits)
    echo "You can write SGID file: $sname" | sed -E "s,.*,${SED_RED_YELLOW},"
  fi
done;
echo ""

# .sh files in PATH
echo ".sh files in path"
echo $PATH | tr ":" "\n" | while read d; do
  for f in $(find "$d" -name "*.sh" 2>/dev/null); do
    if ! [ "$IAMROOT" ] && [ -O "$f" ]; then
      echo "You own the script: $f" | sed -E "s,.*,${SED_RED},"
    elif ! [ "$IAMROOT" ] && [ -w "$f" ]; then #If write permision, win found (no check exploits)
      echo "You can write script: $f" | sed -E "s,.*,${SED_RED_YELLOW},"
    else
      echo $f | sed -E "s,$shscripsG,${SED_GREEN}," | sed -E "s,$Wfolders,${SED_RED},";
    fi
  done
done
echo ""
