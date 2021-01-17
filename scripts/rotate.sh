cd /home/tim/scripts
# idfk about how this code looks
if [[ $(cat currentrotation) -eq "0" ]]; then
	./rotateright.sh
elif [[ $(cat currentrotation) -eq "1" ]]; then
	./rotateinverse.sh
elif [[ $(cat currentrotation) -eq "2" ]]; then
	./rotateleft.sh
elif [[ $(cat currentrotation) -eq "3" ]]; then
	./rotatenormal.sh
fi
