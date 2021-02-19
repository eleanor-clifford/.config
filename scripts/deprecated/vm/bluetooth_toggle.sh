if [ "$(cat /home/tim/vm/bluetooth_redirected.maybe)" -eq 1 ]; then
	/home/tim/vm/bluetooth_reclaim.sh
else
	/home/tim/vm/bluetooth_redirect.sh
fi

