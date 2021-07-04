#!/bin/dash
pow=$(cat /sys/class/power_supply/BAT1/power_now)
if ! [ -f $HOME/.config/polybar/power/pow.txt ]; then
	echo $pow > $HOME/.config/polybar/power/pow.txt
fi
lpow=$(cat $HOME/.config/polybar/power/pow.txt)
pow=$(echo "$lpow*(19/20) + $pow/20" | bc -l)
echo $pow > $HOME/.config/polybar/power/pow.txt

eng=$(cat /sys/class/power_supply/BAT1/energy_full)
eng_rem=$(cat /sys/class/power_supply/BAT1/energy_now)
time=$(echo "scale=3; $eng_rem / $pow" | bc -l)
time=$(printf "%.2g\n" "$time")
echo -n "$time hr"
