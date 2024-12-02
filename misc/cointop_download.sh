VERSION=$(curl --silent "https://api.github.com/repos/cointop-sh/cointop/releases/latest" | grep -Po --color=never '"tag_name": ".\K.*?(?=")')
URL="https://github.com/cointop-sh/cointop/releases/download/v$VERSION/cointop-v$VERSION.glibc2.32-x86_64.AppImage"
wget $URL
