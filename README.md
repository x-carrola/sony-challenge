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


# Instructions

To build the program:
```
cd sony-challenge
make
```

To run the program:
```
./out/output
```


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

Sockets allow communication between two different processes. Just like services, we can check if any .socket file is 
writable. If so, we can add a backdoor to this configuration file that will be executed when the configuration file 
is called again.

Moreover, if we find any writable socket (not .socket config files, the socket file itself) then we can communicate 
with it and maybe exploit a vulnerability.

## Attack vector #6 - Network

We can get a bigger insight of the target by knowing what their network configurations are and what is the position of 
the machine in the network. To enumerate the network, we will check the network interfaces config, the neighbours, 
iptables rules and opened ports on the target.

## Attack vector #7 - Users

In order to escalate priviledges, it is important to check which user are we and which privileges does it have. 
Besides that, we must search other users in the system, in which can we login and which ones have root priviledges.

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
















