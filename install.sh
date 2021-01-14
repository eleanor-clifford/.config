#!/bin/dash

# Apply metaconfig
if [ ! -f metaconfig/$(hostname).metaconf ]; then
	echo "No metaconfig defined for this hostname"
	exit 1
fi

IFS="
"
PREFIX=''
POSTFIX_FILE_APPEND=''
POSTFIX_FILE_APPENDED=''

echo "===== applying metaconfig variables... ====="
for line in $(cat "metaconfig/$(hostname).metaconf"); do

	# Parse config
	if echo $line | egrep -q "^\s*#"; then
		continue
	fi

	KEY=$(echo $line | sed -n 's/^\([^ ]\+\) *= *\([^ ].*\)/\1/p')
	VAL=$(echo $line | sed -n 's/^\([^ ]\+\) *= *\([^ ].*\)/\2/;
	                           s/\([^\\]\)#.*/\1/; s/^#.*//;
                               s/\\#/#/g; s/\s*$//gp')

	if [ "$KEY" = '' ]; then
		echo "Syntax Error: $line"
		exit 1
	fi

	if [ "$KEY" = 'PREFIX' ]; then
		PREFIX=$VAL
		continue
	fi

	if [ "$KEY" = 'POSTFIX_FILE_APPEND' ]; then
		POSTFIX_FILE_APPEND=$VAL
		continue
	fi

	if [ "$KEY" = 'POSTFIX_FILE_APPENDED' ]; then
		POSTFIX_FILE_APPENDED=$VAL
		continue
	fi

	if [ "$PREFIX" = '' ]; then
		echo "A prefix must be defined first"
		exit 1
	fi

	# Apply to all files
	find . -type f | grep -v metaconf | egrep -v '\.git' | \
		tr '\n' '\0' | xargs -0 sed -i "s/$PREFIX$KEY/$VAL/g"
done

# Apply file appends
if [ "$POSTFIX_FILE_APPEND" = '' ] | [ "$POSTFIX_FILE_APPENDED" = '' ]; then
	echo "file append prefixes must be defined"
	exit 1
fi

echo "===== applying append files... ====="
for i in $(find . -type f -name "*$POSTFIX_FILE_APPEND"); do
	echo $i

	orig_file=$(echo "$i" | sed "s/$POSTFIX_FILE_APPEND//")
	echo $orig_file

	if ! [ -f $orig_file ]; then
		echo "===== WARNING: no file to append $i to ====="
		continue
	fi

	last_append=$(echo "$i" | sed "s/$POSTFIX_FILE_APPEND/$POSTFIX_FILE_APPENDED/")
	echo $last_append
	if [ -f $last_append ]; then
		if diff $i $last_append > /dev/null; then
			echo "===== skipping $i ====="
			continue
		fi

		echo "===== found existing append for $orig_file, removing... ====="
		cp $orig_file "$orig_file.orig"

		# fuck it i would need a gnuism anyway to deal with newlines so may as well use vim
		if ! which vim; then
			echo "===== You need vim for this ====="
			exit 1
		fi

		vim -u NONE +"s/\n$(cat $last_append)\%$//" +wq $orig_file
		#sed -iz "s/$(cat $last_append)$//" $orig_file
		if diff "$orig_file" "$orig_file.orig" > /dev/null; then
			echo "===== ERROR: failed to remove append from file $orig_file ====="
			continue
		fi

	fi

	cat $i >> $orig_file
	cp $i $last_append

	echo "===== appended $i to $orig_file ====="
done

# Install dotfiles to $HOME
for i in $(find . -maxdepth 1 -name '.*'); do
	fullpath=$(eval echo $(echo $i | sed 's|^\.|$(pwd)|'))
	homepath=$(eval echo $(echo $i | sed 's|.*/\(.*\)$|$HOME/\1|'))
	echo $i $fullpath $homepath
	if [ -L "$homepath" ]; then
		rm "$homepath"
	fi
	if [ -f "$homepath" ]; then
		mv "$homepath" "$homepath.orig"
	fi
	ln -s "$fullpath" $HOME
done

if ! [ "$1" = "--no-install-vimrc" ]; then
	wd=$(pwd)
	mkdir -p "$HOME/.vim"
	cd "$HOME/.vim"
	if [ -d git ]; then
		cd git
		git pull origin master
		./install.sh
	else
		git clone git@github.com:tim-clifford/vimrc
		mv vimrc git
		cd git
		./install.sh
	fi
	cd $wd
fi

## Firefox
git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
firefox_dir=$(find $HOME -type d -regex ".*\.mozilla/firefox/.*\.default-release")
mv minimal-functional-fox-dracula "$firefox_dir/chrome"

## Less
lesskey lessrc
