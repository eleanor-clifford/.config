#!/bin/bash
echo "device_add usb-host,bus=xhci.0,vendorid=0x0a5c,productid=0x21ec,port=4,id=bluetooth" | sudo nc -U /home/tim/vm/qemu-monitor.socket -q 1
echo -n "1" > /home/tim/vm/bluetooth_redirected.maybe
