#!/bin/sh
xrandr \
        --output DisplayPort-0 \
                --mode 3840x2160 \
                --scale 0.9999x0.9999 \
                --pos -960x-2160 \
        --output eDP \
                --primary \
                --mode 1920x1080 \
				--rotate normal \
                --pos 0x0
xrandr --output DisplayPort-0 --panning 3840x2160+0+0
xinput set-prop pointer:"ELAN2514:00 04F3:2AF0" --type=float "Coordinate Transformation Matrix" 0.5 0 0.25 0 0.33333333 0.666666667 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Pen (0)" --type=float "Coordinate Transformation Matrix" 0.5 0 0.25 0 0.33333333 0.666666667 0 0 1
xinput set-prop "ELAN2514:00 04F3:2AF0 Eraser (0)" --type=float "Coordinate Transformation Matrix" 0.5 0 0.25 0 0.33333333 0.666666667 0 0 1
echo -n "0" > $HOME/scripts/currentrotation

