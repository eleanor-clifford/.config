#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	$HOME/.config/scripts/rotatenormal-dualmonitor.sh
else
	$HOME/.config/scripts/rotatenormal-singlemonitor.sh
fi
pkill -9 polybar
pkill -9 picom
touch $HOME/.config/i3/display_already_setup
i3-msg restart
