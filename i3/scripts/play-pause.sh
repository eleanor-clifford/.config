#!/bin/sh
if [ -f /tmp/polybar-player/current ]; then
	args="-p $(cat /tmp/polybar-player/current)"
else
	args=""
fi
playerctl $args play-pause
