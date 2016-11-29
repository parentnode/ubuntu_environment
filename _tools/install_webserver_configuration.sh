#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "        WEBSERVER CONFIGURATION"
echo
echo


read -p "Setup Webserver (Y/n): " install_webserverconf
if test "$install_webserverconf" = "Y"; then



	# SET SERVERNAME
	echo "ServerName "$HOSTNAME >> /etc/apache2/apache2.conf

	# ADD GIT CONF SETUP
	echo "IncludeOptional /srv/conf/*.conf" >> /etc/apache2/apache2.conf

	# ADD DEFAULT APACHE CONF
	cat /srv/tools/_conf/default.conf > /etc/apache2/sites-available/default.conf
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	


	# UPDATE PHP CONF
	cat /srv/tools/_conf/php-apache2.ini > /etc/php5/apache2/php.ini
	cat /srv/tools/_conf/php-cli.ini > /etc/php5/cli/php.ini

	# ADD APACHE MODULES
	a2enmod ssl
	a2enmod rewrite
	a2enmod headers

	# ENABLE DEFAULT SITE
	a2ensite default

	# DISABLE ORG DEFAULT SITE
	a2dissite 000-default

	# RESTART APACHE
	service apache2 restart

	echo
	echo

else

	echo
	echo "Skipping Webserver configuration"
	echo
	echo

fi
