#!/usr/bin/env sh

echo "Via ipinfo.io (使用环境变量http_proxy或https_proxy):"
curl -s ipinfo.io

echo "\n------------------"

echo "Via ipinfo.io (指定Proxy服务地址):"
curl -x http://localhost:7890 -s ipinfo.io

echo "\n------------------"

echo "Via ipip.net:"
curl -s myip.ipip.net
