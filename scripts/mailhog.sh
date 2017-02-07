#!/usr/bin/env bash

github_url="$1"
hostname="$2"
server_ip="$3"

init=$(which init)

echo
echo ">>> Installing Mailhog"

sudo wget --quiet -O /usr/local/mailhog https://github.com/mailhog/MailHog/releases/download/v0.2.1/MailHog_linux_amd64
sudo chmod +x /usr/local/mailhog

if [[ -n "$(type -t dpkg)" ]]
then
	output="$(dpkg -S "${init}")"

	if [[ "${output}" == *"upstart"* ]]
	then
		type="upstart"
	elif [[ "${output}" == *"systemd"* ]]
	then
		type="systemd"
	fi
elif [[ -n "$(type -t rpm)" ]]
then
	output="$(rpm -qf "${init}")"

	if [[ "${output}" == *"upstart"* ]]
	then
		type="upstart"
	elif [[ "${output}" == *"systemd"* ]]
	then
		type="systemd"
	fi
fi

if [[ "${type}" == "upstart" ]]
then
	# Make it start on reboot
	(sudo tee /etc/init/mailhog.conf <<EOL
description "Mailhog"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
pre-start script
    exec su - "$(whoami)" -c "/usr/bin/env /usr/local/mailhog > /dev/null 2>&1 &"
end script
EOL
  ) &>/dev/null

	# Start it now in the background
	sudo service mailhog start
elif [[ "${type}" == "systemd" ]]
then
	# Make it start on reboot
	(sudo tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=MailHog Service
After=network.service
[Service]
Type=simple
ExecStart=/usr/bin/env /usr/local/mailhog > /dev/null 2>&1 &
[Install]
WantedBy=multi-user.target
EOL
	) &>/dev/null

	# Start on reboot
	sudo systemctl enable mailhog

	# Start background service now
	sudo systemctl start mailhog
else
	echo
	echo ">>> Error: Could not detect system type. You will need to manually add Mailhog to startup."
fi

if [[ -n "$(type -t sendmail)" ]]
then
	echo
	echo ">>> Sendmail is installed -- Replacing sendmail with Mailhog and renaming sendmail binary to sendmail.backup"

	sudo service sendmail stop

	sendmail_path=$(which sendmail)

	sudo mv "${sendmail_path}" "${sendmail_path}.backup"

	(sudo tee "${sendmail_path}" <<EOL
#!/usr/bin/env bash

/usr/local/mailhog sendmail "\$@"
EOL
	) &>/dev/null

	sudo chmod +x "${sendmail_path}"
fi

echo ""
echo ""
echo ""
echo ">>> Mailhog installed. Use the following information to use email:"
echo ""
echo "SMTP port: 1025"
echo "SMTP server: localhost"
echo "SMTP SSL/TLS: none"
echo "SMTP authentication: none"
echo "HTTP mail viewing port: 8025"
echo "URL to view mail: http://${server_ip}:8025 or http://${hostname}:8025"
echo ""
echo ""
echo ""
