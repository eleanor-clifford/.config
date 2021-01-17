xrandr \
        --output DisplayPort-0 \
				--off \
        --output eDP \
                --primary \
                --mode 1920x1080 \
				--rotate normal \
                --pos 0x0 
xinput set-prop pointer:"ELAN2514:00 04F3:2AF0" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
xinput set-prop "ELAN2514:00 04F3:2AF0 Pen (0)" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
xinput set-prop "ELAN2514:00 04F3:2AF0 Eraser (0)" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
echo -n "0" > /home/tim/scripts/currentrotation

