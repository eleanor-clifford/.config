#!/bin/sh
xrandr \
	--output DisplayPort-0 \
		--mode 3840x2160 \
		--scale 0.9999x0.9999 \
		--pos 0x0 \
		--panning 3840x2160+0+0 \
	--output eDP \
		--primary \
		--rotate left \
		--mode 1920x1080 \
		--pos 1380x2160
xrandr --output DisplayPort-0 --panning 3840x2160+0+0
# [[1, 0, 0.359375], [0, 1, 0], [0, 0, 1]] * [[1, 0, 0], [0, 1, 0.52941176], [0, 0, 1]] * [[0.28125, 0, 0], [0, 0.47058824, 0], [0, 0, 1]] * [[0, -1, 1], [1, 0, 0], [0, 0, 1]]
xinput set-prop pointer:"ELAN2514:00 04F3:2AF0" --type=float "Coordinate Transformation Matrix" 0 -0.28125 0.640625 0.470588 0 0.529412 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Pen (0)" --type=float "Coordinate Transformation Matrix" 0 -0.28125 0.640625 0.470588 0 0.529412 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Eraser (0)" --type=float "Coordinate Transformation Matrix" 0 -0.28125 0.640625 0.470588 0 0.529412 0 0 1
echo -n "1" > /home/tim/scripts/currentrotation
