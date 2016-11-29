#!/bin/bash

echo "---------------------------------------------"
echo 
echo "         Starting server installation"
echo 
echo

install_user=$(who am i | awk '{print $1}')
echo
echo "Installing system for $install_user"
echo



# SETTING DEFAULT GIT USER
git config --global core.filemode false
git config --global user.name "$install_user"
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
sudo /srv/tools/_tools/install_security.sh

# INSTALL SECURITY
sudo /srv/tools/_tools/install_security.sh



echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
cat /srv/tools/_conf/dot_profile > /home/$install_user/.profile



echo
echo
echo "Login command:"

port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")
ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "ssh -p $port_number kaestel@$ip_address"
echo 
echo
echo "You are done!"
echo
echo "Reboot the server (sudo reboot) and log in again (ssh -p $port_number kaestel@$ip_address)"
echo
echo "See you in a bit "
echo

