#!/bin/sh
status=`exec systemctl is-active bluetooth.service`
if [ "$status" = "active" ]; then
	echo 
else
	echo 
fi
