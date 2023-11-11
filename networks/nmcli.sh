nmcli

# 连接wifi
nmcli d wifi connect WIFI_HOTSPOT_NAME password WIFI_PASSWORD

# nmtui 用于curses-based的wifi连接
nmtui

# up/down interface
nmcli connection up "DEVICE NAME"
nmcli connection down "DEVICE NAME"
