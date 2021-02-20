#!/bin/sh
if [ -e $HOME/.config/i3/display_already_setup ]; then
	rm $HOME/.config/i3/display_already_setup
else
	$HOME/.config/scripts/rotatenormal-norestart.sh
fi
feh --bg-fill $HOME/.config/i3/lock-cache/resized.png --geometry +0
