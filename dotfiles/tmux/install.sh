if [ ! -e ~/.tmux.conf ]; then
    cp -v _tmux.conf ~/.tmux.conf
else
    echo "File: ~/.tmux.conf exists"
fi
if [ ! -e ~/.tmux ]; then
    cp -v -r _tmux ~/.tmux
else
    echo "Directory: ~/.tmux exists"
fi

if [ ! -e ~/.tmux/tmux-continuum ]; then
    git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/tmux-continuum
fi

if [ ! -e ~/.tmux/tmux-resurrect ]; then
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/tmux-resurrect
fi

if [ ! -e ~/.tmux/extrakto ]; then
    git clone https://github.com/laktak/extrakto ~/.tmux/extrakto
fi

if [ ! -e ~/.tmux/tmux-translator ]; then
    git clone --recurse-submodules https://github.com/iveteran/tmux-translator ~/.tmux/tmux-translator
fi
