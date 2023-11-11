# iw
# 管理无线网络设备，还能更改配置，属于比较全能的命令。
# 缺点：实测对USB网卡支持性很差，几乎只适用于物理接入设备（PCI板载设备）
iw list  # 查看本机支持的无线特性，such as band information (2.4 GHz, and 5 GHz), and 802.11n information
iw dev wlan0 scan # 扫描无线网络，列表的内容都是实时更新的
iw dev wlan0 link # 获取设备连接状态信息（实测不包含IP地址）
iw wlan0 info # 获取设备工作状态信息
iw event # 获取所有网络设备的工作日志信息

# iwlist命令
iwlist  # Get more detailed wireless information from a wireless interface

# iwconfig命令
# 和ifconfig是同级别的用户级管理工具，但专注于无线网络管理
iwconfig

# wpa_supplicant命令
# 该命令可用于WPA/WPA2-PSK/WEP加密网络的连接管理，现代WI-FI环境必备
wpa_supplicant  # Wi-Fi Protected Access client and IEEE 802.1X supplicant

# nmcli
nmcli device
nmcli connection

# nmtui, numcli的ncurses界面版本
nmtui
