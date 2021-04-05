#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	$HOME/scripts/rotatenormal-dualmonitor.sh
else
	$HOME/scripts/rotatenormal-singlemonitor.sh
fi
