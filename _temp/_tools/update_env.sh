# TO RUN MANUALLY: sh /srv/tools/update_env.sh

echo
echo "Updating server environment"



# SET LOCALE
sudo /usr/sbin/update-locale LANG=en_GB.utf8

# UPDATE TOOLS
cd /srv/tools && sudo git pull


echo
echo "SOFTWARE"
echo

read -p "Update software (Y/n): " update_software
if test "$update_software" = "Y"; then


	# INSTALL SYS-INFO
	sudo apt install landscape-client landscape-common

	# INSTALL APACHE
	sudo apt install apache2 apache2-mpm-prefork apache2-utils libexpat1 ssl-cert

	# INSTALL PHP
	sudo apt install libapache2-mod-php php php-cli php-common php-curl php-dev php-imagick php-mcrypt php-memcached php-mhash php-mysqlnd php-pspell php5-xmlrpc php-pear memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	sudo apt install zip logrotate curl

	# INSTALL MYSQL
	sudo apt install mysql-server mysql-client

else
	echo "Skipping software update"
fi


echo
echo "CONFIGURATION"
echo

# .profile
read -p "Update .profile (Y/n): " update_dot_profile
if test "$update_dot_profile" = "Y"; then

	echo "Username:"
	read update_user

	# UPDATE .profile CONF
	sudo cp /srv/tools/configuration/dot_profile /home/$update_user/.profile

else
	echo "Skipping .profile update"
fi


echo


# PHP/APACHE DEFAULTS
read -p "Update php/apache configuration (Y/n): " update_conf
if test "$update_conf" = "Y"; then

	# UPDATE PHP CONF
	sudo cp /srv/tools/configuration/php-apache2.ini /etc/php5/apache2/php.ini
	sudo cp /srv/tools/configuration/php-cli.ini /etc/php5/cli/php.ini

	# UPDATE APACHE DEFAULT
	sudo cp /srv/tools/configuration/default.conf /etc/apache2/sites-available/default.conf

else
	echo "Skipping php/apache configuration update"
fi


echo
echo "WKHTML"
echo


# WKHTML
read -p "Update WKHTML (Y/n): " update_wkhtml
if test "$update_wkhtml" = "Y"; then

	# UPDATE WKHTML
	sudo cp /srv/tools/configuration/wkhtmltoimage /usr/bin/static_wkhtmltoimage
	sudo cp /srv/tools/configuration/wkhtmltopdf /usr/bin/static_wkhtmltopdf

else
	echo "Skipping WKHTML update"
fi


echo
echo "MAIL"
echo


# MAIL
read -p "Update MAIL settings (Y/n): " update_mail
if test "$update_mail" = "Y"; then

	echo
	echo "This is only for sending notification mails from this server. It does not use a valid email-address for sending."
	echo
	echo "Choose \"Internet Site\" when prompted for setup type."
	echo

	# INSTALL MAIL (for data protection plan)
	sudo aptitude install mailutils


	# change default configuration
	sudo sed -i 's/inet_interfaces = loopback-only/inet_interfaces = localhost/;' /etc/postfix/main.cf
	sudo sed -i 's/inet_interfaces = all/inet_interfaces = localhost/;' /etc/postfix/main.cf

	# update aliases
	read -p "Forward internal mails to (email): " forward_mail

	if grep -R "root:" "/etc/aliases"; then
		echo "Aliases exists"
	else
		echo "Updating aliases"
		sudo chmod 777 -R /etc/aliases
		echo "root:	$forward_mail" >> /etc/aliases
		echo "$USER:	$forward_mail" >> /etc/aliases
		sudo chmod 644 -R /etc/aliases
	fi

	sudo newaliases

	# restart mail service
	sudo service postfix restart


	echo "Your email was configured correctly" | mail -s "Linux server email setup" $forward_mail


else
	echo "Skipping MAIL update"
fi

echo
echo


# RESTART APACHE
sudo service apache2 restart


echo
echo "Environment updated"
