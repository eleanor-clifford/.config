#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 30 -b 8
# secondary
ddcutil setvcp 10 60 -b 6 --force-slave-address
ddcutil setvcp 12 20 -b 6 --force-slave-address
