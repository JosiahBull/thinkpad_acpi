obj-m += thinkpad_acpi_custom.o

all:
	make -C /lib/modules/$(uname -r)/build M=$(PWD) modules
	xz thinkpad_acpi_custom.ko

clean:
	make -C /lib/modules/$(uname -r)/build M=$(PWD) clean

install:
# Install the module
	sudo cp thinkpad_acpi_custom.ko.xz /lib/modules/$(uname -r)/kernel/drivers/platform/x86/
	sudo echo "thinkpad_acpi_custom" >> /etc/modules.conf
# Disable the default module
	sudo echo "blacklist thinkpad_acpi" >> /etc/modprobe.d/blacklist.conf

uninstall:
	sudo rm /lib/modules/$(uname -r)/kernel/drivers/platform/x86/
	sed -i.bak '/thinkpad_acpi_custom/d' /etc/modules.conf
	sed -i.bak '/blacklist thinkpad_acpi/d' /etc/modprobe.d/blacklist.conf