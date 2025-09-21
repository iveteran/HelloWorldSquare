# 重载用户服务
systemctl --user daemon-reload

# 启用开机自启
systemctl --user enable vncserver.service

# 启动服务
systemctl --user start vncserver.service

# 检查状态
systemctl --user status vncserver.service

# 使用户服务在登出后继续运行
sudo loginctl enable-linger $(whoami)
