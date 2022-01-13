data="$(sudo ip netns exec camvpn sudo -u tim ldapsearch -x -LLL \
	-H ldaps://ldap.lookup.cam.ac.uk \
	-b "ou=people, o=University of Cambridge,dc=cam,dc=ac,dc=uk" \
	givenName cn sn mail uid | sed -z 's|\n\n||g')"

IFS="" # jaaaaaaaaaaaaank

template="$(khard template)"

for person in $data; do
	uid="$(echo "$person" | sed -n 's|uid: ||p')"
	mail="$(echo "$person" | sed -n 's|mail: ||p')"
	cn="$(echo "$person" | sed -n 's|cn: ||p')"
	givenName="$(echo "$person" | sed -n 's|givenName: ||p')"
	sn="$(echo "$person" | sed -n 's|sn: ||p')"

	# build the data into khard
	if [ "$givenName" != "" ] && [ "$sn" != "" ]; then
		formattedName="$givenName $sn"
	else
		formattedName="$cn"
	fi
	if [ "$mail" = "" ]; then
		mail="${uid}@cam.ac.uk"
	fi
	# BEGIN... allows multiline parsing, m makes ^ and $ work with newlines,
	# and s makes . match newlines
	# pre-format $mail to fix the @
	mail="$(echo $mail | sed 's|@|\\@|')"
	khardfile="$(echo "$template" \
		| perl -pe 'BEGIN{undef $/;} s|(Email.*?work ?:)|\1 '"$mail"'|smg' \
		| perl -pe 's|(Formatted name *:)|\1 '"$formattedName"'|g' \
		| perl -pe 's|(First name *:)|\1 '"$givenName"'|g' \
		| perl -pe 's|(Last name *:)|\1 '"$sn"'|g' \
		| perl -pe 's|(CRSid *:)|\1 '"$uid"'|g' \
		| perl -pe 's|(Organisation *:)|\1 University of Cambridge|g')"
	echo "$khardfile" | khard new --addressbook cam
done

