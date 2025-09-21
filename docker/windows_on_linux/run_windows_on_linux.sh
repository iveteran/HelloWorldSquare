# https://github.com/dockur/windows?tab=readme-ov-file

docker run -it --rm \
    --name windows \
    -p 8006:8006 \
    --device=/dev/kvm \
    --device=/dev/net/tun \
    --cap-add NET_ADMIN \
    -v "${HOME}/Downloads/os/Windows_11_24H2_x64.iso:/boot.iso" \
    -v "${PWD:-.}/windows:/storage" \
    --stop-timeout 120 \
    dockurr/windows
