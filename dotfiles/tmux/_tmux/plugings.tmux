# Loading pluings without plug manager
#
# Enable tmux-resurrect
run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
set -g @resurrect-capture-pane-contents 'on'
# Enable tmux-continuum
run-shell ~/.tmux/tmux-continuum/continuum.tmux
set -g @continuum-save-interval '60'
#set -g @continuum-boot 'on'
#set -g @continuum-restore 'on' # 启用自动恢复

# Tmux translation plugin powered by popup window.
run-shell ~/.tmux/tmux-translator/main.tmux
set -g @tmux-translator "t"
set -g @tmux-translator-from "en"
set -g @tmux-translator-to "zh"
set -g @tmux-translator-engine "google"

# extrakto for tmux - quickly select, copy/insert/complete text without a mouse 
run-shell ~/.tmux/extrakto/extrakto.tmux
set -g @extrakto_popup_size "70%"
