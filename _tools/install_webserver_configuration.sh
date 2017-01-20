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


#	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	if grep -E "^ServerName" /etc/apache2/apache2.conf; then

		# SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf

	else

		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf

	fi

	# # remove path (slashes) from output to avoid problem with testing string
	# install_parentnode_includes=$(grep "^IncludeOptional \/srv\/conf\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/conf\/\*\.conf//;" || echo "")
	# if test -z "$install_parentnode_includes"; then
	#
	# 	# ADD GIT CONF SETUP
	# 	echo "IncludeOptional /srv/conf/*.conf" >> /etc/apache2/apache2.conf
	#
	# fi
	#
	#
	# # ADD DEFAULT APACHE CONF
	# cat /srv/tools/_conf/default.conf > /etc/apache2/sites-available/default.conf
	# # REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	# sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	#
	#
	# # ADD APACHE MODULES
	# a2enmod ssl
	# a2enmod rewrite
	# a2enmod headers
	#
	# # ENABLE DEFAULT SITE
	# a2ensite default
	#
	# # DISABLE ORG DEFAULT SITE
	# a2dissite 000-default
	#
	#
	# # UPDATE PHP CONF
	# cat /srv/tools/_conf/php-apache2.ini > /etc/php/7.0/apache2/php.ini
	# cat /srv/tools/_conf/php-cli.ini > /etc/php/7.0/cli/php.ini
	#
	#
	#
	# echo
	# echo "Restarting Apache"
	# echo
	# echo
	#
	# # RESTART APACHE
	# service apache2 restart
	#
	#
	# echo
	# echo "Configuring mariaDB"
	# echo
	# echo
	# echo "During the mariaDB configuaration, you will be asked a series of questions."
	# echo "PLEASE NOTE: If you disable remote root login, you will not be able to log into root account with SequelPro."
	# echo
	#
	# sudo mysql_secure_installation
	#
	# echo
	# echo
	#
	# read -s -p "Please enter your MariaDB password to enable logrotation: " db_root_password
	#
	# # REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	# sudo sed -i "s/password = .\+/password = $db_root_password/;" /etc/mysql/debian.cnf
	#
	# echo
	# echo



else

	echo
	echo "Skipping Webserver configuration"
	echo
	echo

fi
