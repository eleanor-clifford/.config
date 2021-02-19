#!/bin/sh

# Check that there are not unstaged changes
if ! [ "$(git diff)" = "" ]; then
	if [ "$(git log --oneline -1 --no-decorate | awk '{print $2}')" \
			= "METACONF_APPLIED" ]; then
		echo "ERROR: revert host specific configuration and commit first"
		exit 1
	else
		echo "ERROR: please commit changes first"
		exit 1
	fi
else
	if git log --oneline --no-decorate | awk '{print $2}' \
			| grep -q METACONF_APPLIED; then
		echo "ERROR: host specific configurations not properly reverted"
		exit 1
	fi
fi

# default arguments
link_to_home=true
vim=full
for i in "$@"; do
	case "$i" in
		--no-link)	     link_to_home=false;;
		--vimrc-minimal) vim=minimal;;
		--vimrc-none)    vim=none;;
		--no-firefox)    firefox=false;;
		--no-fish)       fish=false;;
	esac
done

# Install packages
INSTALL='sudo pacman -S'
INSTALL_AUR='aur sync'
IFS="#" # Split on the package section comment, don't care that it's hacky
for pkgs in $(cat pkglist.conf); do
	if [ "$pkgs" = "" ]; then continue; fi
	while true; do
	read -p "Install $(echo "$pkgs" | head -n1 | sed 's/^ *//')? " yn
		case $yn in
			[Yy]* )
				# remove comment
				pkgs=$(echo "$pkgs" | tail -n +2)
				if echo "$pkgs" | egrep '^aur/'; then
					eval "$INSTALL_AUR $(echo "$pkgs" | sed -n 's|^aur/||p' | tr '\n' ' ')"
				fi
				eval "$INSTALL $(echo "$pkgs" | sed 's|^aur/||' | tr '\n' ' ')"
				break;;
			[Nn]* )
				break;;
			*)
				echo "Please respond";;
		esac
	done
done
IFS="
"

# Apply metaconfig
if [ ! -f metaconfig/$(hostname).metaconf ]; then
	echo "No metaconfig defined for this hostname"
	exit 1
fi

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
	VAL=$(echo $line | sed -n '
		s/^\([^ ]\+\) *= *\([^ ].*\)/\2/;
		s/\([^\\]\)#.*/\1/; s/^#.*//;
		s/\\#/#/g; s/\s*$//gp
	')

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

	last_append=$(echo "$i" | \
		sed "s/$POSTFIX_FILE_APPEND/$POSTFIX_FILE_APPENDED/")
	echo $last_append
	if [ -f $last_append ]; then
		if diff $i $last_append > /dev/null; then
			echo "===== skipping $i ====="
			continue
		fi

		echo "===== found existing append for $orig_file, removing... ====="
		cp $orig_file "$orig_file.orig"

		# fuck it i would need a gnuism anyway to deal with newlines so may as
		# well use vim
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

if $link_to_home; then
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
fi

if [ "$vim" = "minimal" ]; then
	wd=$(pwd)
	mkdir -p "$HOME/.vim"
	cd "$HOME/.vim"
	if [ -d git ]; then
		cd git
		git pull origin master
	else
		git clone git@github.com:tim-clifford/vimrc
		mv vimrc git
		cd git
	fi

	./make_minimal.sh
	ln -s $(pwd)/.vimrc-minimal $HOME/.vimrc
	cd $wd

elif [ "$vim" = "full" ]; then
	wd=$(pwd)
	mkdir -p "$HOME/.vim"
	cd "$HOME/.vim"
	if [ -d git ]; then
		cd git
		git pull origin master
	else
		git clone git@github.com:tim-clifford/vimrc
		mv vimrc git
		cd git
	fi

	./install.sh
	cd $wd
fi

if $firefox; then
	## Firefox
	firefox_dir=$(find $HOME -type d \
		-regex ".*\.mozilla/firefox/.*\.default-release")
	if [ "$firefox_dir" = "" ]; then
		echo "Firefox not installed, skipping..."
	elif ! [ "$(echo "$firefox_dir" | wc -l)" = "1" ]; then
		echo "Multiple firefox installs located, skipping..."
	else
		if [ -d "$firefox_dir/chrome" ]; then
			cd "$firefox_dir/chrome"
			if git config --get remote.origin.url | grep -q "tim-clifford"; then
				git pull
				cd -
			else
				cd -
				rm -r "$firefox_dir/chrome"
				git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
				mv minimal-functional-fox-dracula "$firefox_dir/chrome"
			fi
		else
			git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
			mv minimal-functional-fox-dracula "$firefox_dir/chrome"
		fi
	fi
fi

## Less
lesskey lessrc

if $fish; then
	## Shell
	read -p "Change shell to fish?: " yn
	case $yn in
		[Yy]* ) chsh -s /usr/bin/fish;;
		[Nn]* ) ;;
		*)      echo "No response, exiting..."; exit 1;
	esac
fi

echo "===== Commiting host-specific configuration... ====="
git add .
git commit -m "METACONF_APPLIED at $(date -u +"%Y-%m-%d %H:%M:%S")"
if ! [ -f ".git/hooks/pre-push" ]; then
	ln -s "$(pwd)/pre-push" "$(pwd)/.git/hooks"
fi
