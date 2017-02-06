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
sudo apt-get update

echo ">>> Installing base packages"
sudo apt-get install curl unzip git-core ack-grep software-properties-common build-essential dtrx
