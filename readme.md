# Linux Thinkpad Disable Lapmode

During the purchase of a recent ThinkPad, I ran into an issue where I was forced to stay on the "balanced" power-mode. This is because some ThinkPads have a small accelerometer which detects if it's on an unstable surface (e.g. a lap).

Ostensibly this is because some of these devices can get dangerously hot on the bottom during use, but personally I prefer to have control over my device and what power-mode I'm in.

This is a fork of the [`thinkpad_acpi`](https://github.com/torvalds/linux/blob/master/drivers/platform/x86/thinkpad_acpi.c) kernel module, which disables the lapmode sensor.

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

## Installation

You are replacing a kernel module, this comes with some degree of risk to your system. If something goes wrong you should be able to reboot and it'll revert back, but kernel modules operate at a very low level on the OS with almost no checks. This module is currently still in development, so I'd be appreciative if any problems encountered are reported here.

That being said, there isn't a fully completed installation method yet, however you can test if the module will work for you. The current installation method will need to be repeated each time your kernel updates, integration with dkms will fix this issue.

**Install prerequisites:**
```bash
# RHEL (F32+)
sudo dnf install make automake gcc gcc-c++ kernel-devel dkms
```

**Install module:**
```bash
git clone https://github.com/JosiahBull/thinkpad_acpi
cd thinkpad_acpi/src
make
sudo rmmod thinkpad_acpi && sudo insmod thinkpad_acpi_custom.ko
# Stop and validate the module is working as intended, the next step will load it at BOOT, which could brick your system (note that if this does occur, you can blacklist `thinkpad_acpi_custom` in your kernel boot options to restore functionality to the system).
sudo make install
```

**Uninstall module**
```bash
sudo make uninstall
```

If your power-mode is now changeable, it worked! If you get an error about the key not being accepted, you may need to disable secureboot in your bios.

## Project Goals
- [ ] Provide a robust installation method, e.g. dkms.
- [ ] Automatically sign module so it can work without disabling secureboot.
- [ ] Automatically update this repository when the source `thinkpad_acpi` file changes.
- [ ] Testing on other OS, I'm developing on Fedora so I can only guarantee functionality on RHEL based distributions.

## Other Solutions

- Monkey Patching the kernel (untested): https://blog.cloudflare.com/how-to-monkey-patch-the-linux-kernel/
```bash
# This is a guess for possible syntax, I provide no guarantees.
probe module("thinkpad_acpi").function("lapsensor_get").return {
    *present = 1;
    *state = 1;
}
```
- Live being stuck in balanced power-mode because you sneezed.

## Relevant Issues

- https://ask.fedoraproject.org/t/what-is-lap-mode/9524
- https://askubuntu.com/questions/1416465/how-to-disable-lap-detection
- https://askubuntu.com/questions/1416567/disable-lap-mode-on-lenovo-laptop

## Licensing & Contribution

All contributions are welcome, as this is a fork of the linux kernel, all changes will be licensed under GPLv3.