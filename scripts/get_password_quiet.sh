#!/usr/bin/dash

# Run with $1: password, $2: failure message

# check whether password is cached
gpg_id="$(cat ~/.password-store/pass-keepassxc/.gpg-id | tr -d '\n')"
keygrip="$(gpg --fingerprint --with-keygrip $gpg_id | grep Keygrip | tail -n1 \
			| sed 's|.*Keygrip = \(.*\)|\1|' | tr -d '\n')"

# KEYINFO <keygrip> <type> <serialno> <idstr> <cached> <protection> <fpr>
# see `gpg-connect-agent 'help keyinfo' /bye
keyinfo="$(gpg-connect-agent "keyinfo $keygrip" /bye | head -n1)"

if echo "$keyinfo" | egrep -q 'KEYINFO ([^ ]+ ){4}1'; then
	echo "$(pass show pass-keepassxc/keepassxc)" \
		| keepassxc-cli show -s -a password \
			~/OneDrive-Personal/passwords.kdbx $1
else
	if [ $# -le 1 ]; then
		ACTION=$(dunstify "Unable to access password \`$1' because GPG key " \
                 "$gpg_id is not unlocked. Right click to unlock." \
				 --action="default,Unlock")

	else
		ACTION=$(dunstify "$2" \
				 --action="default,Unlock")
	fi
	case "$ACTION" in
		"default")
			echo "$($HOME/.config/scripts/get_password.sh $1)"
		    ;;
		"2")
		    ;;
	esac
fi
