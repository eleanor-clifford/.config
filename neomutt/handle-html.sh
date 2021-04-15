#!/bin/sh
cat /dev/stdin | w3m -I 'utf-8' -T text/html > /tmp/neomutt-w3m.txt
if grep -q "BEGIN PGP" /tmp/neomutt-w3m.txt; then
	gpg --decrypt /tmp/neomutt-w3m.txt
else
	cat /tmp/neomutt-w3m.txt
fi
