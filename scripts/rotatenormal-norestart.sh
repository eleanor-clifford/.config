#!/bin/bash
if xrandr | grep -q "DisplayPort-0 connected"; then
	/home/tim/scripts/rotatenormal-dualmonitor.sh
else
	/home/tim/scripts/rotatenormal-singlemonitor.sh
fi
