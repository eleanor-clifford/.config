#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 0 -b 9
