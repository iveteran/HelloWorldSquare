timedatectl list-timezones  # list
sudo timedatectl set-timezone Asia/Shanghai

# sync
sudo systemctl status ntp
ntpq -p
# OR
# sudo apt install systemd-timesyncd
# sudo systemctl start systemd-timesyncd
