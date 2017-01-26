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
	sudo apt install -y apache2 apache2-utils ssl-cert

	# INSTALL PHP5.5
	sudo apt install -y libapache2-mod-php5 php5 php5-cli php5-common php5-curl php5-dev php5-imagick php5-mcrypt php5-memcached php5-mysqlnd php5-xmlrpc memcached


	# For coming Ubuntu 16.04 install (when Memcached issues have been resolved)
	#sudo add-apt-repository -y ppa:ondrej/php
	#sudo apt update -y

	# INSTALL PHP7.1
	# sudo apt install -y libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached

	# INSTALL PHP5.6
	# sudo apt install -y libapache2-mod-php php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php-imagick php5.6-mcrypt php5.6-mbstring php5.6-zip php-memcached php5.6-mysql php5.6-xmlrpc memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	sudo apt install -y zip logrotate curl

	# INSTALL mariaDB
	# Avoid password prompt - password will be set in install_webserver_configuration (NOT NEEDED FOR UBUNTU 16.04)
	export DEBIAN_FRONTEND=noninteractive
	debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password ''"
	debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password ''"
	debconf-set-selections <<< "mariadb-server-5.5 mariadb-server-5.5/root_password password ''"
	debconf-set-selections <<< "mariadb-server-5.5 mariadb-server-5.5/root_password_again password ''"
	debconf-set-selections <<< "mysql-server mysql-server/root_password ''"
	debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ''"
	sudo -E apt install -q -y mariadb-server


	echo
	echo

else

	echo
	echo "Skipping software"
	echo
	echo

fi