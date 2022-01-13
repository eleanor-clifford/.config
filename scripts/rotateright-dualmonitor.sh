#!/bin/sh
xrandr \
	--output DisplayPort-0 \
		--primary \
		--mode 3840x2160 \
		--scale 0.9999x0.9999 \
		--pos 0x0 \
		--panning 3840x2160+0+0 \
	--output eDP \
		--rotate right \
		--mode 1920x1080 \
		--panning 1080x1920+1380+2160 \
		--pos 1380x2160
xrandr --output DisplayPort-0 --panning 3840x2160+0+0 # I don't fucking care why this works ok?
xinput set-prop pointer:"ELAN2514:00 04F3:2AF0" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Stylus Pen (0)" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Stylus Eraser (0)" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
echo -n "1" > $HOME/.config/scripts/currentrotation
pkill -9 polybar
pkill -9 picom
i3-msg restart
