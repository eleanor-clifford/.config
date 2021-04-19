#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 90 -b 9
