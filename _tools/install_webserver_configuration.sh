#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "          SET UP APACHE/PHP/MARIADB"
echo
echo
echo

if test "$install_webserver_conf" = "Y"; then

	echo
	echo "Configuring Apache and PHP"
	echo
	echo


	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	if [ -z "$install_apache_servername" ]; then

		# SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf

	else

		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf

	fi

	# remove path (slashes) from output to avoid problem with testing string
	install_parentnode_includes=$(grep "^IncludeOptional \/srv\/conf\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/conf\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then

		# ADD GIT CONF SETUP
		echo "IncludeOptional /srv/conf/*.conf" >> /etc/apache2/apache2.conf

	fi


	# ADD DEFAULT APACHE CONF
	cat /srv/tools/_conf/default.conf > /etc/apache2/sites-available/default.conf
	# REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	

	# ADD APACHE MODULES
	a2enmod ssl
	a2enmod rewrite
	a2enmod headers

	# ENABLE DEFAULT SITE
	a2ensite default

	# DISABLE ORG DEFAULT SITE
	a2dissite 000-default


	# UPDATE PHP CONF
	cat /srv/tools/_conf/php-apache2.ini > /etc/php/7.0/apache2/php.ini
	cat /srv/tools/_conf/php-cli.ini > /etc/php/7.0/cli/php.ini



	echo
	echo "Restarting Apache"
	echo
	echo

	# RESTART APACHE
	service apache2 restart


	echo
	echo "Configuring MariaDB"
	echo
	echo


	# Do we have root password
	if [ ! -z "$db_root_password" ]; then

		# Checking mysql login - trying to log in without password
		sudo mysql --user=root -e exit 2>/dev/null
		dbstatus=`echo $?`
		# Login was successful - it means that DB was not set up yet
		if [ "$dbstatus" -eq 0 ]; then

			# set login mode (mysql_native_password) and password for root account
			echo "UPDATE mysql.user SET plugin = 'mysql_native_password', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root

			# REPLACE PASSWORD FOR MAINTANENCE ACCOUNT
			sudo sed -i "s/password = .\*/password = $db_root_password/;" /etc/mysql/debian.cnf

			echo "DB Root access configured"

		fi

	fi


	echo
	echo



else

	echo
	echo "Skipping Webserver configuration"
	echo
	echo

fi
