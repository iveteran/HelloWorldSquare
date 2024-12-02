# Ueberzugpp Usage

## Remove ueberzug(a python verion):
sudo apt remove ueberzug

## Install:
Refers: [
  https://github.com/jstkdng/ueberzugpp
  https://software.opensuse.org/download.html?project=home%3Ajustkidding&package=ueberzugpp
]

echo 'deb http://download.opensuse.org/repositories/home:/justkidding/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:justkidding.list
curl -fsSL https://download.opensuse.org/repositories/home:justkidding/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg > /dev/null
sudo apt update
sudo apt install ueberzugpp
