#!/bin/sh
ssh raspberryfry "python3 remote-powerbutton/pressquick.py"
while ! ncat -vz pillowvan.ddns.net 3022 -w 1 2>&1 | grep -q Connected; do
	sleep 1
	echo -n .
done
echo
