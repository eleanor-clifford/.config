#!/bin/sh
for SINK in `pacmd list-sinks | grep 'index:' | cut -b12-`
do
	pactl set-sink-volume $SINK _METACONF_REPLACE_VOLUME_TICK_DOWN
done
