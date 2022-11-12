#!/usr/bin/env bash

VERSION="$(uname -r)"

# Fix for issue #3, the lapmode sensor only got added in kernel v5.9, if we are less than that this script will do nothing, as this
# kernel module can't read that value anyway.
printf '%s\n' "5.9" "$VERSION" | sort -CV || (
  echo "The kernel version is < 5.9. This dkms modification will do nothing for you, sorry! Please consider updating your kernel."
  exit 1
)

exit 0
