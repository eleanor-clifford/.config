#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 0 -b 8
# secondary
ddcutil setvcp 10 10 -b 6 --force-slave-address
ddcutil setvcp 12 1 -b 6 --force-slave-address
