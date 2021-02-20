#!/bin/sh
pubaddr=$(wget http://ipecho.net/plain -O - -q)
if [ $? -eq 0 ]; then
	if ip addr | grep -E "enp.|eno.|eth." | grep "state UP" -q; then
		addr=$(ip addr | grep -E "enp.|eno.|eth." | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v 255)
		pre="     Wired Network"
	else
		addr=$(hostname -i | awk '{print $1}')
		pre="    $(iwgetid -r)"
	fi
	if $HOME/.config/scripts/islandscape.sh; then
		echo -n "$pre   |   $addr   |   $pubaddr    "
	else
		echo -n "$pre    "
	fi
else
	echo "No Connection    "
fi
