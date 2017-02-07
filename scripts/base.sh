#!/usr/bin/env bash

github_url="$1"
server_swap="$2"

echo ">>> Setting up swap"
sudo fallocate -l ${server_swap}M /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile   none    swap    sw    0   0" | tee -a /etc/fstab

echo ">>> Updating apt"
sudo apt-get -qq update > /dev/null

echo ">>> Installing base packages"
sudo apt-get -qq install curl unzip git-core ack-grep software-properties-common build-essential dtrx > /dev/null

echo ">>> Configuring Git"
curl --silent -L ${github_url}/git/.gitconfig > /home/vagrant/.gitconfig
sudo chown vagrant:vagrant /home/vagrant/.gitconfig

git config --global http.postBuffer 524288000
git config --global credential.helper 'cache --timeout=86400'
