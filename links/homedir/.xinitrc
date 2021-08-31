#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export EDITOR=/usr/bin/vim
export QT_QPA_PLATFORMTHEME=qt5ct
export MOZ_USE_XINPUT2=1
setxkbmap colemak-custom

session=${2:-i3}
case $session in
	i3              ) exec dbus-launch i3;;
	vm              ) exec /usr/bin/win-vm;;
	rfx             ) exec /usr/bin/win-rfx;;
	remote          ) exec ssh -X tim-manjaro-desktop i3;;
	desktop-vnc     ) $HOME/.config/scripts/setup-vncviewer.sh && exec vncviewer 192.168.1.75 -FullScreen -ViewOnly;;
esac
