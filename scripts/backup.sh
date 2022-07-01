#!/usr/bin/env bash

# The goal of this script is to backup the existing thinkpad_acpi module before it is replaced
# by the modified file. This allows us to restore your original file in the event of a failure. :)

cp /lib/modules/$(uname -r)/kernel/drivers/platform/x86/thinkpad_acpi.ko.xz ../backup/thinkpad_acpi.ko.xz.bak;