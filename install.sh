#!/bin/dash

# Apply metaconfig
if [ ! -f metaconfig/$(hostname).metaconf ]; then
	echo "No metaconfig defined for this hostname"
	exit 1
fi

IFS="
" # no bashisms please, dash gang B)
PREFIX=''
for line in $(cat "metaconfig/$(hostname).metaconf"); do

	# Parse config
	if echo $line | egrep -q "^\s*#"; then
		continue
	fi

	KEY=$(echo $line | sed -n 's/^\([^ ]\+\) *= *\([^# ]\+\).*/\1/p')
	VAL=$(echo $line | sed -n 's/^\([^ ]\+\) *= *\([^# ]\+\).*/\2/p')

	if [ "$KEY" = '' ] || [ "$VAL" = '' ]; then
		echo "Syntax Error: $line"
		exit 1
	fi

	if [ "$KEY" = 'PREFIX' ]; then
		PREFIX=$VAL
		continue
	fi

	if [ "$PREFIX" = '' ]; then
		echo "A prefix must be defined first"
		exit 1
	fi

	# Apply to all files
	find . -type f | grep -v metaconf | egrep -v '\.git' | xargs sed -i "s/$PREFIX$KEY/$VAL/g" 
done

# Vim
git clone git@github.com:tim-clifford/vimrc
./vimrc/install.sh

# Firefox
git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
firefox_dir=$(find $HOME -type d -regex ".*\.mozilla/firefox/.*\.default-release")
mv minimal-functional-fox-dracula "$firefox_dir/chrome"

# Less
lesskey lessrc
