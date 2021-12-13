#!/bin/dash
# This script used to work on any screen size but i deleted it by accident, now we have this
xrandr | sed -n 's/.* connected[^[:digit:]]*\([[:digit:]]\+\)x\([[:digit:]]\+\).*/\1 > \2/p'\
       | bc -l | egrep -q "^0$" && exit 1 || exit 0
