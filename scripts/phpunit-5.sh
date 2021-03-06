#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing PHPUnit"
cd ~
wget -q https://phar.phpunit.de/phpunit-5.7.phar > /dev/null
sudo mv phpunit-5.7.phar /usr/sbin/phpunit
sudo chmod +x /usr/sbin/phpunit
