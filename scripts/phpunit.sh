#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing PHPUnit"
cd ~
wget -q https://phar.phpunit.de/phpunit.phar > /dev/null
sudo mv phpunit.phar /usr/sbin/phpunit
