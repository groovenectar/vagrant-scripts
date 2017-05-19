#!/usr/bin/env bash

github_url="$1"
public_folder="$2"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing Xdebug and Webgrind"

sudo apt-get -qq install php-xdebug > /dev/null
sudo apt-get -qq install graphviz > /dev/null

php_version=$(php -r 'preg_match("#^\d.\d#", PHP_VERSION, $match); echo $match[0];')

{
	echo 'xdebug.profiler_enable = 1' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	echo 'xdebug.var_display_max_depth = 5' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	echo 'xdebug.var_display_max_data = 1024' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	echo 'xdebug.var_display_max_children = 256' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	echo 'xdebug.cli_color = 1' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	echo 'xdebug.overload_var_dump = Off' | sudo tee --append /etc/php/${php_version}/fpm/php.ini
	
	

	echo 'xdebug.profiler_enable = 1' | sudo tee --append /etc/php/${php_version}/cli/php.ini
	echo 'xdebug.var_display_max_depth = 5' | sudo tee --append /etc/php/${php_version}/cli/php.ini
	echo 'xdebug.var_display_max_data = 1024' | sudo tee --append /etc/php/${php_version}/cli/php.ini
	echo 'xdebug.var_display_max_children = 256' | sudo tee --append /etc/php/${php_version}/cli/php.ini
	echo 'xdebug.cli_color = 1' | sudo tee --append /etc/php/${php_version}/cli/php.ini
	echo 'xdebug.overload_var_dump = Off' | sudo tee --append /etc/php/${php_version}/cli/php.ini
} > /dev/null

wget -q https://github.com/jokkedk/webgrind/archive/master.zip > /dev/null
dtrx --one rename --noninteractive --quiet master.zip > /dev/null
sudo mv master /var/www/webgrind
sudo ln -s /var/www/webgrind ${public_folder}/webgrind
rm master.zip

sudo service php${php_version}-fpm restart
