# Tmux status line config
set -g status on
set -g status-interval 2  # 每2秒更新一次，适合动态内容
set -g status-position bottom
set -g status-left-length 150
set -g status-right-length 200
#set -g status-style bg=black,fg=white
set -g status-style bg=colour232,fg=grey  # bg: dark black

# =============================================================================
# 窗口状态栏
# =============================================================================
set -g window-status-format " #I#F #W "
set -g window-status-current-format "#[fg=colour232,bg=blue,bold] #I #W #[default]"
setw -g window-status-last-style "fg=blue,bg=#303030"  # bg: gray

# =============================================================================
# 使用外部脚本模块化状态栏
# =============================================================================
# 设置脚本路径
#set -g @module_script "~/.config/tmux/modules/status_modules.sh"
set -g @module_script "~/.tmux/modules/status_modules.sh"
set -g @ifname "wlp3s0"

# 单行状态栏
#set -g status on
#set -g status-left "#(#{@module_script} left)"
#set -g status-right "#(#{@module_script} right #{@ifname})"

# 两行状态栏, 全局窗口statusline
set -g status 2
#set -g status-format[0] "#[align=centre]#{W:#{E:window-status-format},#{E:window-status-current-format}}"
#set -g status-format[1] "#[align=left]#(#{@module_script} left)"
#set -ag status-format[1] "#[align=right]#[bg=black]#{p50: }#(#{@module_script} right #{@ifname})"

# 根据状态栏行数和会话名称动态设置状态栏
if -F "#{==:#{status},on}" {
    # 单行statusline版本
    set-hook -g session-created {
        #display-message "session-created: #{session_name}"
        if-shell -F '#{==:#{session_name},popup}' {
            # 设置popup窗口statusline
            set -t popup status-left "#(#{@module_script} popup-left)"
            set -t popup status-right "#(#{@module_script} popup-right #{@ifname})"
        } {
            # 设置主窗口statusline
            set -w status-left "#(#{@module_script} left)"
            #set -w status-right "#(#{@module_script} right)"
            set -w status-right "#(#{@module_script} simple-right #{@ifname})"
        }
    }
} {
    # 两行statusline版本
    set-hook -g session-created {
        #display-message "session-created: #{session_name}"
        if-shell -F '#{==:#{session_name},popup}' {
            # popup窗口重置为单行statusline
            set -t popup status off
            set -t popup status on
            # 设置popup窗口极简版statusline
            set -t popup status-format[0] "#[align=left][#S]"
            set -at popup status-format[0] "#[align=centre]#{W:#{E:window-status-format},#{E:window-status-current-format}}"
            set -at popup status-format[0] "#[align=right][${USER}]"
        } {
            # 设置主窗口statusline
            set -w status-format[0] "#[align=centre]#{W:#{E:window-status-format},#{E:window-status-current-format}}"
            set -w status-format[1] "#[align=left]#(#{@module_script} left)"
            set -aw status-format[1] "#[align=right]#[bg=black]#{p50: }#(#{@module_script} right #{@ifname})"
        }
    }
}
