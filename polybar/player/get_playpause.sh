#!/bin/bash

if [ -f /tmp/polybar-player-current ]; then
	args="-p $(cat /tmp/polybar-player-current)"
else
	args=""
fi

case "$(playerctl $args status)" in
"Playing")
	echo "    "
	;;
"Paused") 
	echo "    "
	;;
esac
