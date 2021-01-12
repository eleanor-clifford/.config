#!/usr/bin/python3
from datetime import datetime
from time import sleep
while True:
	while datetime.now().second%5 < 2.5:
		pass
	pow = open("/sys/class/power_supply/BAT1/power_now").read()[:-1] # remove \n
	energy = open("/sys/class/power_supply/BAT1/energy_now").read()[:-1]
	open("batterylog.txt","a").write(f"{pow} {energy}\n")
	print("logged")
	sleep(3)

