#!/bin/sh
set -x
sleep 0.1
# tell xorg it will restart soon
echo -n "2" > /home/tim/xorg.autorestart
i3-msg exit
sleep 1
echo -n "0000:01:00.0" > /sys/bus/pci/drivers/nvidia/unbind
echo -n "0000:01:00.1" > /sys/bus/pci/drivers/snd_hda_intel/unbind
# wl is blacklisted so this should be ok
# echo -n "0000:03:00.0" > /sys/bus/pci/drivers/wl/unbind
echo -n "0000:04:00.0" > /sys/bus/pci/drivers/xhci_hcd/unbind
modprobe vfio_pci vfio vfio_iommu_type1 vfio_virqfd
# wait for modules
:
while [ $? -eq 0 ]; do
	lspci -nnks 01:00.0 | grep "Kernel driver in use: nvidia" >/dev/null; \
done
/home/tim/scripts/update-xorg.sh
# let xorg restart
echo -n "1" > /home/tim/xorg.autorestart
