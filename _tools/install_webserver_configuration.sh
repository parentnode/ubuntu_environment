#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "          SET UP APACHE/PHP"
echo
echo
echo

if test "$install_webserver_conf" = "Y"; then


	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf)
	if test -z "$install_apache_servername"; then

		# SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf

	else

		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf

	fi

	install_parentnode_includes=$(grep "^IncludeOptional \/srv\/conf\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/conf\/\*\.conf//;")
	if test -z "$install_parentnode_includes"; then

		# ADD GIT CONF SETUP
		echo "IncludeOptional /srv/conf/*.conf" >> /etc/apache2/apache2.conf

	fi


	# ADD DEFAULT APACHE CONF
	cat /srv/tools/_conf/default.conf > /etc/apache2/sites-available/default.conf
	# REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	


	# UPDATE PHP CONF
	cat /srv/tools/_conf/php-apache2.ini > /etc/php/7.0/apache2/php.ini
	cat /srv/tools/_conf/php-cli.ini > /etc/php/7.0/cli/php.ini

	# ADD APACHE MODULES
	a2enmod ssl
	a2enmod rewrite
	a2enmod headers

	# ENABLE DEFAULT SITE
	a2ensite default

	# DISABLE ORG DEFAULT SITE
	a2dissite 000-default


	echo
	echo "Restarting Apache"
	echo
	echo

	# RESTART APACHE
	service apache2 restart


	echo
	echo "Configuring mariaDB"
	echo
	echo

	sudo mysql_secure_installation


else

	echo
	echo "Skipping Webserver configuration"
	echo
	echo

fi
