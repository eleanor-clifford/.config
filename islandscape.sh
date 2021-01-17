#!/bin/dash
# This script used to work on any screen size but i deleted it by accident, now we have this
xrandr | egrep -q "connected.*1920x1080"
