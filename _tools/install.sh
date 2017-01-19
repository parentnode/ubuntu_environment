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

read -p "Secure the server (Y/n): " install_security
export install_security

read -p "Install software (Y/n): " install_software
export install_software

read -p "Install .htaccess (Y/n): " install_htpassword_for_user
export install_htpassword_for_user

read -p "Install mail (Y/n): " install_mail
export install_mail

read -p "Install ffmpeg (Y/n): " install_ffmpeg
export install_ffmpeg

read -p "Install wkhtmlto (Y/n): " install_wkhtml
export install_wkhtml

read -p "Set up Apache/PHP/MariaDB (Y/n): " install_webserver_conf
export install_webserver_conf


echo
echo
echo "Please enter the information required for your install:"
echo


read -p "Your email address: " install_email
export install_email
echo

# HTACCESS PASSWORD
if test "$install_htpassword_for_user" = "Y"; then

	read -s -p "HTACCESS password for $install_user: " install_htaccess_password

	export install_htaccess_password
	echo
	echo

fi

# SSH PORT
if test "$install_security" = "Y"; then

	# GET CURRENT PORT NUMBER
	port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")

	read -p "Specify SSH port (leave empty to keep $port_number): " install_port
	export install_port
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

# MAKE CONF FOLDER
if [ ! -d "/srv/conf" ]; then
	mkdir /srv/conf
fi


# INSTALL SECURITY
. /srv/tools/_tools/install_security.sh

# INSTALL SOFTWARE
. /srv/tools/_tools/install_software.sh

# INSTALL HTACCESS PASSWORD
. /srv/tools/_tools/install_htaccess.sh

# INSTALL FFMPEG
. /srv/tools/_tools/install_ffmpeg.sh

# INSTALL WKHTMLTO
. /srv/tools/_tools/install_wkhtmlto.sh

# INSTALL WEBSERVER CONFIGURATION
. /srv/tools/_tools/install_webserver_configuration.sh

# INSTALL MAIL
. /srv/tools/_tools/install_mail.sh



echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
cat /srv/tools/_conf/dot_profile > /home/$install_user/.profile


# GET CURRENT PORT NUMBER AND IP ADDRESS
port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")
ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo
echo
echo "Login command:"
echo
echo "ssh -p $port_number kaestel@$ip_address"
echo 
echo
echo "You are done!"
echo
echo "Reboot the server (sudo reboot)"
echo "and log in again (ssh -p $port_number kaestel@$ip_address)"
echo
echo
echo "See you in a bit "
echo

