# -*- mode: ruby -*-
# vi: set ft=ruby :

# Specify hostname -- need to update the OS hosts file to use this, otherwise use IP
hostname = "vagrant.local"

# The guest VM folder that will be the root of the project files (can be outside webserver document root)
synced_folder = "/var/www/#{hostname}"

# The guest VM folder that will be the webserver document root (e.g. /var/www/#{hostname}/public)
public_folder = "/var/www/#{hostname}/public"

# Guest VM IP address -- Change this if you will have multiple boxes running at once
server_ip = "192.168.33.94"

# Configure MySQL
mysql_root_password   = "root" # We'll assume user "root"
mysql_create_database = "" # Blank to skip

# VM resources settings
server_cpus   = "4"    # Cores
server_memory = "4000" # MB
server_swap   = "4000" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# Choose distro -- Only tested with Ubuntu 16.04
# vm_box = "debian/jessie64"  # Debian 8, PHP 5.6, MySQL 5.5
# vm_box = "debian/wheezy64"  # Debian 7, PHP 5.4, MySQL 5.5
vm_box = "bento/ubuntu-16.04" # Ubuntu 16.04, PHP 7.0/5.6, MySQL 5.6
# vm_box = "ubuntu/vivid64"   # Ubuntu 15.04, PHP 5.6, MySQL 5.5
# vm_box = "ubuntu/trusty64"  # Ubuntu 14.04, PHP 5.5, MySQL 5.5
# vm_box = "ubuntu/precise64" # Ubuntu 12.04, PHP 5.3, MySQL 5.5

# This will be the base URL where install scripts are pulled from
github_url = "https://raw.githubusercontent.com/groovenectar/vagrant-scripts/master"

# Helpful reference information regarding the hostname and IP
if ARGV[0] == 'up'
	print "\n\n\n\n>>> Using hostname \"" + hostname + "\" and IP " + server_ip
	print "\n\n>>> Edit Vagrantfile to update hostname and IP\n\n\n\n"
end

# Start the config using above information
Vagrant.configure("2") do |config|

	config.vm.box = vm_box
	config.vm.define "#{hostname}" do |vagrant|
	end

	config.vm.hostname = hostname
	config.vm.network "private_network", ip: server_ip

	config.vm.synced_folder ".", synced_folder, :mount_options => ["dmode=777", "fmode=774"]

	# Resolve stdin/tty messages
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

	if Vagrant.has_plugin?("vagrant-hostmanager")
		config.hostmanager.enabled = true
		config.hostmanager.manage_host = true
		config.hostmanager.manage_guest = true
		config.hostmanager.ignore_private_ip = false
		config.hostmanager.include_offline = true
	end

	config.vm.provider "virtualbox" do |vb|
		# Customize the amount of memory on the VM:
		vb.memory = server_memory
		vb.cpus = server_cpus
	end

	# Base Packages and Config
	config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap]

	# Apache (Latest distribution-supported version)
	config.vm.provision "shell", path: "#{github_url}/scripts/apache2-dist.sh", args: [github_url, hostname, public_folder]

	# Nginx (Latest distribution-supported version)
	# config.vm.provision "shell", path: "#{github_url}/scripts/nginx-dist.sh", args: [github_url, hostname, public_folder]

	# PHP 7.1
	config.vm.provision "shell", path: "#{github_url}/scripts/php7.1.sh", args: [github_url]

	# MySQL (Latest distribution-supported version)
	config.vm.provision "shell", path: "#{github_url}/scripts/mysql-dist.sh", args: [github_url, mysql_root_password, mysql_create_database]

	# MongoDB (Latest stable version)
	# config.vm.provision "shell", path: "#{github_url}/scripts/mongodb.sh", args: [github_url]

	# Redis (Latest stable version)
	# config.vm.provision "shell", path: "#{github_url}/scripts/redis.sh", args: [github_url]
	
	# NodeJS
	config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", args: [github_url]

	# Yarn
	config.vm.provision "shell", path: "#{github_url}/scripts/yarn.sh", args: [github_url]
	
	# Bower (Requires NodeJS)
	config.vm.provision "shell", path: "#{github_url}/scripts/bower.sh", args: [github_url]

	# Composer (Requires PHP)
	config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", args: [github_url]

	# Modman
	config.vm.provision "shell", path: "#{github_url}/scripts/modman.sh", args: [github_url]

	# Ngrok
	config.vm.provision "shell", path: "#{github_url}/scripts/ngrok.sh", args: [github_url]

	# Xdebug and Webgrind
	config.vm.provision "shell", path: "#{github_url}/scripts/xdebug-webgrind.sh", args: [github_url, public_folder]
	
	# PHPUnit (Latest ~ 6)
	config.vm.provision "shell", path: "#{github_url}/scripts/phpunit-latest.sh", args: [github_url]
	
	# PHPUnit (Version 5.7)
	# config.vm.provision "shell", path: "#{github_url}/scripts/phpunit-5.sh", args: [github_url]
	
	# phpMyAdmin (Recommended, requires Composer)
	config.vm.provision "shell", path: "#{github_url}/scripts/phpmyadmin.sh", args: [github_url, public_folder, hostname, server_ip]
	
	# Mailhog mail catching
	config.vm.provision "shell", path: "#{github_url}/scripts/mailhog.sh", args: [github_url, hostname, server_ip]

	# Import database
	# config.vm.provision "shell",
	#	inline: "echo \">>> Importing SQL file\" && mysql -u root -p#{mysql_root_password} #{mysql_create_database} < #{synced_folder}/db.sql &> /dev/null"

end
