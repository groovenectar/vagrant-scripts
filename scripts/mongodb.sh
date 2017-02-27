#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing MongoDB"

# https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update

sudo apt-get -qq install mongodb-org > /dev/null

(sudo tee /etc/systemd/system/mongodb.service <<EOL
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOL
) &>/dev/null

sudo systemctl start mongodb

php_version=$(php -r 'preg_match("#^\d.\d#", PHP_VERSION, $match); echo $match[0];')
sudo apt-get -qq install php-mongodb > /dev/null
sudo phpenmod mongodb
sudo service php${php_version}-fpm restart
