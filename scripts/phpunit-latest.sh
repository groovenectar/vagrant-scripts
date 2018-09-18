#!/usr/bin/env bash

github_url="$1"

export DEBIAN_FRONTEND=noninteractive

SBINPATH="/usr/sbin/phpunit"
PHPUNIT_BINPATH="/home/vagrant/bin/phpunit"

echo ">>> Installing PHPUnit"
{
	cd ~
	wget -q https://phar.phpunit.de/phpunit.phar
	mkdir -p "${BINPATH}"
	sudo mv phpunit.phar "${PHPUNIT_BINPATH}"
	sudo chmod +x "${PHPUNIT_BINPATH}"

(sudo tee "${SBINPATH}" <<EOL
#!/usr/bin/env bash
php ${PHPUNIT_BINPATH}
EOL
)

	sudo chmod +x "${SBINPATH}"
} &>> "$PROVISION_LOG"
