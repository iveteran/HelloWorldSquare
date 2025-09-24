docker run -it \
    --name mydebian \
    --hostname mydebian \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v "/opt/yuu/docker_vms/mydebian/home:/home" \
    yuu-debian13 \
    bash
    #debian:latest \

# 后台运行
#docker run -d --name my-debian debian:latest sleep infinity

# -it: 交互式运行，分配伪终端
# debian:latest: 使用最新的Debian镜像
# bash: 启动bash shell
