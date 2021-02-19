#!/bin/bash
echo "device_del bluetooth" | sudo nc -U /home/tim/vm/qemu-monitor.socket -q 1
echo -n "0" > /home/tim/vm/bluetooth_redirected.maybe
