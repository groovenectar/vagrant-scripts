#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo ">>> Installing PHP7.1"
sudo apt-get -qq install php7.1 > /dev/null

echo ">>> Configuring PHP7.1"
sudo sed -i "s/max_execution_time = .*/max_execution_time = 180/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/max_execution_time = .*/max_execution_time = 180/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 1024M/" /etc/php/7.1/cli/php.ini

sudo sed -i "s/user = .*/user = vagrant/" /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i "s/group = .*/group = vagrant/" /etc/php/7.1/fpm/pool.d/www.conf

echo ">>> Installing PHP7.1 modules"
sudo apt-get -qq install php7.1-mcrypt > /dev/null
sudo apt-get -qq install php7.1-xml > /dev/null
sudo apt-get -qq install php7.1-mbstring > /dev/null
sudo apt-get -qq install php7.1-mysqli > /dev/null
sudo apt-get -qq install php7.1-curl > /dev/null
sudo apt-get -qq install php7.1-tidy > /dev/null
sudo apt-get -qq install php7.1-gd > /dev/null

# This is probably not necessary
sudo phpenmod mcrypt
sudo phpenmod xml
sudo phpenmod dom
sudo phpenmod simplexml
sudo phpenmod mbstring
sudo phpenmod mysqli
sudo phpenmod curl
sudo phpenmod tidy
sudo phpenmod mcrypt
sudo phpenmod gd

sudo service php7.1-fpm restart

(sudo tee /usr/sbin/phperr <<EOL
#!/usr/bin/env bash
sudo tail -n300 -f /var/log/php7.1-fpm.log
EOL
) &>/dev/null

sudo chmod +x /usr/sbin/phperr
