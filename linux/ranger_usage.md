# Ranger Usage

Refers:
  https://github.com/ranger/ranger/wiki/Official-user-guide
  https://blog.csdn.net/lxyoucan/article/details/115671189
  https://www.bilibili.com/video/BV1up4y1b7iJ/

## Install
apt install ranger

## Install Optional packages
apt install highlight   # for preview text file with highlight
apt install w3m-img     # for preview images
apt install atool       # for preview zip/gz/bz/... files
apt install 7zip        # for preview 7z files, "cd /usr/bin && ln -s 7zz 7z"
apt install rar         # for preview rar files
apt install ffmpegthumbnailer   # for preview videos

## Generate default config
ranger --copy-config=[all|scope|rifle|rc]

## File icons for the Ranger file manager
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> ~/.config/ranger/rc.conf

## Command hints show up whenever a mapping has multiple continuations:
g           -  navigation and tabs
r           -  :open_with command
y           -  yank(copy)
d           -  cut/delete
p           -  paste
o           -  sort
.           -  filter_stack
z           -  changing settings
u           -  "undo"
M           -  linemode
+, -, =     -  setting access rights to files

## Open new tab
alt + NUM           - create/select tab, example: alt + 2, alt + 3
tab / shift + tab   - switch tab

## Useful shortcuts
q       - quit
Q       - quit all
ZZ      - quit
ZQ      - quit
R       - reload
F       - freeze (make file/directory read only)
i       - toggle to display/undisplay file
?       - help
S       - open a shell
f       - find
/       - search

cw      - rename file
a       - rename file, append mode
yy      - copy
dd      - delete/cut
pp      - paste

v       - select all files
V       - select current file
Space   - select/unselect current file

cd      - change directory
gg      - move to page top
G       - move to page bottom

gh      - goto /home/<USER>
ge      - goto /etc
gu      - goto /user
gd      - goto /dev
go      - goto /opt
g/      - goto /

j/k     - move Down/Up a line
J/K     - move Down/Up half page
h/l     - goto up directory / enter directory
[/]     - move parent 1 / -1
H       - show/unshow hidden files
E/Enter - Edit file

gn      - create new tab
gc      - close tab

.d      - set filter: only show directories
.f      - set filter: only show files
.c      - clear filters

zp      - show/unshow preview file
zP      - show/unshow preview directory
zh      - show/unshow hidden files
zf/zz   - open filter console

Alt - j/k   - scroll down/up preview content

Ctrl + r    - reset
Crtl + l    - refresh

F1      - help
F2      - rename
F3      - display file
F4      - edit file
F5      - copy file
F6      - cut file
F7      - mkdir
F8      - delete
