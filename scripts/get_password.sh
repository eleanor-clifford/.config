#!/usr/bin/dash
keepassxc-cli show -s -a password OneDrive-Personal/passwords.kdbx $1
#if lpass status | egrep -q '^Not logged in.$'; then
	#lpass login tclifford@protonmail.com 2>&1 >/dev/null
#fi
#lpass show --password $1
