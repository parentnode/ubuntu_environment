#!/bin/bash -e

echo "---------------------------------------------"
echo 
echo "        Starting server installation"
echo 
echo


# GET INSTALL USER
install_user=$(who am i | awk '{print $1}')
export install_user


echo
echo "Installing system for $install_user"
echo
echo "To speed up the process, please select your install options now:"
echo

read -p "Install software (Y/n): " install_software
export install_software

read -p "Set up Apache/PHP/MariaDB (Y/n): " install_webserver_conf
export install_webserver_conf

read -p "Install ffmpeg (Y/n): " install_ffmpeg
export install_ffmpeg

read -p "Install wkhtmlto (Y/n): " install_wkhtml
export install_wkhtml




echo
echo
echo "Please enter the information required for your install:"
echo


read -p "Your email address: " install_email
export install_email
echo


# MYSQL ROOT PASSWORD
if test "$install_webserver_conf" = "Y"; then

	read -s -p "Enter new root DB password: " db_root_password
	export db_root_password
	echo

fi




# SETTING DEFAULT GIT USER
git config --global core.filemode false
git config --global user.name "$install_user"
git config --global user.email "$install_email"
git config --global credential.helper cache



echo
echo
echo "Setting timezone to: Europe/Copenhagen"
echo
sudo timedatectl set-timezone "Europe/Copenhagen"


# MAKE SITES FOLDER
if [ ! -d "/srv/sites" ]; then
	mkdir /srv/sites
fi

# MAKE APACHE FOLDER
if [ ! -d "/srv/sites/apache" ]; then
	mkdir /srv/sites/apache
fi

# MAKE LOGS FOLDER
if [ ! -d "/srv/sites/apache/logs" ]; then
	mkdir /srv/sites/apache/logs
fi



# INSTALL SOFTWARE
. /srv/tools/_tools/install_software.sh

# INSTALL WEBSERVER CONFIGURATION
. /srv/tools/_tools/install_webserver_configuration.sh

# INSTALL FFMPEG
. /srv/tools/_tools/install_ffmpeg.sh

# INSTALL WKHTMLTO
. /srv/tools/_tools/install_wkhtmlto.sh



echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
cat /srv/tools/conf-client/dot_profile > /home/$install_user/.profile


echo 
echo
echo "            ------ You are done! ------"
echo

