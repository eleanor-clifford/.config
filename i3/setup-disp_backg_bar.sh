if [ -e $HOME/.config/i3/display_already_setup ]; then
	rm $HOME/.config/i3/display_already_setup
else
	$HOME/scripts/rotatenormal-norestart.sh
fi
feh --bg-fill $HOME/.config/i3/lock-cache/resized.png --geometry +0
MONITOR=eDP $HOME/.config/polybar/launch $HOME/.config/polybar/config top
MONITOR=eDP $HOME/.config/polybar/launch $HOME/.config/polybar/config bottom
MONITOR=DisplayPort-0 $HOME/.config/polybar/launch $HOME/.config/polybar/config top
MONITOR=DisplayPort-0 $HOME/.config/polybar/launch $HOME/.config/polybar/config external_bottom
