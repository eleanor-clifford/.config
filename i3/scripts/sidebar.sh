#!/bin/sh
if pgrep conky; then
#	X=$(xdotool getmouselocation | awk '{print $1}' | cut -d : -f 2)
#	Y=$(xdotool getmouselocation | awk '{print $2}' | cut -d : -f 2)
	if [ $(cat $HOME/.i3/sidebar-isshown) -eq 1 ]; then
#		xdotool mousemove 20 1000
#		sleep 0.05
		i3-msg '[class="Conky"] move absolute position -517px 60px'
#		xdotool mousemove $X $Y
		echo 0 > $HOME/.i3/sidebar-isshown
	else
#		xdotool mousemove 0 1000
#		sleep 0.05
		i3-msg '[class="Conky"] move absolute position 15px 60px'
#		xdotool mousemove $X $Y
		echo 1 > $HOME/.i3/sidebar-isshown
	#pkill -9 conky
	fi
else
	conky &
	sleep 0.3
	i3-msg 'move absolute position 15px 60px'
fi
