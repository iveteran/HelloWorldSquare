# base

setw -g xterm-keys on
set -s escape-time 10                     # faster command sequences
set -sg repeat-time 600                   # increase repeat timeout
set -s focus-events on
set -g history-limit 65535
set -g mouse off
set -g mode-keys vi             # copy-mode
set -g status-keys vi           # command prompt
set -g lock-command vlock

# Enable Yazi's image preview to work correctly in tmux, add the following 3 options
#set -g allow-passthrough all
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM

# display

# Configuring the window
set -g base-index 1           # start windows numbering at 1
set -g set-titles on          # set terminal title
setw -g automatic-rename on   # rename window to reflect current program
#set -g renumber-windows on    # renumber windows when a window is closed

# Configuring the pane border
setw -g pane-base-index 1     # make pane numbering consistent with windows
#set -g pane-border-status top
#set -g pane-border-format '#[bold]#{pane_title}#[default]'
#set -g pane-border-style fg=red
#set -g pane-active-border-style 'fg=red,bg=yellow'

set -g display-panes-time 800 # slightly longer pane indicators display time
set -g display-time 1000      # slightly longer status messages display time

# message style
set -g message-style "bg=white,fg=black"
set -g message-command-style "bg=yellow,fg=black"

# activity
set -g monitor-activity on
set -g visual-activity off
