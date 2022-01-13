#!/bin/sh
if [ -e $HOME/.config/i3/display_already_setup ]; then
	rm $HOME/.config/i3/display_already_setup
else
	# ethernet won't have connected at this point
	#if [ "$(cat /etc/hostname)" = "tim-laptop" ] && \
		#(nmcli con show | grep -q ethernet) &&
		#ssh -o "BatchMode=yes" -o "ConnectTimeout=1" tim-desktop-local "exit"
	#then
		#$HOME/.config/scripts/rotateleft-norestart.sh
	#else
		$HOME/.config/scripts/rotatenormal-norestart.sh
	#fi
fi
