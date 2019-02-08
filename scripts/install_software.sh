#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               SOFTWARE"
echo
echo


if test "$install_software" = "Y"; then	
    guiText "Apache2" "Start"
    sudo apt install -y apache2 apache2-utils ssl-cert
    echo

	guiText "PHP7.2" "Start"

	# INSTALL PHP5.5
	#	sudo apt install -y libapache2-mod-php5 php5 php5-cli php5-common php5-curl php5-dev php5-imagick php5-mcrypt php5-memcached php5-mysqlnd php5-xmlrpc memcached
	# For coming Ubuntu 16.04 install (when Memcached issues have been resolved)
	#sudo add-apt-repository -y ppa:ondrej/php
	#sudo apt update -y
	#	sudo apt install pkg-config build-essential libmemcached-dev

	# INSTALL PHP5.6
	# sudo apt install -y libapache2-mod-php php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php-imagick php5.6-mcrypt php5.6-mbstring php5.6-zip php-memcached php5.6-mysql php5.6-xmlrpc memcached

	#sudo apt install -y php-redis php-imagick php-igbinary php-msgpack 
	# php-memcached memcached
	# INSTALL PHP7.1
	#sudo apt install -y --allow-unauthenticated libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached
	#sudo apt install libapache2-mod-php php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php-imagick php-igbinary php-msgpack php7.1-mcrypt php7.1-mbstring php7.1-zip php-memcached php7.1-mysql php7.1-xmlrpc memcached

	# INSTALL PHP7.2
	sudo apt install -y libapache2-mod-php php7.2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xmlrpc
	sudo apt install -y php-redis php-imagick php-igbinary php-msgpack 
	echo

	guiText "Redis" "Start"
	sudo apt install -y redis
	guiText "Redis" "Done"

	guiText "Zip, Log Rotation and Curl" "Start"
	sudo apt install -y zip logrotate curl
	guiText "Zip, Log Rotation and Curl" "Done"

	guiText "MariaDB" "Start"
	sudo -E apt install -q -y mariadb-server
	

	
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	if test "$install_webserver_conf" = "Y"; then
		guiText "Apache2" "Install"
		bash /srv/tools/scripts/install_apache.sh
		guiText "Apache2" "Done"

		guiText "PHP" "Install"
		bash /srv/tools/scripts/install_php.sh
		guiText "PHP7.2" "Done"	

		
		# MAKE LOGS FOLDER
		if [ ! -e "/srv/sites/apache/apache.conf" ]; then
			# Add Default apache conf
			cat /srv/tools/conf-client/apache.conf > /srv/sites/apache/apache.conf
		fi

		guiText "Restarting Apache" "Comment"
		# RESTARTING APACHE ARE IMPORTANT FOR REST OF THE SCRIPT!!
		service apache2 restart

		guiText "MariaDB" "Install"
		bash /srv/tools/scripts/install_mariadb.sh
		guiText "MariaDB" "Done"
	else
		guiText "Webserver" "Skip"
	fi
	# INSTALL FFMPEG
	guiText "FFMPEF" "Start"
	bash /srv/tools/scripts/install_ffmpeg.sh
	guiText "FFMPEG" "Done"
	
	# INSTALL WKHTMLTO
	guiText "WKHTML" "Start"
	bash /srv/tools/scripts/install_wkhtmlto.sh
	guiText "WKHTML" "Done"
else
	guiText "Software" "Skip"
fi