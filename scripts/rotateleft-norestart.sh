#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	$HOME/.config/scripts/rotateleft-dualmonitor.sh
else
	$HOME/.config/scripts/rotateleft-singlemonitor.sh
fi
