#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               SOFTWARE"
echo
echo


read -p "Install software (Y/n): " install_software
if test "$install_software" = "Y"; then


	echo
	echo "Installing software"
	echo
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	# INSTALL APACHE
	apt install apache2 apache2-utils ssl-cert

	# INSTALL PHP
	apt install libapache2-mod-php php php-cli php-common php-curl php-dev php-imagick php-mcrypt php-memcached php-mhash php-mysqlnd php-xmlrpc memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	apt install zip logrotate curl

	# INSTALL MYSQL
	# INSTALL mariaDB
	apt install mariadb-server

	echo
	echo

else

	echo
	echo "Skipping software"
	echo
	echo

fi