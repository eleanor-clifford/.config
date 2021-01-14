# primary
sudo ddcutil setvcp 10 0 -b 5
# secondary
sudo ddcutil setvcp 10 10 -b 12 --force-slave-address
sudo ddcutil setvcp 12 1 -b 12 --force-slave-address
