#!/usr/bin/env bash

# This script downloads the current thinkpad_acpi version from the linux github repository, and then attempts to modify the files
# to remove the lap_mode sensor.

VERSION=$(uname -r);
VERSION="${VERSION%%-*}";

echo "Downloading relevant files from linux git repsoitory...";

# Collect files from github
wget -q "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/thinkpad_acpi.c?h=v$VERSION" -O "thinkpad_acpi.c";
if [ $? -ne 0 ]; then
    echo "Failed to download thinkpad_acpi.c";
    exit 1;
fi

wget -q "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/dual_accel_detect.h?h=v$VERSION" -O "dual_accel_detect.h";
if [ $? -ne 0 ]; then
    echo "Failed to download dual_accel_detect.h";
    exit 1;
fi

echo "Applying modifications to thinkpad_acpi.c...";

# Apply modifications to thinkpad_acpi.c
# disable lapmode sensor
sed -i 's/*state = output \& BIT(DYTC_GET_LAPMODE_BIT) ? true : false/*state = output \& BIT(DYTC_GET_LAPMODE_BIT) ? false : false/' thinkpad_acpi.c;
if [ $? -ne 0 ]; then
    echo "Failed to disable the lapmode sensor for thinkpad_acpi.c";
    exit 1;
fi

# increment version
#HACK: we're just replacing it with a bigger number, but eventually this could fail.
# it would be smarter to read the current value, and add one. But this is likely to be fine for the foreseeable future.
sed -i '/#define TPACPI_VERSION "/c\#define TPACPI_VERSION "420.26"' thinkpad_acpi.c;
if [ $? -ne 0 ]; then
    echo "Failed to update version information for thinkpad_acpi.c";
    exit 1;
fi

# add author, so this file is identifiable from the default
#echo "MODULE_AUTHOR(\"Josiah Bull <josiah.bull7@gmail.com>\");" >> thinkpad_acpi.c;


echo "Modifications applied successfully!";
