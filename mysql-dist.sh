#!/usr/bin/env bash

github_url="$1"
mysql_root_password="$2"
mysql_create_database="$3"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_password}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_root_password}"

sudo apt-get install mysql-server

[[ -n "${mysql_create_database}" ]] && echo "CREATE DATABSE IF NOT EXISTS ${mysql_create_database} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | mysql -u root username -p"${mysql_root_password}"
