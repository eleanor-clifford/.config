#!/usr/bin/dash
if lpass status | egrep -q '^Not logged in.$'; then
	lpass login tclifford@protonmail.com 2>&1 >/dev/null
fi
lpass show --password $1
