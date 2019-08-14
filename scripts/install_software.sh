#!/bin/bash -e

if test "$install_software" = "Y"; then	
    
	outputHandler "section" "Installing Apache"
    #sudo apt install -y apache2 apache2-utils ssl-cert
	valid_status=("running" "dead")
	#echo "Checking Apache2.4 status: "
	if [ -z "$(testCommand "service apache2 status" "${valid_status[@]}")" ]; then
		command "sudo apt install -y apache2 apache2-utils ssl-cert"
	else
		testCommand "service apache2 status" "${valid_status[@]}"
	fi
	exit 1
	installedPackage "apache2"
	installedPackage "apache2-utils"
	installedPackage "ssl-cert"

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
	#sudo apt install -y libapache2-mod-php php7.2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xmlrpc
	installedPackage "libapache2-mod-php"
	installedPackage "php7.2"
	installedPackage "php7.2-cli"
	installedPackage "php7.2-common"
	installedPackage "php7.2-curl"
	installedPackage "php7.2-dev"
	installedPackage "php7.2-mbstring"
	installedPackage "php7.2-zip"
	installedPackage "php7.2-mysql"
	installedPackage "php7.2-xmlrpc"
	#sudo apt install -y php-redis php-imagick php-igbinary php-msgpack 
	installedPackage "php-redis"
	installedPackage "php-imagick"
	installedPackage "php-igbinary"
	installedPackage "php-msgpack"

	guiText "Redis" "Start"
	sudo apt install -y redis
	#installedPackage "redis"
	guiText "Redis" "Done"

	guiText "Zip, Log Rotation and Curl" "Start"
	#sudo apt install -y zip logrotate curl
	installedPackage "zip"
	installedPackage "logrotate"
	installedPackage "curl"
	guiText "Zip, Log Rotation and Curl" "Done"

	guiText "MariaDB" "Start"
	#sudo -E apt install -q -y mariadb-server
	
	installedPackage "mariadb-server" "E" "q"
	# INSTALL FFMPEG
	guiText "FFMPEF" "Start"
	. /srv/tools/scripts/install_ffmpeg.sh
	guiText "FFMPEG" "Done"

	# INSTALL WKHTMLTO
	guiText "WKHTML" "Start"
	. /srv/tools/scripts/install_wkhtmlto.sh
	guiText "WKHTML" "Done"

	
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

else
	guiText "Software" "Skip"
fi