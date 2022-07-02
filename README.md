# Linux Thinkpad Disable Lapmode

During the purchase of a recent ThinkPad, I ran into an issue where I was forced to stay on the "balanced" power-mode. This is because some ThinkPads have a small accelerometer which detects if it's on an unstable surface (e.g. a lap).

Ostensibly this is because some of these devices can get dangerously hot on the bottom during use, but personally I prefer to have control over my device and what power-mode I'm in.


This script works by downloading [`thinkpad_acpi`](https://github.com/torvalds/linux/blob/master/drivers/platform/x86/thinkpad_acpi.c) from the linux kernel, compiling it, and then patching the existing kernel module.


## Am I affected?
In gnome power settings you might see this:

<img src="./example-img.png" alt="screenshot of an output demonstrating lapmode enabled"/>

Or, you may see this result from running the `powerprofilectl` command:
```bash
$ powerprofilesctl
  performance:
    Driver:     platform_profile
    Inhibited:  yes (lap-detected)

* balanced:
    Driver:     platform_profile

  power-saver:
    Driver:     platform_profile

```

## Will this solution work for me?
Some thinkpads don't seem to respect the changes, they may have some other kernel/hardware level control. I'm investigating this, but for the time being you can test if your device will benefit without modifying your kernel by just unloading the `thinkpad_acpi` module entirely. If functionality is affected, a simple reboot will restore it.
**Unload Module**
```bash
sudo modprobe -r thinkpad_acpi
```
**Reload Module**
```bash
sudo modprobe thinkpad_acpi
```

## Supported Operating Systems
These are distros I have actually tested the script on.
- Fedora 34/35/36
- Rocky Linux 8
- ubuntu 20.04/22.04

## Installation

You are replacing a kernel module, this comes with some degree of risk to your system. Please consider backing up important data before beginning.

**Install prerequisites:**
```bash
# RHEL (F34+)
sudo dnf update
sudo dnf install make automake gcc gcc-c++ kernel-devel dkms wget openssl git

# Ubuntu (20.04+)
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential dkms git

# Reboot after updates!
sudo reboot
```

**Install module:**
```bash
git clone https://github.com/JosiahBull/thinkpad_acpi
cd thinkpad_acpi
# Copy the file for dkms
sudo cp -R . /usr/src/thinkpad_acpi-1.0

# Add the module to dkms
sudo dkms add -m thinkpad_acpi/1.0

# Build the module
# !!!IMPORTANT!!! An internet connection is required for this step! A script will automatically download and patch files from the linux kernel. See scripts/download.sh for more information.
sudo dkms build thinkpad_acpi/1.0
# Install the module
sudo dkms install thinkpad_acpi/1.0
```

Reboot your system, if you run `sudo modinfo thinkpad_acpi`, you should see the version is set to:
```bash
version: 420.26
singer: DKMS module signing key
```

Congratulations! You've patched your kernel. The lap-mode sensor is now disabled.

## Uninstallation
Uninstallation is easy, dkms should restore the original kernel module.

```bash
sudo dkms uninstall thinkpad_acpi/1.0
sudo dkms remove thinkpad_acpi/1.0
yes | sudo rm -rd /usr/src/thinkpad_acpi-1.0
```

## Other Solutions

- Monkey Patching the kernel (untested): https://blog.cloudflare.com/how-to-monkey-patch-the-linux-kernel/ Credit to [@lachlan2k](https://github.com/lachlan2k) for finding this.
```bash
# This is a guess for possible syntax, I provide no guarantees.
probe module("thinkpad_acpi").function("lapsensor_get").return {
    *present = 1;
    *state = 1;
}
```
- Live being stuck in balanced power-mode because you type a little too hard, and the accelerometer is overly sensitive.

## Relevant Discussions

- https://ask.fedoraproject.org/t/what-is-lap-mode/9524
- https://askubuntu.com/questions/1416465/how-to-disable-lap-detection
- https://askubuntu.com/questions/1416567/disable-lap-mode-on-lenovo-laptop
- https://www.reddit.com/r/thinkpad/comments/o2h6kf/linux_lap_mode/
- https://bugzilla.redhat.com/show_bug.cgi?id=2014261

## Licensing & Contribution

All contributions are welcome, and will be licensed under MIT unless otherwise specified.