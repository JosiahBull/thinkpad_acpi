VERSION=$(uname -r);
VERSION="${VERSION%%-*}";
TRIMMED_V="${VERSION::-2}";

# Fix for issue #3, the lapmode sensor only got added in kernel v5.9, if we are less than that this script will do nothing, as this
# kernel module can't read that value anyway.
IFS='.' read -ra BROKEN_V <<< "$TRIMMED_V";
if [[ ${BROKEN_V[0]} -le 4 ]] ||  ([[ ${BROKEN_V[0]} -ge 5 ]] && [[ ${BROKEN_V[1]} -le 8 ]]); then
    echo "Kernel version is < 5.9, this dkms modification will do nothing for you sorry! Please consider updating your kernel.";
    exit 1;
fi

exit 0;