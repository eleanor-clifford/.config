#!/bin/bash
if [ -f $HOME/.config/i3/focused ]; then
	# I really don't like this but it's quicker thah restarting polybar
	sed -i 's/^corner-radius.*/corner-radius = 15.0;/' .config/picom.conf
	i3-msg 'gaps inner all set 10'
	xdo show -N Polybar
	rm $HOME/.config/i3/focused
else
	# I really don't like this but it's quicker thah restarting polybar
	sed -i 's/^corner-radius.*/corner-radius = 0.0;/' .config/picom.conf
	i3-msg 'gaps inner all set 0'
	xdo hide -N Polybar
	touch $HOME/.config/i3/focused
fi
