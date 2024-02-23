#!/bin/bash -e
outputHandler "section" "SOFTWARE"
if test "$install_software" = "Y"; then	

    outputHandler "comment" "Adding PPA:ondrej/apache2 for latest Apache updates"
	command "sudo add-apt-repository ppa:ondrej/apache2 -y"
	command "sudo apt-get update"

    outputHandler "comment" "Adding PPA:ondrej/php for latest PHP updates"
	command "sudo add-apt-repository ppa:ondrej/php -y"
	command "sudo apt-get update"


    outputHandler "comment" "Installing Software packages"
	outputHandler "comment" "Installing Apache and extra modules"
    outputHandler "comment" "Installing apache2"

	command "sudo apt-get install -y apache2 apache2-utils ssl-cert"
	
	outputHandler "comment" "Installing PHP8.2 and extra modules"

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
	#command "sudo apt-get install -y libapache2-mod-php php7.2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xmlrpc"
	# INSTALL PHP7.4
	# command "sudo apt-get install -y libapache2-mod-php php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-dev php7.4-mbstring php7.4-zip php7.4-mysql php7.4-xmlrpc"
	# command "sudo apt-get install -y php-redis php-imagick php-igbinary php-msgpack"

	# INSTALL PHP8.2
	command "sudo apt-get install -y libapache2-mod-php php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-dev php8.2-mbstring php8.2-zip php8.2-mysql php8.2-xmlrpc"
	command "sudo apt-get install -y php8.2-redis php8.2-imagick php8.2-igbinary php8.2-msgpack php8.2-xml" 

	outputHandler "comment" "Installing Redis"
	command "sudo apt-get install -y redis"
	
	outputHandler "comment" "Installing Zip"
	command "sudo apt-get install -y zip" 

	outputHandler "comment" "Installing Log Rotation"
	command "sudo apt-get install -y logrotate" 
	outputHandler "comment" "Installing Curl" 
	command "sudo apt-get install -y curl"
	outputHandler "comment" "Installing MariaDB Server"
	command "sudo -E apt-get install -q -y mariadb-server"
	# INSTALL FFMPEG
	. /srv/tools/scripts/install_ffmpeg.sh
	# INSTALL WKHTMLTO
	. /srv/tools/scripts/install_wkhtmlto.sh
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

	outputHandler "comment" "Making sure everything is upgraded to newest version"
	command "sudo apt-get upgrade -y"

else
	outputHandler "section" "Skipping software"
fi