#!/bin/sh
if [ -f .git ]; then
	vim $(sed "s/gitdir://" .git)/index
else
	vim .git/index
fi

