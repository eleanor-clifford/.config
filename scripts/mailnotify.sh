ACTION=$(dunstify "New mail! Right click to open" --action="default,Open")
case $ACTION in
	default )
		kitty sh -c neomutt;;
esac
