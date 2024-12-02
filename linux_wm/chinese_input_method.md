# Chinese input Method

## ibus
Refers:
  https://wiki.archlinux.org/title/IBus
  https://unix.stackexchange.com/questions/465452/switch-to-another-input-method

### Install:
apt install ibus ibus-pinyin

### Setup
ibus-setup

### Run:
bus-daemon -rxRd

### Usage:
Ctrl + Shift + Space

### Add below lines to ~/.xinitrc or ~/.bashrc
GTK_IM_MODULE=xim
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus

## fcitx

### Install
apt install fcitx fcitx-pinyin fcitx-table fcitx-table-wubi

### Run
fcitx -d

## select input method
edit ~/.xinputrc (Or run command im-config):
run_im fcitx
#run_im ibus
