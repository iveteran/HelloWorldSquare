# set timezone
timedatectl list-timezone
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
apt install keychain
apt install tmux
apt install vim
apt install git
apt install fzf
apt install ripgrep
apt install htop btop bmon iftop iptraf iotop
apt install jq tidy bat  # json formatter, html formatter and text viewer

# clone dot files
su - yuu
git clone https://github.com/iveteran/helloworld
cp helloworld/dotfiles/_gitconfig .gitconfig
cp helloworld/tmux/gpakosz_tmux.conf .tmux.conf
cp helloworld/tmux/gpakosz_tmux.conf.local .tmux.conf.local
cp helloworld/dotfiles/_vimrc .vimrc
cp helloworld/dotfiles/_vimrc.statusline .vimrc.statusline
cp helloworld/dotfiles/_vimrc.vim-plug .vimrc.vim-plug
cp helloworld/dotfiles/_vimrc.vundle .vimrc.vundle
cp helloworld/dotfiles/_vimrc.ycm .vimrc.ycm
cp helloworld/dotfiles/_inputrc .inputrc
cp helloworld/dotfiles/_bash_profile .bash_profile
cp helloworld/dotfiles/_bash_prompt .bash_prompt
cp helloworld/dotfiles/_profile_proxy .profile_proxy
source ~/.bash_profile

# Install vim plugin managers
# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

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
sudo ufw status
sudo ufw enable

# CentOS (firewalld)
firewall-cmd --permanent --zone=public --add-port=24/tcp 

# TTY console setup
sudo dpkg-reconfigure console-setup
