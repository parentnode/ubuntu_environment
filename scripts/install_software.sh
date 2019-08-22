#!/bin/bash -e

if test "$install_software" = "Y"; then	
    outputHandler "section" "Install software"
	outputHandler "comment" "Installing Apache and extra modules"
    #sudo apt install -y apache2 apache2-utils ssl-cert
	valid_status=("running" "dead")
	#echo "Checking Apache2.4 status: "
	if [ -z "$(testCommand "service apache2 status" "${valid_status[@]}")" ]; then
		command "sudo apt-get install -y apache2 apache2-utils ssl-cert"
	else
		outputHandler "comment" "Apache Installed" "[Apache status:] $(testCommand "service apache2 status" "${valid_status[@]}")"
	fi
	#installedPackage "apache2"
	#installedPackage "apache2-utils"
	#installedPackage "ssl-cert"

	outputHandler "comment" "Installing PHP7.2 and extra modules"

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
	#installedPackage "libapache2-mod-php"
	#installedPackage "php7.2"
	#installedPackage "php7.2-cli"
	#installedPackage "php7.2-common"
	#installedPackage "php7.2-curl"
	#installedPackage "php7.2-dev"
	#installedPackage "php7.2-mbstring"
	#installedPackage "php7.2-zip"
	#installedPackage "php7.2-mysql"
	#installedPackage "php7.2-xmlrpc"
	command "sudo apt-get install -y libapache2-mod-php php7.2 php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xmlrpc"
	command "sudo apt-get install -y php-redis php-imagick php-igbinary php-msgpack" 
	#sudo apt install -y php-redis php-imagick php-igbinary php-msgpack 
	#installedPackage "php-redis"
	#installedPackage "php-imagick"
	#installedPackage "php-igbinary"
	#installedPackage "php-msgpack"

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
	outputHandler "comment" "Installing FFMPEG"
	if test "$install_ffmpeg" = "Y"; then
		command "sudo -k apt-get install -y ffmpeg"
		# # FFMPEG - FORCE PASSWORD RENEWAL (BUILDING FFMPEG TAKES TIME)
		# sudo -k apt install -y build-essential checkinstall yasm texi2html libfdk-aac-dev libfaad-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libvpx-dev libxvidcore-dev zlib1g-dev libx264-dev x264 libsdl1.2-dev
		#
		# wget http://www.ffmpeg.org/releases/ffmpeg-3.2.1.tar.gz
		# tar xf ffmpeg-3.2.1.tar.gz
		# rm ffmpeg-3.2.1.tar.gz
		# cd ffmpeg-3.2.1 && ./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-pthreads --enable-libfdk-aac --enable-libmp3lame --enable-libtheora --enable-libvorbis --enable-libx264 --enable-libxvid --enable-libvpx && make && make install && make distclean && hash -r
		# cd ..
		# rm -R ffmpeg-3.2.1
	
	else
		outputHandler "comment" "Skipping FFMPEG"
	fi

	# INSTALL WKHTMLTO
	outputHandler "comment" "Installing WKHTMLTOPF"
	if test "$install_wkhtml" = "Y"; then

		# WKHTML - FORCE PASSWORD RENEWAL
		outputHandler "comment" "Using /srv/tools/bin/wkhtmltopdf"
		# sudo apt install -y wkhtmltopdf
		# installedPackage "wkhtmltopdf"
		# sudo cp /srv/tools/conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
		# sudo cp /srv/tools/conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf

	else
		outputHandler "comment" "Skipping WKHTMLTOPF"
	fi
	
	# INSTALL SYS-INFO
	# aptitude install landscape-client landscape-common

else
	outputHandler "comment" "Skipping software"
fi