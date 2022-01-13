#!/bin/sh
xrandr \
	--output DisplayPort-0 \
		--off \
	--output eDP \
		--primary \
		--rotate left \
		--mode 1920x1080 \
		--pos 0x0
xinput set-prop pointer:"ELAN2514:00 04F3:2AF0" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Stylus Pen (0)" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Stylus Eraser (0)" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
echo -n "3" > $HOME/.config/scripts/currentrotation
