#!/bin/bash
#vpnserver="vpn.idirect.net"
vpnserver="208.226.76.25"
# connect to vpn at 
#openconnect -b -s /etc/vpnc/vpnc-script --authgroup=Pioneer $vpnserver</etc/myvpn.conf
sudo /usr/local/sbin/openconnect -b --no-cert-check --authgroup=Pioneer --reconnect-timeout=500 $vpnserver </etc/myvpn.conf
