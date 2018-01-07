#!/usr/bin/env bash

github_url="$1"
hostname="$2"
public_folder="$3"

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing Apache2"
sudo apt-get -qq install apache2 > /dev/null

echo ">>> Configuring Apache2"
sudo usermod -a -G www-data vagrant

echo ">>> Installing SSL"
# http://ishan.co/ssl-vagrant-local
openssl genrsa -out /home/vagrant/${hostname}.key 2048
openssl req -new -x509 -key /home/vagrant/${hostname}.key -out /home/vagrant/${hostname}.cert -days 3650 -subj /CN=${hostname}
sudo a2enmod ssl

sudo wget -q -O /etc/apache2/sites-available/${hostname}.conf ${github_url}/apache2/vagrant.conf
sudo sed -i "s|^\\s*ServerName\s*.*|\\tServerName ${hostname}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*DocumentRoot\s*.*|\\tDocumentRoot ${public_folder}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*SSLCertificateFile\s*.*|\\SSLCertificateFile ${public_folder}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*SSLCertificateKeyFile\s*.*|\\SSLCertificateKeyFile ${public_folder}|" /etc/apache2/sites-available/${hostname}.conf
sudo sed -i "s|^\\s*<Directory\s*.*|\\t<Directory \"${public_folder}\">|" /etc/apache2/sites-available/${hostname}.conf
# sudo ln -sf /etc/apache2/sites-available/${hostname}.conf /etc/apache2/sites-enabled/${hostname}.conf
# The following should perform the task comment on the line above
sudo a2ensite ${hostname}.conf > /dev/null

sudo sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/" /etc/apache2/envvars

sudo a2enmod rewrite > /dev/null

sudo a2dissite 000-default > /dev/null

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
