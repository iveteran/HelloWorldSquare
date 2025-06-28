# WSL和Windows网络互访设置和测试

## 要从 Windows 访问 WSL 中的服务，关键在于：
1) WSL（特别是 WSL2）运行在一个虚拟网络环境中，有自己的 IP。
2) 你需要让服务绑定到 WSL 的所有接口（0.0.0.0） 或者 WSL的具体IP地址。
3) 然后在 Windows 中通过该 IP 地址访问。
4) 确保防火墙没有拦截端口。
5) 绑定 127.0.0.1 只会让服务监听在 WSL 自己内部，Windows 访问不到。

## WSL访问Windows服务:
Windows权限设置:
以Administrator在PowerShell运行关闭防火墙:
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
重新打开防火墙:
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
或者采用开启防火墙端口的方式:
New-NetFirewallRule -DisplayName "Allow TCP 8080" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

## 测试
1. 测试网络环境
------
WSL(ip a):
eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
  link/ether 00:15:5d:2d:51:ca brd ff:ff:ff:ff:ff:ff
  inet 192.168.178.213/20 brd 192.168.191.255 scope global eth0
     valid_lft forever preferred_lft forever
  inet6 fe80::215:5dff:fe2d:51ca/64 scope link
     valid_lft forever preferred_lft forever
------
Windows(ipconfig):
Ethernet adapter vEthernet (WSL (Hyper-V firewall)):
   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::ec17:407f:dd6e:ad8%58
   IPv4 Address. . . . . . . . . . . : 192.168.176.1
   Subnet Mask . . . . . . . . . . . : 255.255.240.0
   Default Gateway . . . . . . . . . :

2. 测试指令
- Windows访问WSL:
HTTP Server:
WSL: python3 -m http.server 8080 --bind 0.0.0.0
HTTP Client:
Windows(或Cygwin, Msys): curl 192.168.178.213:8080

其它访问测试:
ping 192.168.178.213
telnet 192.168.178.213:8080

- WSL访问Windows:
HTTP Server:
Windows(或Cygwin, Msys): python3 -m http.server 8080 --bind 0.0.0.0
HTTP Client:
WSL: curl 192.168.176.1:8080

其它访问测试:
ping 192.168.176.1
telnet 192.168.176.1:8080
