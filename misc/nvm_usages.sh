# Ref: https://www.sitepoint.com/quick-tip-multiple-versions-node-nvm/

# Install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.35.2/install.sh | bash

# Commands
nvm ls
nvm ls-remote
nvm ls available  # for nvm-windows

nvm install node  # install the latest version
nvm install --lts
nvm install 12.14.1
nvm install v12.14.1 --reinstall-packages-from=10.18.1

nvm uninstall 13.6.0

nvm use node  # switch to the latest Node.js version:
nvm use 13.6.0

nvm alias awesome-version 13.6.0
nvm use awesome-version
nvm unalias awesome-version
nvm alias default 12.14.1

nvm current

nvm run 13.6.0 --version
nvm exec 13.6.0 node --version
nvm which 13.6.0

# Specify a Node Version on a Per-project Basis
# Create a .nvmrc file inside a project and specify a version number,
#  you can cd into the project directory and type nvm use.
#  nvm will then read the contents of the .nvmrc file and use whatever version of Node you specify.
