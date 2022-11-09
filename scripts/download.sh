#!/usr/bin/env bash

# This script downloads the current thinkpad_acpi version from the linux github repository, and then attempts to modify the files
# to remove the lap_mode sensor.

VERSION=$(uname -r);
VERSION="${VERSION%%-*}";
TRIMMED_V="${VERSION::-2}";
DO_ACCEL=true

# Fix for issue #3, `dual_accel_detect.h` only got added in kernel v5.14, if we are less than that set the flag false so we don't
# attempt to download `dual_accel_detect.h`.
printf '%s\n' "$VERSION" "5.14" | sort -CV;
if [ "$?" -ne 1 ]; then
    echo "Kernel version is < 5.14, dual_accel_detect.h download is not required";
    DO_ACCEL=false
fi

# Fix for issue #2, linux kernel website tracks versioning with only x.x, unless there is a minor issue in which case it tracks x.x.x.
# however, `uname -r` always returns x.x.x, so if we trim the last two chars off the number in *.0 cases, we can collect the files
# correctly.
if [[ ${#VERSION} -ge 4 ]] && [[ $VERSION == *.0 ]]; then
    echo "Version is *.0, correcting version script";
    VERSION=$TRIMMED_V;
fi

echo "Downloading relevant files from linux git repsoitory...";

# Collect files from github
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/thinkpad_acpi.c?h=v$VERSION" -O "thinkpad_acpi.c";
if [ $? -ne 0 ]; then
    echo "Failed to download thinkpad_acpi.c";
    exit 1;
fi

if [ $DO_ACCEL = true ]; then
    wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/dual_accel_detect.h?h=v$VERSION" -O "dual_accel_detect.h";
    if [ $? -ne 0 ]; then
        echo "Failed to download dual_accel_detect.h";
        exit 1;
    fi
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
