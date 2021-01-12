#!/bin/bash

status=`exec systemctl is-active bluetooth.service`
if [ $status = "active" ]; then
	systemctl stop bluetooth.service
else
	systemctl start bluetooth.service
fi
