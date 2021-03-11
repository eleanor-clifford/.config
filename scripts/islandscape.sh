#!/bin/dash
# This script used to work on any screen size but i deleted it by accident, now we have this
xrandr | sed -n 's/.* connected[^[:digit:]]*\([^x]\+\)x\([^+]\+\).*/\1 > \2/p'\
       | bc -l | egrep -q "^1$"
