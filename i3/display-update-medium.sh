# primary
sudo ddcutil setvcp 10 30 -b 5
# secondary
sudo ddcutil setvcp 10 60 -b 12 --force-slave-address
sudo ddcutil setvcp 12 20 -b 12 --force-slave-address
