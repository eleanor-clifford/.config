#!/bin/sh
modprobe i2c_dev
# primary
ddcutil setvcp 10 30 -b 9
