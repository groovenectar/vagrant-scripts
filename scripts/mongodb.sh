#!/usr/bin/env bash

# https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing MongoDB"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

sudo apt-get update

sudo apt-get install -y mongodb-org

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
