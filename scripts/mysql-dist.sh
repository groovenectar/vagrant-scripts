#!/usr/bin/env bash

github_url="$1"
mysql_root_password="$2"
mysql_create_database="$3"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing MySQL latest distribution version"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_password}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_root_password}"

sudo apt-get -qq install mysql-server > /dev/null

if [[ -n "${mysql_create_database}" ]]; then
	echo ">>> Creating new MySQL database"
	echo "CREATE DATABASE IF NOT EXISTS ${mysql_create_database} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql -u root -p"${mysql_root_password}"  &> /dev/null
fi
