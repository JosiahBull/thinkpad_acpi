obj-m += thinkpad_acpi.o

all:
	make -C /lib/modules/$(uname -r)/build M=$(PWD) modules
	xz thinkpad_acpi.ko

clean:
	make -C /lib/modules/$(uname -r)/build M=$(PWD) clean