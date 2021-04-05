#!/bin/sh
cd $HOME/.config/scripts
# idfk about how this code looks
if [ "$(cat currentrotation)" = "0" ]; then
	./rotateright.sh
elif [ "$(cat currentrotation)" = "1" ]; then
	./rotateinverse.sh
elif [ "$(cat currentrotation)" = "2" ]; then
	./rotateleft.sh
elif [ "$(cat currentrotation)" = "3" ]; then
	./rotatenormal.sh
fi
