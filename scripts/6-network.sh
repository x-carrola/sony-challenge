#!/bin/bash

source $(dirname $0)/common.sh

# Network interfaces
echo "Network interfaces"
cat /etc/networks 2>/dev/null
(ifconfig || ip a) 2>/dev/null
echo ""

# Neighbours
echo "Networks and neighbours"
(route || ip n || cat /proc/net/route) 2>/dev/null
(arp -e || arp -a || cat /proc/net/arp) 2>/dev/null
echo ""

# Iptables rules
echo "Iptables rules"
(iptables -L 2>/dev/null; cat /etc/iptables/* | grep -v "^#" | grep -Ev "\W+\#|^#" 2>/dev/null) 2>/dev/null || echo "iptables rules not found"
echo ""

# Active ports
echo "Active Ports"
( (netstat -punta || ss -nltpu || netstat -anv) | grep -i listen) 2>/dev/null | sed -E "s,127.0.[0-9]+.[0-9]+|:::|::1:|0\.0\.0\.0,${SED_RED},"
echo ""
