#!/bin/bash
# ~/.tmux/modules/status_modules.sh
# tmux 状态栏模块脚本集合

# =============================================================================
# 颜色定义函数
# =============================================================================
space=" "

#primary_bg="colour232"
primary_bg="black"
primary_fg="grey"

get_color() {
    case $1 in
        "main_bg") echo $primary_bg ;;
        "main_fg") echo $primary_fg ;;
        "session_bg") echo "yellow" ;;
        "session_fg") echo $primary_bg ;;
        "uptime_bg") echo "magenta" ;;
        "uptime_fg") echo "white" ;;
        "user_bg") echo "cyan" ;;
        "user_fg") echo "white" ;;
        "host_bg") echo "white" ;;
        "host_fg") echo "black" ;;
        "text_title_fg") echo "blue" ;;
        "text_value_fg") echo $primary_fg ;;
        *_bg) echo $primary_bg ;;
        *_fg) echo $primary_fg ;;
        *) echo $primary_fg ;;
    esac
}

# 生成颜色格式字符串
color_format() {
    local bg=$(get_color "${1}_bg")
    local fg=$(get_color "${1}_fg")
    echo "#[bg=${bg},fg=${fg}]"
}

# =============================================================================
# 左侧状态栏模块函数
# =============================================================================

# 会话信息模块
session_module() {
    local session_name="${1:-$(tmux display-message -p '#S')}"
    local color=$(color_format "session")
    echo "${color} ❐ ${session_name}"
}

# 开机时间模块
uptime_module() {
    local uptime_info=$(get_smart_uptime)
    local color=$(color_format "uptime")
    echo "${color} ↑ ${uptime_info}"
}

# Git 状态模块
git_module() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git_branch)
        local status=""
        
        # 检查工作区状态
        if [[ -n $(git_status) ]]; then
            status="*"
        fi
        
        local color=$(color_format "git")
        echo "${color} ${branch}${status}"
    fi
}

# =============================================================================
# 右侧状态栏模块函数  
# =============================================================================

# 显示触发prefix
prefix_module() {
    echo "#{?client_prefix, ⌨️ ,}"
}

# 时间模块
time_module() {
    local color=$(color_format "datetime")
    local format="${1:-%H:%M}"
    echo "${color}⏰ $(date +"${format}")"
}

# 日期模块
date_module() {
    local color=$(color_format "datetime")
    local format="${1:-%m-%d}"
    echo "${color}📅 $(date +"${format}")"
}

# 用户信息模块
user_module() {
    local color=$(color_format "user")
    local user="${1:-${USER}}"
    echo "${color} 👽 ${user}"
}

# 主机信息模块
host_module() {
    local color=$(color_format "host")
    local hostname="${1:-$(hostname -s)}"
    echo "${color} 🖥️ ${hostname}$space"
}

# CPU 使用率模块
cpu_module() {
    if command -v top >/dev/null 2>&1; then
        local cpu_usage=$(cpu_usage)
        if [[ -n "$cpu_usage" ]]; then
            local t_color=$(color_format "text_title")
            local v_color=$(color_format "text_value")
            echo "${t_color}CPU: ${v_color}${cpu_usage}"
        fi
    fi
}

# 内存使用率模块
memory_module() {
    if command -v free >/dev/null 2>&1; then
        local mem_usage=$(mem_usage)
        local t_color=$(color_format "text_title")
        local v_color=$(color_format "text_value")
        echo "${t_color}MEM: ${v_color}${mem_usage}"
    fi
}

# 网络状态模块
network_module() {
    local interface="${1:-eth0}"
    if ip link show "$interface" >/dev/null 2>&1; then
        local status=$(network_status $interface)
        local icon
        case "$status" in
            "UP") icon="⬆️" ;;
            "DOWN") icon="❌" ;;
            *) icon="❔" ;;
        esac
        local t_color=$(color_format "text_title")
        echo "${t_color}🔗: $icon"
    fi
}

online_module() {
    local status=$(online_status)
    local icon
    case "$status" in
        "online") icon="✅" ;;
        "offline") icon="❌" ;;
        *) icon="❔" ;;
    esac
    local t_color=$(color_format "text_title")
    echo "${t_color}🌐: $icon"
}

weather_module() {
    local location="${1:-"深圳"}"
    local status=$(network_status)
    local result
    case "$status" in
        "UP") result=$(get_weather ${location}) ;;
        "DOWN") result="🚫" ;;
        *) result="🚫" ;;
    esac
    local t_color=$(color_format "text_title")
    local v_color=$(color_format "text_value")
    echo "${t_color}${location}: ${v_color}$result"
}

