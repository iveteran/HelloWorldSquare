# Refers:
#   SSHuttle: A VPN-Like Tool for Secure Traffic Routing
#     https://linuxconfig.org/sshuttle-a-vpn-like-tool-for-secure-traffic-routing
#
#ssh -p24 -i ~/.ssh/iv.id_rsa -D 1081 -E ssh-tunnel.log -N -f mwx-us  #yuu@vpn.iveteran.me
#ss -nltp | grep 1081
#ssh -p24 -i ~/.ssh/iv.id_rsa -D 1081 -vvv -N yuu@vpn.iveteran.me

#sshuttle -vr yuu@vpn.iveteran.me 0/0 --dns --ssh-cmd 'ssh -p24 -i ~/.ssh/iv.id_rsa'
sshuttle -vr yuu@mwx-us 0/0 --dns --ssh-cmd 'ssh -p24 -i ~/.ssh/iv.id_rsa'
