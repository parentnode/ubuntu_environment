echo 
echo "Starting server installation"
echo 
echo "Installing system for $USER"
#read install_user

#echo "Setting up system for $install_user"


# SETTING LOCALES
sudo locale-gen en_GB.UTF-8


echo "TIMEZONE"

$install_timezone = "Europe/Copenhagen"
read -p "Set system timezone (Europe/Copenhagen): " install_timezone

sudo timedatectl set-timezone $install_timezone

sudo install_security.sh


#locale-gen UTF-8
#git config --global core.filemode false
#git config --global user.name "__username__"
#git config --global user.email "__EMAIL__"
#git config --global credential.helper cache


# MAKE SITES FOLDER
if [ ! -d "/srv/sites" ]; then
	mkdir /srv/sites
fi

# MAKE CONF FOLDER
if [ ! -d "/srv/conf" ]; then
	mkdir /srv/conf
fi



# ADD COMMANDS ALIAS'
#cat /srv/tools/configuration/dot_profile > /home/$install_user/.profile



echo
echo "You are done - continue with next step in the manual"

