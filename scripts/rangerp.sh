#!/bin/sh
if which ranger >/dev/null; then
	ranger $1
else
	ls -alF $1
fi
read -p "Press enter to continue or ctrl+d to exit " tmp
