#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	/home/tim/scripts/rotateleft-dualmonitor.sh
else
	/home/tim/scripts/rotateleft-singlemonitor.sh
fi
pkill -9 polybar
pkill -9 picom
touch /home/tim/.config/i3/display_already_setup
i3-msg restart
