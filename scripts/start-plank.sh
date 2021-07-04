#!/bin/sh
XDG_SESSION_TYPE=x11 DESKTOP_SESSION=i3 plank &
#XDG_SESSION_TYPE=x11 DESKTOP_SESSION=i3 plank -n dock2 --gtk-name plank2 &
xwininfo -root -tree | grep plank | grep 00003
while [ $? -ne 0 ]; do
	sleep 1
	xwininfo -root -tree | grep plank | grep 00003
done
xprop -name plank -f _NET_WM_WINDOW_TYPE 32a -set _NET_WM_WINDOW_TYPE _NET_WM_WINDOW_TYPE_DESKTOP
#xprop -name plank2 -f _NET_WM_WINDOW_TYPE 32a -set _NET_WM_WINDOW_TYPE _NET_WM_WINDOW_TYPE_DESKTOP
pkill -9 polybar
pkill -9 picom
i3-msg restart
