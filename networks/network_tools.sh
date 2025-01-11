lshw -C network

lspci -nnvmm | egrep -A 6 -B 1 -i 'network|ethernet'

ethtool
ethtool ethx       # 查询ethx网口基本设置，其中 x 是对应网卡的编号，如eth0、eth1等等
ethtool –h         # 显示ethtool的命令帮助(help)
ethtool –i ethX    # 查询ethX网口的相关信息
ethtool –d ethX    # 查询ethX网口注册性信息
ethtool –r ethX    # 重置ethX网口到自适应模式
ethtool –S ethX    # 查询ethX网口收发包统计

ip link

nmcli device

# networks traffic/speed monitor
iftop, bmon

# whois, DNS info querier
# apt install whois
whois example.com

# systemd-networkd
systemctl status systemd-networkd
networkctl list
networkctl status

# My Trace Route
mtr -t -b matrix.works
