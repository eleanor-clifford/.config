#!/bin/sh
modprobe i2c_dev

# primary
## get bus, shutup
bus=$(ddcutil detect | grep -B10 'ASUS VG289' | grep /dev/i2c \
	| sed 's|.*/dev/i2c-\([[:digit:]]\+\).*|\1|')
ddcutil setvcp 10 30 -b $bus
