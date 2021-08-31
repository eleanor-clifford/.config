if [ "$(cat /etc/hostname)" = "tim-desktop" ]; then
	echo "please run from laptop"
	exit 1
fi

if ! bluealsa-aplay -l | grep -q 88:D0:39:D7:A8:34; then
	echo "please connect bluetooth headset first"
	exit 1
fi

ssh tim-desktop 'jack_load netmanager -i -c'
ssh tim-desktop 'qjackctl -a ~/.config/jack/tim-desktop-net.xml'
qjackctl -a ~/.config/jack/tim-laptop-net.xml &
sleep 1
alsa_out -d bluealsa &
