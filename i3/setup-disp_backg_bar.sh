if [ -e /home/tim/.config/i3/display_already_setup ]; then
	rm /home/tim/.config/i3/display_already_setup
else
	/home/tim/scripts/rotatenormal-norestart.sh
fi
feh --bg-fill /home/tim/.config/i3/lock-cache/resized.png --geometry +0
MONITOR=eDP /home/tim/.config/polybar/launch /home/tim/.config/polybar/config top
MONITOR=eDP /home/tim/.config/polybar/launch /home/tim/.config/polybar/config bottom
MONITOR=DisplayPort-0 /home/tim/.config/polybar/launch /home/tim/.config/polybar/config top
MONITOR=DisplayPort-0 /home/tim/.config/polybar/launch /home/tim/.config/polybar/config external_bottom
