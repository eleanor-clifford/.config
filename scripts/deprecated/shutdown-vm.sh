echo "system_powerdown" | sudo nc -U /home/tim/vm/qemu-monitor.socket -q 1
# wait for it to stop
pgrep qemu-system-x86
while [ $? -eq 0 ]; do sleep 0.1; pgrep qemu-system-x86; done
# save workspaces
sudo -u tim /home/tim/.i3/save-all.sh
i3-msg exit
# swap monitor input
ddcutil setvcp 60 17 -b 12 --force-slave-address
modprobe -r vfio_pci vfio vfio_iommu_type1 vfio_virqfd
echo -n "0000:01:00.0" > /sys/bus/pci/drivers/nvidia/bind
echo -n "0000:01:00.1" > /sys/bus/pci/drivers/snd_hda_intel/bind
# don't care about this one
# echo -n "0000:03:00.0" > /sys/bus/pci/drivers/wl/bind
echo -n "0000:04:00.0" > /sys/bus/pci/drivers/xhci_hcd/bind
# wait for nvidia to bind to the device
lspci -nnks 01:00.0 | grep "Kernel driver in use: nvidia" >/dev/null
while [ $? -ne 0 ]; do
        lspci -nnks 01:00.0 | grep "Kernel driver in use: nvidia" >/dev/null
done
/home/tim/scripts/update-xorg.sh
# let xorg restart
systemctl start xlogin@tim
# wait for polybar to restart, since it starts after i3 sets display settings
pgrep polybar
while [ $? -ne 0 ]; do sleep 0.1; pgrep polybar; done
# load workspaces
sudo -u tim /home/tim/.i3/load-all.sh
