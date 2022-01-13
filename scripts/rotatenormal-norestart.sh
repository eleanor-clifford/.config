#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	$HOME/.config/scripts/rotatenormal-dualmonitor.sh
else
	$HOME/.config/scripts/rotatenormal-singlemonitor.sh
fi
