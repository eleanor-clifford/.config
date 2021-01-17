ws=$(i3-msg -t get_workspaces | jq ".[].num")
for i in {1..10}; do
	echo $i
	if [[ "$ws" != *"$i"* ]]; then
		i3-msg workspace $i
		exit 0
	fi
done
	
