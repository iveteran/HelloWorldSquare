if [ $(tty) == "/dev/tty2" ]; then
    startx $HOME/.xinitrc_bspwm -- :1
    #startx /usr/bin/xdm -- :1
else
    echo "Error: Must run this script on tty2"
fi
