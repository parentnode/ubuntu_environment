#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               SOFTWARE"
echo
echo


if test "$install_software" = "Y"; then


	echo
	echo "Installing software"
	echo
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	# INSTALL APACHE
	apt install apache2 apache2-utils ssl-cert

	# INSTALL PHP
	apt install libapache2-mod-php php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-dev php-imagick php7.0-mcrypt php-memcached php7.0-mysql php7.0-xmlrpc memcached

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