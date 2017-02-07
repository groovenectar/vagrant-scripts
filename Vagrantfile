# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname = "vagrant.dev"
# The server folder that will contain the root of the files
synced_folder = "/var/www/#{hostname}"
# The server folder that will be the document root (e.g. /var/www/#{hostname}/public)
public_folder = "/var/www/#{hostname}/public"
server_ip = "192.168.33.94"

mysql_root_password   = "root" # We'll assume user "root"
mysql_create_database = "" # Blank to skip

server_cpus   = "2"    # Cores
server_memory = "2000" # MB
server_swap   = "2000" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# Choose distro -- Only tested with Ubuntu 16.04
# vm_box = "debian/jessie64"  # Debian 8, PHP 5.6, MySQL 5.5
# vm_box = "debian/wheezy64"  # Debian 7, PHP 5.4, MySQL 5.5
vm_box = "bento/ubuntu-16.04" # Ubuntu 16.04, PHP 7.0/5.6, MySQL 5.6
# vm_box = "ubuntu/vivid64"   # Ubuntu 15.04, PHP 5.6, MySQL 5.5
# vm_box = "ubuntu/trusty64"  # Ubuntu 14.04, PHP 5.5, MySQL 5.5
# vm_box = "ubuntu/precise64" # Ubuntu 12.04, PHP 5.3, MySQL 5.5

# Config Github Settings
github_username = "groovenectar"
github_repo     = "vagrant-scripts"
github_branch   = "master"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

# Helpful information regarding the hostname and using email
if ARGV[0] == 'up'
	print "\n\n\n"
	print ">>> Mailhog installed. Use the following information to use email:\n\n"
	print "SMTP port: 1025\n"
	print "SMTP server: localhost\n"
	print "SMTP SSL/TLS: none\n"
	print "SMTP authentication: none\n"
	print "HTTP mail viewing port: 8025\n"
	print "URL to view mail: http://#{server_ip}:8025 or http://#{hostname}:8025/\n\n\n\n"

	print "Using hostname \"" + hostname + "\" and IP " + server_ip
	print "\n\nEdit Vagrantfile to update hostname and IP"
	print "\n\n\n\n"
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
		config.hostmanager.ignore_private_ip = false
		config.hostmanager.include_offline = false
	end

	config.vm.provider "virtualbox" do |vb|
		# Customize the amount of memory on the VM:
		vb.memory = server_memory
		vb.cpus = server_cpus
	end

	# Base Packages and Config
	config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap]
	
	# Nginx (latest distribution-supported version)
	config.vm.provision "shell", path: "#{github_url}/scripts/nginx-dist.sh", args: [github_url, hostname, public_folder]

	# MySQL (latest distribution-supported version)
	config.vm.provision "shell", path: "#{github_url}/scripts/mysql-dist.sh", args: [github_url, mysql_root_password, mysql_create_database]

	# PHP 7 (latest distribution-supported version only for Ubuntu 16.04)
	config.vm.provision "shell", path: "#{github_url}/scripts/php70-dist.sh", args: [github_url]

	# NodeJS
	config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", args: [github_url]

	# Bower (requires NodeJS)
	config.vm.provision "shell", path: "#{github_url}/scripts/bower.sh", args: [github_url]
	
	# Composer (requires PHP)
	config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", args: [github_url]

	# Mailhog mail catching
	config.vm.provision "shell", path: "#{github_url}/scripts/mailhog.sh", args: [github_url]

	# Modman
	config.vm.provision "shell", path: "#{github_url}/scripts/modman.sh", args: [github_url]

	# Ngrok
	config.vm.provision "shell", path: "#{github_url}/scripts/ngrok.sh", args: [github_url]

end