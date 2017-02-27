#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing Redis"

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04

sudo apt-get -qq install tcl > /dev/null

cd /tmp

curl -O http://download.redis.io/redis-stable.tar.gz > /dev/null

dtrx redis-stable.tar.gz

cd redis-stable

make &> /dev/null

(make test && sudo make install) > /dev/null

sudo mkdir /etc/redis

sudo cp /tmp/redis-stable/redis.conf /etc/redis

sudo sed -i "s/supervised no/supervised systemd/" /etc/redis/redis.conf
sudo sed -i "s#dir \.\/#dir \/var\/lib\/redis#" /etc/redis/redis.conf

(sudo tee /etc/systemd/system/redis.service <<EOL
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
EOL
) &>/dev/null

sudo adduser --system --group --no-create-home redis

sudo mkdir /var/lib/redis

sudo chown redis:redis /var/lib/redis

sudo chmod 770 /var/lib/redis

sudo systemctl start redis
