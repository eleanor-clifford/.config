#!/bin/sh
logitech_mouse_id=$(xinput | grep "Logitech MX Master" | sed 's/.*id=\([0-9]\+\).*/\1/' | head -1)
xinput set-button-map $logitech_mouse_id 1 2 3 4 5 10 11 8 9
xbindkeys
