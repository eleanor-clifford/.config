#!/bin/sh
pushd "$(dirname "$(dirname "$(realpath "$0")")")"
# jank, whatever
for i in 0 1; do
	if [ $i -eq 0 ]; then
		dir="links/homedir"
		targetdir="$HOME"
		echo "====> applying home directory links..."
		sudo_bin=
	else
		dir="links/rootdir"
		targetdir=""
		echo "====> applying root directory links..."
		# this will prepend if sudo is required. It's jank. whatever.
		sudo_bin=sudo
	fi
	for file in $(find -L $dir -type f); do
		if echo "$file" | egrep -q \
				"METACONF_FILE"
		then
			continue
		fi
		targetpath="$(echo "$file" | sed "s|$dir|$targetdir|")"
		path="$(realpath "$file")"

		$sudo_bin mkdir -p "$(dirname "$targetpath")"
		$sudo_bin ln -sb "$path" "$targetpath"
		echo "  ==> linked $targetpath -> $path"
	done
done
popd
