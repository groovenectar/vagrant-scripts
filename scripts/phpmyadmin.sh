#!/usr/bin/env bash

github_url="$1"
public_folder="$2"
hostname="$3"
server_ip="$4"

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

# Adding configuration options
config="/var/www/phpmyadmin/config.inc.php"
sudo /bin/cat <<EOF >$config
<?php

\$cfg['LoginCookieValidity'] = '10800';
EOF

echo ""
echo ""
echo ""
echo ""
echo ">>> phpMyAdmin installed at URL http://${server_ip}/phpmyadmin or http://${hostname}/phpmyadmin"
echo ""
echo ""
echo ""
echo ""
