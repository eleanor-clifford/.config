#!/bin/sh
#setxkbmap colemak-custom
#id=$(xinput | grep "Tim Clifford ErgoDash-R  " \
	#| sed 's/.*id=\([[:digit:]]*\).*keyboard.*/\1/g')
#if ! [ "$id" = "" ]; then
	#setxkbmap -device $id gb
#fi
setxkbmap gb
