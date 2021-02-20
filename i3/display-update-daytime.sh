#!/bin/sh
# primary
sudo ddcutil setvcp 10 90 -b 5
# secondary
sudo ddcutil setvcp 10 100 -b 12 --force-slave-address
# makes blacks unable to distinguish but tolerable brightness
sudo ddcutil setvcp 12 40 -b 12 --force-slave-address
