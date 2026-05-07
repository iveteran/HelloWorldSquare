export XDG_RUNTIME_DIR=/tmp/runtime-yuu
#mkdir -p $XDG_RUNTIME_DIR
#chmod 700 $XDG_RUNTIME_DIR
export WLR_BACKENDS=headless
export WLR_RENDERER=pixman
export XDG_SESSION_TYPE=wayland

#WLR_BACKENDS=headless WLR_RENDERER=pixman sway
WLR_BACKENDS=headless WLR_RENDERER=pixman dbus-run-session sway
