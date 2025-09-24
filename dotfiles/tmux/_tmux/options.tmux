# base

setw -g xterm-keys on
set -s escape-time 10                     # faster command sequences
set -sg repeat-time 600                   # increase repeat timeout
set -s focus-events on
set -g history-limit 65535
set -g mouse off
set -g mode-keys vi
set -g lock-command vlock

# Enable Yazi's image preview to work correctly in tmux, add the following 3 options
#set -g allow-passthrough all
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM

# display

set -g base-index 1           # start windows numbering at 1
setw -g pane-base-index 1     # make pane numbering consistent with windows

setw -g automatic-rename on   # rename window to reflect current program
#set -g renumber-windows on    # renumber windows when a window is closed

set -g set-titles on          # set terminal title

set -g display-panes-time 800 # slightly longer pane indicators display time
set -g display-time 1000      # slightly longer status messages display time

set -g status-interval 10     # redraw status line every 10 seconds

# message style
set -g message-style "bg=white,fg=black"
set -g message-command-style "bg=yellow,fg=black"

# activity
set -g monitor-activity on
set -g visual-activity off
