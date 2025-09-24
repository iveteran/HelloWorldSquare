bind a send-prefix
bind ^a last

# clear both screen and history
bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

bind q confirm-before -p "kill-pane #P? (y/n)" killp
bind Q confirm-before -p "kill-window #W? (y/n)" killw

bind x lock-server

bind M-p next-window
bind M-n previous-window

#bind o popup
bind o run-shell 'tmux popup -w 80% -h 80%  -E "tmux attach -t popup || tmux new -s popup"'
bind v display-popup -w "80%" -h "80%" -E "tmux new-session -A -s scratch"

# bind fzf to open popup window
bind f run-shell 'tmux popup -w 80% -h 80% "find ~/projects -type f -not -path \"*/\.*\" -not -path "*__pycache__*" -not -path "*node_mudules*" | fzf --bind \"enter:become(vim {})\""; true'
#bind f run-shell 'tmux popup -w 80% -h 80% "find_project_files | fzf_file_edit"; true'  # run bash aliases or functions

# edit configuration
bind e new-window -n "~/.tmux.conf.local" sh -c '${EDITOR:-vim} ~/.tmux.conf.local && tmux source ~/.tmux.conf && tmux display "~/.tmux.conf sourced"'

# reload configuration
bind r source-file ~/.tmux.conf \; display '~/.tmux.conf sourced'

# 手动刷新状态栏
bind R refresh-client

# -- navigation ----------------------------------------------------------------

# create session
bind C-c new-session

# find session
bind C-f command-prompt -p find-session 'switch-client -t %%'

# session navigation
#bind BTab switch-client -l  # move to last session

# split current window horizontally
unbind '"'
bind - splitw -v
# split current window vertically
unbind %
bind | splitw -h

# pane navigation
bind -r h select-pane -L  # move left
bind -r j select-pane -D  # move down
bind -r k select-pane -U  # move up
bind -r l select-pane -R  # move right
bind > swap-pane -D       # swap current pane with the next one
bind < swap-pane -U       # swap current pane with the previous one

# maximize current pane
bind + run 'cut -c3- ~/.tmux.conf | sh -s _maximize_pane "#{session_name}" #D'

# pane resizing
bind -r H resize-pane -L 2
bind -r J resize-pane -D 2
bind -r K resize-pane -U 2
bind -r L resize-pane -R 2

# window navigation
unbind n
unbind p
bind -r C-h previous-window # select previous window
bind -r C-l next-window     # select next window
bind Tab last-window        # move to last active window

# toggle mouse
bind m run "cut -c3- ~/.tmux.conf | sh -s _toggle_mouse"

# urlview
bind U run "cut -c3- ~/.tmux.conf | sh -s _urlview #{pane_id}"

# copy mode
bind Enter copy-mode # enter copy mode

# buffers
bind b list-buffers     # list paste buffers
bind p paste-buffer -p  # paste from the top paste buffer
bind P choose-buffer    # choose which buffer to paste from

# 切换状态栏显示模式（简单示例）
#bind s if -F '#{s/off//:status}' 'set status off' 'set status on'
