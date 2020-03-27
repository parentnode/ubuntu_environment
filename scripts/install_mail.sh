#!/bin/bash -e

outputHandler "comment" "Installing mail"

# MAIL
if test "$install_mail" = "Y"; then

	echo
	outputHandler "comment" "This is only for sending system notification mails from this server."\
	"It does not use a valid email-address for sending and cannot be used for regular emailing."\
	"Install should autofill values, but choose \"Internet Site\" if prompted for setup type."

	# INSTALL MAIL (for data protection plan)
	debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
	debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
	sudo apt install -y mailutils


	if [ -e "/etc/postfix/main.cf" ]; then

		# change default configuration
		sed -i 's/inet_interfaces = loopback-only/inet_interfaces = localhost/;' /etc/postfix/main.cf
		sed -i 's/inet_interfaces = all/inet_interfaces = localhost/;' /etc/postfix/main.cf


		if [ -e "/etc/aliases" ]; then

			# update aliases
			outputHandler "comment" "Updating aliases"

			sudo chmod 777 -R /etc/aliases

			if ! grep -R "root:" "/etc/aliases"; then
				echo "root:	$install_email" >> /etc/aliases
			fi

			if ! grep -R "$install_user:" "/etc/aliases"; then
				echo "$install_user:	$install_email" >> /etc/aliases
			fi

			sudo chmod 644 -R /etc/aliases

			sudo newaliases

		fi

		# restart mail service
		sudo service postfix restart


		echo "Your email was configured correctly on $HOSTNAME" | mail -s "Linux server email setup" $install_email
		echo
		echo

	else
		outputHandler "comment" "Setting up mail tools failed!"

	fi


else
	outputHandler "comment" "Skipping MAIL" 

fi

