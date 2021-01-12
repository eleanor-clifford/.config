pow=$(cat /sys/class/power_supply/BAT1/power_now)
eng=$(cat /sys/class/power_supply/BAT1/energy_full)
eng_rem=$(cat /sys/class/power_supply/BAT1/energy_now)
time=$(echo "scale=3; $eng_rem / $pow" | bc -l)
time=$(printf "%.2g\n" "$time")
echo -n "$time hr"
