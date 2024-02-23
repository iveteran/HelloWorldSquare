# set timezone
timedatectl set-timezone Asia/Shanghai
# set hostname
hostname HOSTNAME
# add main user and add it to sudo group
adduser USERNAME
usermod -a -G sudo USERNAME  # Debian like OS
usermod -a -G wheel USERNAME # CentOS like OS

# update system
apt udpate
apt upgrade

# install top tools
apt install tmux
apt install vim
apt install git

# clone dot files
su - yuu
git clone https://github.com/iveteran/helloworld
cp helloworld/myconfig/_gitconfig .gitconfig
cp helloworld/tmux/gpakosz_tmux.conf .tmux.conf
cp helloworld/tmux/gpakosz_tmux.conf.local .tmux.conf.local
cp helloworld/myconfig/_vimrc .vimrc
cp helloworld/myconfig/_vimrc.statusline .vimrc.statusline
cp helloworld/myconfig/_inputrc .inputrc
cp helloworld/myconfig/_bash_profile .bash_profile
source ~/.bash_profile

# ssh client setup - passwordless login, NOTE: on client machine
ssh-copy-id -i ~/.ssh/iv.id_rsa.pub HOST

# ssh server setup
Edit /etc/ssh/sshd_config, add or modify below lines:
> Port 24   # CentOS Stream 9, Failed: error: Bind to port 24 on 0.0.0.0 failed: Permission denied. MUST disable SELinux: setenforce 0 OR modify rule of SELinux
> PermitRootLogin no
> PasswordAuthentication no
sudo systemctl restart sshd

# (CentOS) SELinux, add another port to SELinux policy for sshd
# Refer: https://www.esds.co.in/kb/how-do-i-change-ssh-port-in-red-hat-enterprise-linux/
#        https://zhuanlan.zhihu.com/p/165974960
$ sestatus OR getenforce # show SELinux status
$ sudo semanage port -l | grep ssh
ssh_port_t                     tcp      22
$ sudo semanage port -m -t ssh_port_t -p tcp 24
$ sudo semanage port -l | grep ssh
ssh_port_t                     tcp      24, 22

# firewall (ufw)
sudo apt install ufw
sudo ufw allow 24/tcp comment 'replacement port of sshd'

# CentOS (firewalld)
firewall-cmd --permanent --zone=public --add-port=24/tcp 
