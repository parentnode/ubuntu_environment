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

	if test "$install_webserver_conf" = "Y"; then

		sudo service apache2 stop 2>/dev/null
		echo
		echo "Installing and configuring apache2"
		echo
		bash /srv/tools/scripts/install_apache.sh
		echo

		echo
		echo "Installing and configuring php"
		echo
		bash /srv/tools/scripts/install_php.sh
		echo

		echo
		echo "Installing redis"
		echo
		sudo apt install -y redis
		echo

		echo
		echo "Installing zip, log rotation and curl"
		echo
		sudo apt install -y zip logrotate curl
		echo
		# MAKE LOGS FOLDER
		if [ ! -e "/srv/sites/apache/apache.conf" ]; then
			# Add Default apache conf
			cat /srv/tools/conf-client/apache.conf > /srv/sites/apache/apache.conf
		fi

		echo
		echo "Restarting Apache"
		echo
		echo


		echo
		echo "Installing and configuring mariadb"
		echo
		bash /srv/tools/scripts/install_mariadb.sh
		echo

	else
		echo
		echo "Skipping Webserver configuration"
		echo
		echo

	fi
	# RESTART APACHE
	sudo service apache2 restart
	# INSTALL FFMPEG
	bash /srv/tools/scripts/install_ffmpeg.sh
	echo
	echo "Installing ffmpeg done"
	echo
	# INSTALL WKHTMLTO
	bash /srv/tools/scripts/install_wkhtmlto.sh
	echo
	echo "Installing wkhtml done"
	echo
else

	echo
	echo "Skipping software"
	echo
	echo

fi