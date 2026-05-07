Install command line tools, eg: gcc, clang, git
```
xcode-select --install
```

Install Homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew --prefix
brew update
brew docter
```

Install useful tools:
```
brew install bash
 echo "$(brew --prefix)/bin/bash" | sudo tee -a /etc/shells
 chsh -s "$(brew --prefix)/bin/bash"

brew install bash-completion@2
brew install tmux
brew install iterm2
brew install --cask wezterm
brew install --cask karabiner-elements
brew install clash-verge-rev
brew install lsd
brew install wget
brew install bat        # better cat
brew install ripgrep    # fast grep
brew install fd         # fast find
brew install zoxide     # smart cd
brew install git
brew install chezmoi    # dotfiles manager
```

Install extension tools (optional):
```
brew install --cask drawio  # A graph drawer
brew install timg           # An image viewer on terminal
brew install graphviz
brew install imagemagick
brew install ffmpeg
brew install xquartz        # X.Org server for macOS, used for running GUI apps on remote Linux hosts
```

Install sshfs:
```
brew tap macos-fuse-t/homebrew-cask
brew install fuse-t
brew install fuse-t-sshfs
```

App Store:
Microsoft Outlook/Word/Excel
OneDrive
Windows App (Microsoft Remote Desktop)
NetEase Music
YouDao Translate
VLC
Picview
WeChat
Xcode
#RustDesk
Thincast Remote Desktop Client
Firefox
Thunderbird
ChatGPT
Codex
Claude

Others:
Clash Verge
