#!/bin/dash
# Make sure i haven't left any references to my home directory

IFS="
"
files=$(git ls-tree -r master --name-only | grep -v 'README.md' | grep -v metaconf)
for f in $files; do
	if grep "/home/tim" $f --color=always; then
		read -p "$f: " yn
		case $yn in
			[Yy]* ) sed -i 's|/home/tim|$HOME|g' $f; continue;;
			[Nn]* ) continue;;
			[e]*  ) vim $f;;
			*)      echo "Please answer yes or no or edit"; exit 1;
		esac
	fi
done
