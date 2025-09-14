# refers:
#   https://medium.com/hackernoon/customizing-tmux-b3d2a5050207
#   https://www.baeldung.com/linux/tmux-status-bar-customization
#   https://dev.to/brandonwallace/make-your-tmux-status-line-100-better-with-bash-mgf

set -g window-status-format <options>
set -g window-status-current-format <options>
set-option -g status-position bottom
set-option -g status-interval 5
set -g status-left <options>
set -g status-right <options>

Option value format:
#{?client_prefix,#[bg=colour2],}
#{?window_zoomed_flag, ,🔍}
#(path/to/battery.sh)
