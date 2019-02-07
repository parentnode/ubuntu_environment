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
#	sudo apt install -y libapache2-mod-php5 php5 php5-cli php5-common php5-curl php5-dev php5-imagick php5-mcrypt php5-memcached php5-mysqlnd php5-xmlrpc memcached


	# For coming Ubuntu 16.04 install (when Memcached issues have been resolved)
	#sudo add-apt-repository -y ppa:ondrej/php
	#sudo apt update -y
#	sudo apt install pkg-config build-essential libmemcached-dev

	# INSTALL PHP7.2
	sudo apt install -y libapache2-mod-php php7.2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xmlrpc

	sudo apt install -y php-redis php-imagick php-igbinary php-msgpack 
	# php-memcached memcached
	# INSTALL REDIS 
	sudo apt install -y redis



	# INSTALL PHP7.1
	#sudo apt install -y --allow-unauthenticated libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached
	#sudo apt install libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached

	# INSTALL PHP5.6
	# sudo apt install -y libapache2-mod-php php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php-imagick php5.6-mcrypt php5.6-mbstring php5.6-zip php-memcached php5.6-mysql php5.6-xmlrpc memcached

	# INSTALL ZIP, LOG ROTATION, CURL
	sudo apt install -y zip logrotate curl

	# INSTALL mariaDB
	# Avoid password prompt - password will be set in install_webserver_configuration (NOT NEEDED FOR UBUNTU 16.14)
	# export DEBIAN_FRONTEND=noninteractive
	# debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password temp"
	# debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password temp"

	sudo -E apt install -q -y mariadb-server


	echo
	echo

else

	echo
	echo "Skipping software"
	echo
	echo

fi

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

	# Check for server name
	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	# If no results
	if [ -z "$install_apache_servername" ]; then

		# SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf

	else
		# Replace existing servername with hostname
		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf

	fi

	# remove path (slashes) from output to avoid problem with testing string
	install_parentnode_includes=$(grep "^IncludeOptional \/srv\/sites\/apache\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/sites\/apache\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then

		# ADD GIT CONF SETUP
		echo "IncludeOptional /srv/sites/apache/*.conf" >> /etc/apache2/apache2.conf

	fi


	# ADD DEFAULT APACHE CONF
	cat /srv/tools/conf-client/default.conf > /etc/apache2/sites-available/default.conf
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
	# PHP 5
	#cat /srv/tools/conf-client/php-apache2.ini > /etc/php5/apache2/php.ini
	#cat /srv/tools/conf-client/php-cli.ini > /etc/php5/cli/php.ini

	# PHP 7.2
	cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.2/apache2/php.ini
	cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.2/cli/php.ini


	# PHP 7.1
	#cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.1/apache2/php.ini
	#cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.1/cli/php.ini


	# MAKE LOGS FOLDER
	if [ ! -e "/srv/sites/apache/apache.conf" ]; then

		# Add Default apache conf
		cat /srv/tools/conf-client/apache.conf > /srv/sites/apache/apache.conf

	fi

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
	if [ -n "$db_root_password" ]; then

		# Checking mysql login - trying to log in without password (UBUNTU 16.04)
		dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)

		# Checking mysql login - trying to log in with temp password (UBUNTU 14.04)
		#dbstatus=$(sudo mysql --user=root --password=temp -e exit 2>/dev/null || echo 1)

		# Login was successful - it means that DB was not set up yet
		if [ -z "$dbstatus" ]; then

			# set login mode (mysql_native_password) and password for root account
			#echo "UPDATE mysql.user SET plugin = '', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root -ptemp

			# FOR UBUNTU 16.04/MariaDB 10
			echo "UPDATE mysql.user SET plugin = 'mysql_native_password', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root

			# REPLACE PASSWORD FOR MAINTANENCE ACCOUNT
			sudo sed -i "s/password = .*/password = $db_root_password/;" /etc/mysql/debian.cnf

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
bash /srv/tools/scripts/install_ffmpeg.sh

bash /srv/tools/scripts/install_wkhtmlto.sh

