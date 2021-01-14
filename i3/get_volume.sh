#!/bin/bash
sink_long=$(pactl list short | grep RUNNING)
if [ $? -eq 0 ]; then
	SINK=$(echo $sink_long | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,')
	pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK - 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' > /home/tim/.i3/current_volume
fi
echo $(cat /home/tim/.i3/current_volume)
