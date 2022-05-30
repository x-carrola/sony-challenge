# sony-challenge

In this challenge, we will focus on the 4th phase of hacking a system: the **post-exploitation** stage. Therefore, we 
will assume that we already have access to the target and that we want mainly two things:

* maintain access to the target, in case of a reboot or any issue that may kick us from the system

* escalate our privileges to have more control over the target (get *root* permissions, if possible)

Here are the **attack vectors** chosen for exploitation attempt:
* kernel vulnerabilities
* Linux utilities vulnerabilities
* 


* Check if we are inside a container (Docker or lxc) and try to escape from it
* Credentials stored in clear text in memory
* Explore capabilities
* Explore additional defense mechanisms: SELinux, App Armor, etc.



Assumptions:

* we already have access to the target
* the target is running a Linux distro
* bash is available in the target



## Attack vector #1 - Kernel vulnerabilities

Just by checking the kernel version used it is possible to see if the target is vulnerable to any of the most common 
kernel privilege escalation exploits. There are several publicly-available lists of kernel exploits. One of the 
easiest tools to do this is [linux exploit suggester](https://github.com/mzet-/linux-exploit-suggester).

## Attack vector #2 - Linux utilities vulnerabilities

If the system is using outdated versions or widely used utilities, some vulnerabilities can be exploited. We checked 
**sudo** and **dmesg**.

## Attack vector #3 - Processes

The purpose here is to find processes that are being executed with more privileges than they should, regarding both the 
process binary itself as well as all the files opened by it.

Scheduled CRON jobs are also checked in order to see is any of them is vulnerable. Maybe we can take advantage of some 
script veing executed by root in any of those CRON jobs.

## Attack vector #4 - Services

First of all, we can check if any .service file is writable. If so, we the system can be exploited by modifying it so 
it executes a backdoor when the service is started, restarted or stopped. Furthermore, if we have write permissions 
over binaries being executed by services, we can change them for backdoors so when the services get re-executed the 
backdoors will be executed.

Last but not least, we must check if we have write permissions in any folder belonging to systemd PATH. If so, we can 
place there an executable with the same name as the relative path binary called in systemd service.

## Attack vector #5 - Sockets

### Writable sockets and check if they are calling writable binaries



## Attack vector #6 - Network

## Info about network config

#Hostname, hosts and DNS
cat /etc/hostname /etc/hosts /etc/resolv.conf
dnsdomainname

#Content of /etc/inetd.conf & /etc/xinetd.conf
cat /etc/inetd.conf /etc/xinetd.conf

#Interfaces
cat /etc/networks
(ifconfig || ip a)

#Neighbours
(arp -e || arp -a)
(route || ip n)

#Iptables rules
(timeout 1 iptables -L 2>/dev/null; cat /etc/iptables/* | grep -v "^#" | grep -Pv "\W*\#" 2>/dev/null)

#Files used by network services
lsof -i


## Attack vector #7 - Users

## Info about users and groups

#Info about me
id || (whoami && groups) 2>/dev/null
#List all users
cat /etc/passwd | cut -d: -f1
#List users with console
cat /etc/passwd | grep "sh$"
#List superusers
awk -F: '($3 == "0") {print}' /etc/passwd
#Currently logged users
w
#Login history
last | tail
#Last log of each user
lastlog

#List all users and their groups
for i in $(cut -d":" -f1 /etc/passwd 2>/dev/null);do id $i;done 2>/dev/null | sort


## Attack vector #8 - Writable PATH abuses

### Find writable folders in PATH

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

### Find SUID binaries

find / -perm -4000 2>/dev/null #Find all SUID binaries

### .sh files in PATH

echo $PATH | tr ":" "\n" | while read d; do
  for f in $(find "$d" -name "*.sh" 2>/dev/null); do
    if ! [ "$IAMROOT" ] && [ -O "$f" ]; then
      echo "You own the script: $f" | sed -${E} "s,.*,${SED_RED},"
    elif ! [ "$IAMROOT" ] && [ -w "$f" ]; then #If write permision, win found (no check exploits)
      echo "You can write script: $f" | sed -${E} "s,.*,${SED_RED_YELLOW},"
    else
      echo $f | sed -${E} "s,$shscripsG,${SED_GREEN}," | sed -${E} "s,$Wfolders,${SED_RED},";
    fi
  done
done
















