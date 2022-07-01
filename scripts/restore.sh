#!/usr/bin/env bash

# This script will restore the original module if it was backed up.

if test -f "../backup/thinkpad_acpi.ko.xz.bak"; then
    echo "Restoring original thinkpad_acpi module...";
    rm -f /lib/modules/$(uname -r)/kernel/drivers/platform/x86/thinkpad_acpi.ko.xz;
    rm -f /lib/modules/$(uname -r)/kernel/drivers/platform/x86/thinkpad_acpi.ko;
    cp ../backup/thinkpad_acpi.ko.xz.bak /lib/modules/$(uname -r)/kernel/drivers/platform/x86/thinkpad_acpi.ko.xz;
    if [ $? -ne 0 ]; then
        echo "Failed to restore original thinkpad_acpi module";
        exit 1;
    fi
fi