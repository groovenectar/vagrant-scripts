#!/usr/bin/env bash

github_url="$1"
hostname="$2"
public_folder="$3"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing Apache2"
sudo apt-get -qq install apache2 libapache2-mod-php > /dev/null

echo ">>> Configuring Apache2"
sudo usermod -a -G www-data vagrant

sudo wget -q -O /etc/apache2/sites-available/${hostname}.conf ${github_url}/apache2/${hostname}.conf
sudo sed -i "s|^\\s*ServerName\s*.*|\\tServerName ${hostname}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*DocumentRoot\s*.*|\\tDocumentRoot ${public_folder}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*<Directory\s*.*|\\t<Directory \"${public_folder}\">|" /etc/apache2/sites-available/${hostname}.conf
sudo ln -sf /etc/apache2/sites-available/${hostname}.conf /etc/apache2/sites-enabled/${hostname}.conf
sudo a2ensite ${hostname}.conf

sudo sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/" /etc/apache2/envvars

sudo a2enmod rewrite

sudo a2dissite 000-default

sudo service apache2 restart

if [[ ${public_folder} != "/var/www/html" ]]; then
	sudo rm -rf /var/www/html
fi

(sudo tee /usr/sbin/weberr <<EOL
#!/usr/bin/env bash
sudo tail -n300 -f /var/log/apache2/error.log
EOL
) &>/dev/null

sudo chmod +x /usr/sbin/weberr