#!/bin/bash

# Check if sudo version is vulnerable
if [ "$(command -v sudo 2>/dev/null)" ]; then
    echo "Is sudo version vulnerable?"
    (sudo -V | grep "Sudo ver" | grep "1\.[01234567]\.[0-9]\+\|1\.8\.1[0-9]\*\|1\.8\.2[01234567]") || echo "sudo version is not vulnerable"
    echo ""
fi

# Dmesg signature verification failed
if [ "$(command -v dmesg 2>/dev/null)" ] ; then
    echo "Searching Signature verification failed in dmesg"
    (dmesg 2>/dev/null | grep "signature") || echo "dmesg signature verification OK"
    echo ""
fi
