Usage
-----

Copy the Vagrantfile to your project, customize, and `vagrant up`. A core .gitignore is included with directives that should be a safe starting point for most any project. Windows users may need to `vagrant up` as adminsitrator in order to use packages that create symlinks (Webgrind and phpMyAdmin).

Notes
-----

Shortcut scripts:

* `weberr` - Tail the Nginx log and follow output
* `dberr` - Tail the MySQL log and follow output
* `phperr` - Tail the PHP log and follow output

Defaults
--------

To exclude components from provisioning in your box, comment the respective lines in Vagrantfile.

* Ubuntu 16.04 (Chef's version conforming to vagrant standards)
* Apache2 (Lastest distro apt version)
* Nginx (Lastest distro apt version)
* PHP 7.1
* MySQL (Lastest distro apt version ~ 5.7)
* NodeJS (Lastest version from source -- not distro version)
* Bower
* Composer
* phpMyAdmin (Accessed from `http://[IP_OR_HOST]/phpmyadmin`. Add `/phpmyadmin` to .gitignore)
* Modman
* PHPUnit (Version 5.6, latest available as well)
* Xdebug (Latest distro apt version)
* Webgrind (Accessed from `http://[IP_OR_HOST]/webgrind`. Add `/webgrind` to .gitignore)
* Ngrok
* Mailhog
