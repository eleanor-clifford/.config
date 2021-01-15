#!/bin/bash

case "$(playerctl status)" in
	"Playing")
		echo "    "
		;;
	"Paused")
		echo "    "
		;;
esac
