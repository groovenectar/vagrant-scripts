#!/usr/bin/env bash

github_url="$1"

echo ">>> Installing NPM and Node"

cd ~
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh > /dev/null
sudo bash nodesource_setup.sh > /dev/null
sudo apt-get -qq install nodejs > /dev/null
# :(
sudo rm /usr/bin/node
sudo ln -s /usr/bin/nodejs /usr/bin/node

if [[ -f "/home/vagrant/.profile" ]]; then
    # Add new NPM Global Packages location to PATH (.profile)
    printf "\n# Add new NPM global packages location to PATH\n%s" 'export PATH=$PATH:~/npm/bin' >> /home/vagrant/.profile

    # Add new NPM root to NODE_PATH (.profile)
    printf "\n# Add the new NPM root to NODE_PATH\n%s" 'export NODE_PATH=$NODE_PATH:~/npm/lib/node_modules' >> /home/vagrant/.profile
fi
