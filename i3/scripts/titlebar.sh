#!/bin/sh

# It seems to crash sometimes, but still only restart if X is still running
while pgrep i3 >/dev/null 2>&1; do
	$HOME/.config/i3/scripts/titlebar.rb
	sleep 1
done
