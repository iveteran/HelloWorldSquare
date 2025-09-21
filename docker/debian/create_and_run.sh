docker run --name my-debian -it debian:latest bash

# 后台运行
#docker run -d --name my-debian debian:latest sleep infinity

# -it: 交互式运行，分配伪终端
# debian:latest: 使用最新的Debian镜像
# bash: 启动bash shell
