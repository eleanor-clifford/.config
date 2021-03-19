#!/bin/sh
set -x
sleep 0.1
# save workspaces
sudo -u tim /home/tim/.i3/save-all.sh
i3-msg exit
# wait for Xorg to stop
pgrep Xorg
while [ $? -eq 0 ]; do sleep 0.1; pgrep Xorg; done
# more reliable to just unload
rmmod nvidia_drm nvidia_modeset nvidia
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
# start the vm
/usr/bin/win-vm >/dev/null 2&>1 &
# set new xorg display
/home/tim/scripts/update-xorg.sh
# let xorg restart
systemctl start xlogin@tim
# swap monitor input
ddcutil setvcp 60 1 -b 12 --force-slave-address
# wait for polybar to restart, since it starts after i3 sets display settings
pgrep polybar
while [ $? -ne 0 ]; do sleep 0.1; pgrep polybar; done
# load workspaces
sudo -u tim /home/tim/.i3/load-all.sh
# set to secondary monitor only
DISPLAY=:0 xrandr --output HDMI-2 --off --output DP5 --mode 1920x1080 --scale-from 2944x1656;
sleep 2
# Fix wallpapers
DISPLAY=:0 feh --bg-scale /home/tim/.i3/lock-cache/resized.png
