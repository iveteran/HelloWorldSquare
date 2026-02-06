# Linux great tools

## Shell
- Bash
- Zsh
- Fish

## Editor
- Vim
 YouCompleteMe
 vim-plug
 vundle
- Neovim
- Helix

## Terminal Multiplexer
- GNU Screen
- Tmux
 TPM
 tmuxifier
- Zellij
- Byobu - slowly

## File Find / Search
- FZF - File Search
- Ripgrep - alternative to Grep
- fdfind(fd) - alternative to find

## File Manager
- Ranger - (by Python)
- Yazi   - (by Rust)
- lf     - (by Golang)
- SuperFile(spf) - (by Golang)
- nnn

## Text-based / Terminal-based browser
- w3m       - https://github.com/tats/w3m - w3m supports to show image with sixel,
                https://apple.stackexchange.com/questions/244930/how-do-i-view-inline-images-in-w3m
- lynx      - Does not support to show image
- elinks
- Brow6el   - Based on Chromium and Sixel, https://www.brow6el.dev/, does not support on Tmux
- Carbonyl  - Based on Chromium
- Browsh    - Based on Firefox

## Window Manager
- Xorg
  - bspwm/sxhkd
  - i3
  - dwm
- Wayland
  - sway
  - river/kwm
  - niri
- Text-based
  - desktop-tui

## WM tools
- polybar/lemonbar
- rofi
- picom        - picom is a compositor for X
- eww          - Elkowars Wacky Widgets is a standalone widget system made in Rust that allows you to implement your own, custom widgets in any window manager.
- QuteBrowser  - A keyboard-driven, vim-like browser based on Python and Qt with a minimal GUI.
- jgmenu       - jgmenu is simple, independent and contemporary-looking X11 menu, designed for scripting, modding and tweaking
- catppuccin   - A theme for a lot of apps, https://github.com/catppuccin/

## Terminal
- fbterm / kmscon - Terminal TTY
- WezTerm   - (by Rust/Lua) 默认字体支持彩色emoji, 有空白边框无法去除(可调整字体大小改善)，vim的background全黑了
- Alacritty - (by Rust) exa/lsd等的unicode icon乱码, 需要安装noto nerd font，不支持多Tab
- Kitty     - (by Golang/Python) 对tmux的支持有问题，tmux的status bar乱了
- foot      - A wayland terminal
- Simple Terminal - st.suckless.org

## Desktop Manager / Login Manager
- Ly        - TUI, A lightweight TUI (ncurses-like) display manager for Linux and BSD, Depends on Xorg, https://github.com/fairyglade/ly
- Ly-DM     - TUI, A fork of Ly, https://github.com/liweitianux/ly-dm
- Lemurs    - TUI, A customizable TUI display/login manager written in Rust, Supports TTY, X11 or Wayland sessions
- tuigreet/greetd   - tuigreet(UI) with greetd(daemon)
- wlgreet/greetd    - wlgreet(Wayland UI) with greetd(daemon)

## Remote Desktop Server/Client
- xrdp      - RDP server for X
- wayvnc    - VNC server for Wayland
- freerdp   - RDP client of X/Wayland

---

## Multimedia
- ffmpeg - Video Editor, supports record, streaming
- imagemagick - Image Editor
- mpv, vlc - Video Player
- MOC(mocp) - Music on console
- mpd/(mpc/ncmpc/ncmpcpp) - Music Player Daemon and cliens
- pipewire - New multimedia frameworks for Linux
- Cava - Cross-platform Audio Visualizer
- YesPlayMusic - Music client on Linux of NetEase Cloud Music
- go-musicfox - TUI music client on Linux/MacOS of NetEase Cloud Music

## Shotcut
- Flameshot
- scrot
- ImageMagick(import)

## Image viewer
- feh
- ImageMagick(display)

## Image viewer in terminal/console
- timg
- wezterm imgcat
- chafa
- catimg

## Email client
- mutt/neomutt
- Thunderbird
- aerc - https://git.sr.ht/~rjarry/aerc, *The BEST one for TUI*
- meli - https://git.meli-email.org/meli/meli

## Webmail clients
- snappymail
- roundcube

## Email clients - support JMAP
- aerc: A terminal email client for the discerning hacker.
- Cypht: (PHP, JS) Lightweight Open Source webmail aggregator
- Group-Office (Javascript): Open source groupware and collaboration platform
- JMAP Demo Webmail (JavaScript, MIT): a sophisticated demo webmail client to be used as a base for new projects.
- JMAP::Tester (Perl, Perl5): a JMAP client made for testing JMAP servers.
- Ltt.rs (Java, Apache): an email client for Android
- Mailtemi: a native iOS/Android email client
- mjmap (Go, MPL-2.0): A sendmail-compatible command line JMAP client.
- meli (Rust): terminal email client (GPLv3)
- mujmap (Rust): Synchronize JMAP mail with notmuch
- Parula: Full email app with chat, video conference and calendar. For Windows, macOS, Linux.
- Swift Mail: A native macOS client for JMAP
- Twake Mail Client (Dart): Android, iOS and web client

## System tools
- bmon, btop, atop - System Monitor

## Task Manager
- taskwarrior - Task Manager
- timewarrior - Time Manager

## Calendar
- khal - https://github.com/pimutils/khal
- calcurse - https://calcurse.org/

## RSS
- newsboat - RSS Reader

## Securities
- gnugp - private key manager
- pass - password manager
- keepass/keepassxc  - password manager
- cryfs - crypt fs
- cryptomator - disk/files encrypt
- firejail - sandbox
- unshare - run program in new namespaces

## Graph Drawer
- Drawio
- Mermaid
- flowchart.js
- Excalidraw

---

## Utilities
- zoxide - A smarter cd command
- exa/lsd - Better ls tools
- netcat - socket client
- socat - advanced socket client
- bat - text viewer
- jq - json formatter/viewer
- tabiew(tw) - csv/tsv viewer, https://github.com/shshemi/tabiew
- tidy - html formatter
- litecli - SQLite client
- ranger - file manager
- qmv - batch rename files
- slides - markdown viewer
- hike - markdown browser
- frogmouth - markdown browser
- navi - An interactive cheatsheet tool for the command-line
- translate-shell - A Translate, supports Google Translate、Microsoft Translator、Yandex
- hexyl - A hex viewer for the terminal
- binsider - A ELF file parser
- delta - diff tool, used for git, https://github.com/dandavison/delta
- cointop - cryptocurrency coin stats in real-time
- starship - cross-shell prompt
- lolcat - show text in rainbow colors, e.g.: cowsay -f tux ☛ Tecmint ☚ is the best Linux Blog | lolcat
- showrgb/colortest - show colors
- ueberzugpp - image viewer on terminal
- ncdu, dua-cli(tui), baobab(gui) - disk space usage analyzer
- tldr, https://github.com/tldr-pages/tldr
- graphicsmagick, svg and gif view
- termpicker, A simple Color Picker Designed for your Terminal, Install: go install github.com/ChausseBenjamin/termpicker@latest
- tig, A TUI mode git client
- duf, A disk usage/free utility
- kanban-tui, A customizable task manager in the terminal
- RustDesk, An open-source remote desktop application designed for self-hosting, as an alternative to TeamViewer.
- ticker, Terminal stock & crypto price watcher and position tracker, https://github.com/achannarasappa/ticker
