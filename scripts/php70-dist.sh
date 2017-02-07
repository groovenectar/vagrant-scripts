#!/usr/bin/env bash

echo ">>> Installing PHP7.0"
sudo apt-get -qq install php7.0

echo ">>> Configuring PHP7.0"
sudo sed -i "s/max_execution_time = .*/max_execution_time = 180/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/max_execution_time = .*/max_execution_time = 180/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.0/cli/php.ini

echo ">>> Installing PHP7.0 modules"
sudo apt-get -qq install php7.0-mcrypt
sudo phpenmod mcrypt

sudo service php7.0-fpm restart
