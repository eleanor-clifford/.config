#!/bin/sh

if [ "$1" = "" ]; then
	read -p "Name of Lab: " name
else
	name="$@"
fi
name_sanitised="$(echo "$name" | sed 's/ /_/g')"

matches="$(ls ~/OneDrive-Cam/Coursework | grep "^$name_sanitised")"

if [ "$matches" = "" ]; then
	# Make new lab
	cp -r --copy-contents ~/.config/templates/lab/ ~/OneDrive-Cam/Coursework/$name_sanitised
	cd ~/OneDrive-Cam/Coursework/$name_sanitised
	rename 'LAB' $name_sanitised *
	sed -i "s|LAB|$name|g" * # note not sanitised here
elif [ "$(echo "$matches" | wc -l)" = "1" ]; then
	# Open lab
	cd ~/OneDrive-Cam/Coursework/${name_sanitised}*
else
	echo "Multiple matching labs, aborting..."
	exit 1
fi

nvim +":call venus#PandocMake() | call venus#OpenZathura()" *.md
