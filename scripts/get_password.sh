#!/usr/bin/dash
echo "$(pass show pass-keepassxc/keepassxc)" \
	| keepassxc-cli show -s -a password ~/OneDrive-Personal/passwords.kdbx $1 \
	2>/dev/null
