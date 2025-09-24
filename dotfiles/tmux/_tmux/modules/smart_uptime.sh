#!/bin/bash
get_smart_uptime() {
    # 获取系统运行时间（秒）
    if [[ -f /proc/uptime ]]; then
        # Linux 系统
        uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
    elif command -v sysctl >/dev/null 2>&1; then
        # macOS 系统
        boot_time=$(sysctl -n kern.boottime | sed 's/.*sec = \([0-9]*\).*/\1/')
        current_time=$(date +%s)
        uptime_seconds=$((current_time - boot_time))
    else
        # 备用方法：解析 uptime 命令输出
        uptime_output=$(uptime)
        if [[ $uptime_output =~ ([0-9]+)\ day ]]; then
            days=${BASH_REMATCH[1]}
            uptime_seconds=$((days * 86400))
        elif [[ $uptime_output =~ ([0-9]+):([0-9]+) ]]; then
            hours=${BASH_REMATCH[1]}
            minutes=${BASH_REMATCH[2]}
            uptime_seconds=$((hours * 3600 + minutes * 60))
        else
            echo "N/A"
            return
        fi
    fi

    # 时间单位常量
    local year_seconds=31536000   # 365 * 24 * 60 * 60
    local month_seconds=2592000   # 30 * 24 * 60 * 60  
    local day_seconds=86400       # 24 * 60 * 60
    local hour_seconds=3600       # 60 * 60
    local minute_seconds=60

    # 根据时长选择合适的单位显示
    if [[ $uptime_seconds -ge $year_seconds ]]; then
        # 大于等于1年：显示年数
        years=$((uptime_seconds / year_seconds))
        remainder=$((uptime_seconds % year_seconds))
        months=$((remainder / month_seconds))
        
        if [[ $months -gt 0 ]]; then
            echo "${years}y${months}m"
        else
            echo "${years}y"
        fi
        
    elif [[ $uptime_seconds -ge $month_seconds ]]; then
        # 大于等于1个月：显示月数
        months=$((uptime_seconds / month_seconds))
        remainder=$((uptime_seconds % month_seconds))
        days=$((remainder / day_seconds))
        
        if [[ $days -gt 0 ]]; then
            echo "${months}mo${days}d"
        else
            echo "${months}mo"
        fi
        
    elif [[ $uptime_seconds -ge $day_seconds ]]; then
        # 大于等于1天：显示天数
        days=$((uptime_seconds / day_seconds))
        remainder=$((uptime_seconds % day_seconds))
        hours=$((remainder / hour_seconds))
        
        if [[ $hours -gt 0 ]]; then
            echo "${days}d${hours}h"
        else
            echo "${days}d"
        fi
        
    elif [[ $uptime_seconds -ge $hour_seconds ]]; then
        # 大于等于1小时：显示小时数
        hours=$((uptime_seconds / hour_seconds))
        remainder=$((uptime_seconds % hour_seconds))
        minutes=$((remainder / minute_seconds))
        
        if [[ $minutes -gt 0 ]]; then
            echo "${hours}h${minutes}m"
        else
            echo "${hours}h"
        fi
        
    else
        # 小于1小时：显示分钟数
        minutes=$((uptime_seconds / minute_seconds))
        if [[ $minutes -gt 0 ]]; then
            echo "${minutes}m"
        else
            echo "<1m"
        fi
    fi
}
