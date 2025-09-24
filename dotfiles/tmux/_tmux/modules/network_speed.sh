#!/bin/bash
# ~/.config/tmux/scripts/network_speed.sh

get_network_speed() {
    interface="${1:-eth0}"
    cache_file="/tmp/tmux_net_${interface}"

    # 获取当前流量数据
    rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes 2>/dev/null || echo 0)
    tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes 2>/dev/null || echo 0)
    current_time=$(date +%s)

    # 读取缓存数据
    if [[ -f "$cache_file" ]]; then
        read prev_rx prev_tx prev_time < "$cache_file"

        # 计算速度
        time_diff=$((current_time - prev_time))
        if [[ $time_diff -gt 0 ]]; then
            rx_speed=$(( (rx_bytes - prev_rx) / time_diff ))
            tx_speed=$(( (tx_bytes - prev_tx) / time_diff ))

            # 格式化输出
            if [[ $rx_speed -gt 1048576 ]]; then
                rx_display="$((rx_speed / 1048576))M"
            elif [[ $rx_speed -gt 1024 ]]; then
                rx_display="$((rx_speed / 1024))K"
            else
                rx_display="${rx_speed}B"
            fi

            if [[ $tx_speed -gt 1048576 ]]; then
                tx_display="$((tx_speed / 1048576))M"
            elif [[ $tx_speed -gt 1024 ]]; then
                tx_display="$((tx_speed / 1024))K"
            else
                tx_display="${tx_speed}B"
            fi

            echo "${rx_display}/s:${tx_display}/s"
        else
            echo "0B/s:0B/s"
        fi
    else
        echo "0B/s:0B/s"
    fi

    # 保存当前数据
    echo "$rx_bytes $tx_bytes $current_time" > "$cache_file"
}
