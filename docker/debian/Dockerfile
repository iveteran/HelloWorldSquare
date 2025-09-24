FROM debian:latest

# 设置代理环境变量
ENV http_proxy=http://host.docker.internal:7890
ENV https_proxy=http://host.docker.internal:7890
ENV no_proxy=localhost,127.0.0.1,host.docker.internal

# 更新包列表并安装常用工具
RUN apt-get update && apt-get install -y \
    iproute2 \
    iputils-ping \
    procps \
    locales \
    curl \
    wget \
    vim \
    git \
    screen \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /root

CMD ["bash"]
