#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 90 -b 8
# secondary
ddcutil setvcp 10 100 -b 6 --force-slave-address
# makes blacks unable to distinguish but tolerable brightness
ddcutil setvcp 12 40 -b 6 --force-slave-address
