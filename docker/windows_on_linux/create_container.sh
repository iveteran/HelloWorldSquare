# https://github.com/dockur/windows?tab=readme-ov-file

#docker run -it -rm \
docker run -it \
    --name windows \
    -p 8006:8006 \
    -p 3390:3389/tcp \
    -p 3390:3389/udp \
    --device=/dev/kvm \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    -v "${PWD:-.}/windows:/storage" \
    --stop-timeout 120 \
    dockurr/windows
    #-v "${HOME}/Downloads/os/Windows_11_24H2_x64.iso:/boot.iso" \
