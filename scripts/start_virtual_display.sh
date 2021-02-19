#!/bin/dash
# starts with 2 spaces for modes
if ! xrandr | egrep -v '^  1080x1920_60'; then
	xrandr --newmode "1080x1920_60"  176.50  1080 1168 1280 1480  1920 1923 1933 1989 -hsync +vsync
fi
# starts with 3 spaces for modes of outputs
if ! xrandr | egrep -v '^   1080x1920_60'; then
	xrandr --addmode HDMI-1-2 1080x1920_60
fi
xrandr \
	--output DP-2 \
		--primary \
		--mode 3840x2160 \
		--panning 3840x2160+0+0  \
		--scale 0.9999x0.9999 \
		--pos 0x0 \
		--gamma 1.05:1.05:1.05 \
	--output HDMI-0 \
		--mode 1920x1080 \
		--scale-from 2944x1656 \
		--pos 3840x504 \
		--panning 2944x1656+3840+504 \
		--gamma 1:1:1 \
	--output HDMI-1-2 \
		--mode 1080x1920_60 \
		--pos 1380x2160