# =============================================================================
# 组合函数
# =============================================================================

# 生成左侧状态栏
generate_left_status() {
    local modules=()

    modules+=("$(session_module)")
    modules+=("$(uptime_module)$space")
    modules+=($(git_module))

    echo "${modules[*]}"
}

# 生成右侧状态栏
generate_right_status() {
    local modules=()

    modules+=("$(prefix_module)")
    modules+=("$(weather_module)")
    
    # 添加系统监控模块（如果可用）
    [[ -n "$(cpu_module)" ]] && modules+=("$(cpu_module)")
    [[ -n "$(memory_module)" ]] && modules+=("$(memory_module)")
    [[ -n "$(network_module)" ]] && modules+=("$(network_module)")
    [[ -n "$(online_module)" ]] && modules+=("$(online_module)")
    
    # 添加时间，用户和主机信息
    modules+=("$(time_module)")
    modules+=("$(date_module)")
    modules+=("$(user_module)")
    modules+=("$(host_module)")
    
    # 用分隔符连接所有模块
    local IFS=" | "
    echo "${modules[*]}"
}

# 生成简化版右侧状态栏
generate_simple_right_status() {
    local modules=()

    modules+=("$(prefix_module)")
    modules+=("$(weather_module)")
    modules+=("$(online_module)")
    
    # 添加时间，用户和主机信息
    modules+=("$(time_module)")
    modules+=("$(user_module)")
    modules+=("$(host_module)")
    
    # 用分隔符连接所有模块
    local IFS=" | "
    echo "${modules[*]}"
}

# 生成popup窗口左侧状态栏
generate_popup_left_status() {
    local modules=()

    modules+=("$(session_module)")

    echo "${modules[*]}"
}

# 生成popup右侧状态栏
generate_popup_right_status() {
    local modules=()

    modules+=("$(prefix_module)")
    modules+=("$(user_module)$space")
    
    # 用分隔符连接所有模块
    local IFS=" | "
    echo "${modules[*]}"
}

# =============================================================================
# 工具函数
# =============================================================================

# 引入外部脚本
source ~/.tmux/modules/smart_uptime.sh

cpu_usage() {
    echo $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' 2>/dev/null)
}

mem_usage() {
    echo $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
}

network_status() {
    local interface="${1:-eth0}"
    echo $(ip link show "$interface" | grep -o "state [A-Z]*" | cut -d' ' -f2)
}

online_status() {
    #echo $(ping -c 1 1.1.1.1 >/dev/null 2>&1 && printf '✔' || printf '✘')
    echo $(ping -c 1 1.1.1.1 >/dev/null 2>&1 && printf 'online' || printf 'offline')
}

git_branch() {
    echo $(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
}

git_status() {
    echo $(git status --porcelain 2>/dev/null)
}

get_weather() {
    local location=$1
    local cache_file="/tmp/tmux_weather"
    local cache_time=600  # 10分钟

    local now=$(date +%s)
    local last_update_time=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0)

    # 检查缓存是否存在且未过期
    if [[ -f "$cache_file" ]] && [[ $($now - $last_update_time) -lt $cache_time ]]; then
        cat "$cache_file"
    else
        # 获取新的天气数据
        weather=$(curl -f -s -m 4 "wttr.in/$location?format=1" 2>/dev/null || echo 'N/A')
        echo "$weather" > "$cache_file"
        echo "$weather"
    fi
}

# =============================================================================
# 主函数
# =============================================================================
main() {
    case "$1" in
        "left")
            generate_left_status
            ;;
        "right")
            generate_right_status
            ;;
        "simple-right")
            generate_simple_right_status
            ;;
        "popup-left")
            generate_popup_left_status
            ;;
        "popup-right")
            generate_popup_right_status
            ;;
        "session")
            session_module
            ;;
        "time")
            time_module "$2"
            ;;
        "date")
            date_module "$2"
            ;;
        "git")
            git_module
            ;;
        "cpu")
            cpu_module
            ;;
        "memory")
            memory_module
            ;;
        "network")
            network_module "$2"
            ;;
        *)
            echo "用法: $0 {left|right|session|time|date|git|cpu|memory|network} [参数...]"
            echo "示例:"
            echo "  $0 left     # 生成左侧状态栏"
            echo "  $0 right    # 生成右侧状态栏" 
            echo "  $0 git      # 显示 Git 状态"
            echo "  $0 cpu      # 显示 CPU 状态"
            ;;
    esac
}

# 如果脚本被直接执行，调用主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
