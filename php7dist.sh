#!/usr/bin/env bash

echo ">>> Installing PHP7.0"
sudo apt-get install -qq php7.0

echo ">>> Installing PHP7.0 modules"
sudo apt-get install -qq php7.0-mcrypt
sudo phpenmod mcrypt

sudo service php7.0-fpm restart
