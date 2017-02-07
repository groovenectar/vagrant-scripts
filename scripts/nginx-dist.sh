#!/usr/bin/env bash

github_url="$1"
hostname="$2"
public_folder="$3"

echo ">>> Installing nginx"
sudo apt-get install -qq nginx

echo ">>> Configuring nginx"
sudo usermod -a -G www-data vagrant
sudo sed -i "s/user www-data;/user vagrant;/" /etc/nginx/nginx.conf
sudo sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sudo wget -O /etc/nginx/nginx.conf ${github_url}/nginx/nginx.conf
sudo wget -O /etc/nginx/fastcgi_params ${github_url}/nginx/fastcgi_params
sudo wget -O /etc/nginx/fastcgi.conf ${github_url}/nginx/fastcgi_params

sudo wget -O /etc/nginx/sites-available/default ${github_url}/nginx/default
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

sed -i "s|^\\s*server_name\s*.*|\\tserver_name ${hostname};|" /etc/nginx/sites-available/default
sed -i "s|^\\s*root\s*.*|\\troot ${public_folder};|" /etc/nginx/sites-available/default

sudo service nginx restart
