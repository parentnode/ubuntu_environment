#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               MAIL"
echo
echo

# MAIL
if test "$install_mail" = "Y"; then

	echo
	echo "This is only for sending notification mails from this server. It does not use a valid email-address for sending."
	echo
	echo "Choose \"Internet Site\" when prompted for setup type."
	echo

	# INSTALL MAIL (for data protection plan)
	sudo apt install mailutils


	# change default configuration
	sed -i 's/inet_interfaces = loopback-only/inet_interfaces = localhost/;' /etc/postfix/main.cf
	sed -i 's/inet_interfaces = all/inet_interfaces = localhost/;' /etc/postfix/main.cf

	# update aliases
#	read -p "Forward internal mails to (email): " install_email


	echo "Updating aliases"
	echo

	sudo chmod 777 -R /etc/aliases

	if ! grep -R "root:" "/etc/aliases"; then
		echo "root:	$install_email" >> /etc/aliases
	fi

	if ! grep -R "$install_user:" "/etc/aliases"; then
		echo "$install_user:	$install_email" >> /etc/aliases
	fi

	sudo chmod 644 -R /etc/aliases

	sudo newaliases

	# restart mail service
	sudo service postfix restart


	echo "Your email was configured correctly" | mail -s "Linux server email setup" $install_email
	echo
	echo

else

	echo
	echo "Skipping MAIL"
	echo
	echo

fi

