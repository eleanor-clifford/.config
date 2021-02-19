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
vim=full
link_to_home=true
firefox=true
fish=true
install=true
for i in "$@"; do
	case "$i" in
		--no-link)	     link_to_home=false;;
		--vimrc-minimal) vim=minimal;;
		--vimrc-none)    vim=none;;
		--no-firefox)    firefox=false;;
		--no-fish)       fish=false;;
		--no-install)    install=false;;
		--update)
			vim=update
			firefox=false
			fish=false
			keyboard=false
			install=false
			;;
	esac
done

if $install; then
	# Install AUR helper
	while true; do
		read -p "Install aurutils? " yn
		case $yn in
			[Yy]* )
				git clone https://aur.archlinux.org/aurutils.git
				cd aurutils
				if makepkg -si; then
					cd - >/dev/null
					rm -rf aurutils

					# Stop telling me my shell is disgusting, it's just shell ok?
					echo "
	[custom]
	SigLevel = Optional TrustAll
	Server = file:///home/custompkgs" | sudo tee -a /etc/pacman.conf >/dev/null
					sudo install -d /home/custompkgs -o $USER
					repo-add /home/custompkgs/custom.db.tar.gz
					sudo pacman -Syu
				else
					exit 1
				fi
				break;;
			[Nn]* )
				break;;
			*)
				echo "Please respond";;
		esac
	done

	# Install packages
	INSTALL='sudo pacman -S'
	INSTALL_AUR="aur sync"
	export AUR_PAGER='ls -alF' # just for now so aurutils doesn't fail

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
fi
IFS="
"

# Apply metaconfig
if [ ! -f metaconfig/$(cat /etc/hostname).metaconf ]; then
	echo "No metaconfig defined for this hostname"
	exit 1
fi

PREFIX=''
POSTFIX_FILE_APPEND_PREFIX=''
POSTFIX_FILE_APPENDED=''

echo "====> applying metaconfig variables..."
for line in $(cat "metaconfig/$(cat /etc/hostname).metaconf"); do

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

	if [ "$KEY" = 'POSTFIX_FILE_APPEND_PREFIX' ]; then
		POSTFIX_FILE_APPEND_PREFIX=$VAL
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
if [ "$POSTFIX_FILE_APPEND_PREFIX" = '' ] | [ "$POSTFIX_FILE_APPENDED" = '' ]; then
	echo "file append prefixes must be defined"
	exit 1
fi
POSTFIX_FILE_APPEND="$POSTFIX_FILE_APPEND_PREFIX$(cat /etc/hostname)"

echo "====> applying append files..."
for i in $(find . -type f -name "*$POSTFIX_FILE_APPEND"); do

	orig_file=$(echo "$i" | sed "s/$POSTFIX_FILE_APPEND//")

	if ! [ -f $orig_file ]; then
		echo "====> WARNING: no file to append $i to"
		continue
	fi

	last_append=$(echo "$i" | \
		sed "s/$POSTFIX_FILE_APPEND/$POSTFIX_FILE_APPENDED/")
	if [ -f $last_append ]; then
		if diff $i $last_append > /dev/null; then
			echo "====> skipping $i"
			continue
		fi

		echo "====> found existing append for $orig_file, removing..."
		cp $orig_file "$orig_file.orig"

		# fuck it i would need a gnuism anyway to deal with newlines so may as
		# well use vim
		if ! which vim >/dev/null; then
			echo "====> You need vim for this"
			exit 1
		fi

		vim -u NONE +"s/\n$(cat $last_append)\%$//" +wq $orig_file
		#sed -iz "s/$(cat $last_append)$//" $orig_file
		if diff "$orig_file" "$orig_file.orig" > /dev/null; then
			echo "====> ERROR: failed to remove append from file $orig_file"
			continue
		fi

	fi

	cat $i >> $orig_file
	cp $i $last_append

	echo "====> appended $i to $orig_file"
done

if $link_to_home; then
	# Install dotfiles to $HOME
	for i in $(find . -maxdepth 1 -regex '\.\/\..+'); do
		if echo "$i" | egrep -q ".git|$POSTFIX_FILE_APPENDED|$POSTFIX_FILE_APPEND_PREFIX"; then
			continue
		fi
		fullpath=$(eval echo $(echo $i | sed 's|^\.|$(pwd)|'))
		homepath=$(eval echo $(echo $i | sed 's|.*/\(.*\)$|$HOME/\1|'))
		echo "====> linking $homepath -> $fullpath"
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
		git clone https://github.com/tim-clifford/vimrc
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
		git clone https://github.com/tim-clifford/vimrc
		mv vimrc git
		cd git
	fi

	./install.sh
	cd $wd

elif [ "$vim" = "update" ]; then
	cd "$HOME/.vim"
	git pull origin master
	#./install.sh --update
	cd - >/dev/null
fi

if $firefox; then
	## Firefox
	firefox_dir=$(find $HOME -type d \
		-regex ".*\.mozilla/firefox/.*\.default-release")
	if [ "$firefox_dir" = "" ]; then
		echo "Firefox must be run once before the config can be made, skipping..."
	elif ! [ "$(echo "$firefox_dir" | wc -l)" = "1" ]; then
		echo "Multiple firefox installs located, skipping..."
	else
		echo "Installing firefox theme..."
		if [ -d "$firefox_dir/chrome" ]; then
			cd "$firefox_dir/chrome"
			if git config --get remote.origin.url | grep -q "tim-clifford"; then
				git pull
				cd - >/dev/null
			else
				cd - >/dev/null
				rm -r "$firefox_dir/chrome"
				git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
				mv minimal-functional-fox-dracula "$firefox_dir/chrome"
			fi
		else
			git clone https://github.com/tim-clifford/minimal-functional-fox-dracula
			mv minimal-functional-fox-dracula "$firefox_dir/chrome"
		fi
		echo -n "You must enable toolkit.legacyUserProfileCustomizations.stylesheets "
		echo "to use the custom firefox theme"
	fi
fi

## Less
lesskey lessrc

if $fish; then
	while true; do
		read -p "Change shell to fish? " yn
		case $yn in
			[Yy]* )
				chsh -s /usr/bin/fish
				break;;
			[Nn]* ) break;;
			*)      echo "Please respond"; exit 1;
		esac
	done
fi

if $keyboard; then
	while true; do
		read -p "Install keyboard layout? " yn
		case $yn in
			[Yy]* )
				sudo cp ./colemak-custom/colemak-custom /usr/share/X11/xkb/symbols/
				sudo cp ./colemak-custom/colemak-custom.map.gz /usr/share/kbd/keymaps/i386/colemak/
				break;;
			[Nn]* ) break;;
			*)      echo "Please respond"; exit 1;
		esac
	done
fi

echo "====> Commiting host-specific configuration..."
git add .
git commit -m "METACONF_APPLIED at $(date -u +"%Y-%m-%d %H:%M:%S")"
if ! [ -f ".git/hooks/pre-push" ]; then
	ln -s "$(pwd)/pre-push" "$(pwd)/.git/hooks"
fi
