#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing Composer"
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# This will not be feasible without scraping the the composer download page
# php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php > /dev/null
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/sbin/composer
