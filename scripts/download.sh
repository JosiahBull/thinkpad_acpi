#!/usr/bin/env bash

# This script downloads the current thinkpad_acpi version from the linux github repository, and then attempts to modify the files
# to remove the lap_mode sensor.

# Collect files from github
wget 'https://raw.githubusercontent.com/torvalds/linux/master/drivers/platform/x86/thinkpad_acpi.c' -O thinkpad_acpi.c;
if [ $? -ne 0 ]; then
    echo "Failed to download thinkpad_acpi.c";
    exit 1;
fi

wget 'https://raw.githubusercontent.com/torvalds/linux/master/drivers/platform/x86/dual_accel_detect.h' -O dual_accel_detect.h;
if [ $? -ne 0 ]; then
    echo "Failed to download dual_accel_detect.h";
    exit 1;
fi

# Apply modifications to thinkpad_acpi.c
# disable lapmode sensor
sed -i 's/*state = output \& BIT(DYTC_GET_LAPMODE_BIT) ? true : false/*state = output \& BIT(DYTC_GET_LAPMODE_BIT) ? false : false/' thinkpad_acpi.c;
if [ $? -ne 0 ]; then
    echo "Failed to modify thinkpad_acpi.c";
    exit 1;
fi

# add author, so this file is identifiable from the default
echo "MODULE_AUTHOR(\"Josiah Bull <josiah.bull7@gmail.com>\");" >> thinkpad_acpi.c;