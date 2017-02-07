#!/usr/bin/env bash

github_url="$1"
public_folder="$2"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing phpMyAdmin"

cd ~
wget -q https://github.com/phpmyadmin/phpmyadmin/archive/master.zip > /dev/null
dtrx --one rename --noninteractive --quiet master.zip > /dev/null
rm master.zip
sudo mv master /var/www/phpmyadmin
sudo ln -s /var/www/phpmyadmin ${public_folder}/phpmyadmin
cd /var/www/phpmyadmin
composer -q install > /dev/null
