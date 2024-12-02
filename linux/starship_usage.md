# Starship Usage

## Install
cargo install starship
OR:
curl -sS https://starship.rs/install.sh | sh
OR:
wget https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz
tar xvf starship-x86_64-unknown-linux-musl.tar.gz && mv starship ~/.local/bin

## Themes
starship preset gruvbox-rainbow -o ~/.config/starship.toml
#starship preset tokyo-night -o ~/.config/starship.toml
#starship preset pastel-powerline -o ~/.config/starship.toml

## Show prompt
starship prompt

## Enable
eval "$(starship init bash)"
