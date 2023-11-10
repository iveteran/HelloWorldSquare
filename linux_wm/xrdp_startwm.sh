#!/bin/sh
# xrdp X session start script (c) 2015, 2017, 2021 mirabilos
# published under The MirOS Licence

# Rely on /etc/pam.d/xrdp-sesman using pam_env to load both
# /etc/environment and /etc/default/locale to initialise the
# locale and the user environment properly.

# NOTE: Put this file to $HOME or /etc/xrdp/startwm.sh

# supports multiple login, 避免在用户已经登入linux桌面的情况下再Windows rdp登录黑屏
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

if test -r /etc/profile; then
	. /etc/profile
fi

if test -r ~/.profile; then
	. ~/.profile
fi

# default is i3
#test -x /etc/X11/Xsession && exec /etc/X11/Xsession
#exec /bin/sh /etc/X11/Xsession

exec /usr/bin/bspwm
#exec /usr/bin/awesome
