#!/bin/bash

echo "-----------------------------------------"
echo
echo "               SOFTWARE"
echo
echo
install_user=$(who am i | awk '{print $1}')


read -p "Install software (Y/n): " install_software
if test "$install_software" = "Y"; then

	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	# INSTALL APACHE
	apt install apache2 apache2-mpm-prefork apache2-utils ssl-cert

	# INSTALL PHP
	apt install libapache2-mod-php php php-cli php-common php-curl php-dev php-imagick php-mcrypt php-memcached php-mhash php-mysqlnd php-xmlrpc php-pear memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	apt install zip logrotate curl

	# INSTALL MYSQL
	# INSTALL mariaDB
	apt install mariadb-server

else

	echo
	echo "Skipping software"
	echo

fi