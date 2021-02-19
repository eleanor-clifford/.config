#!/bin/bash
echo "0000:00:14.0" > /sys/bus/pci/drivers/xhci_hcd/unbind
echo "0000:00:14.0" > /sys/bus/pci/drivers/xhci_hcd/bind
