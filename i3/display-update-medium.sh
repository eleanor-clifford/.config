#!/bin/sh
# primary
sudo ddcutil setvcp 10 30 -b 8
# secondary
sudo ddcutil setvcp 10 60 -b 6 --force-slave-address
sudo ddcutil setvcp 12 20 -b 6 --force-slave-address
