echo "---------------------------------------------"
echo 
echo "         Starting server installation"
echo 
echo
echo "Installing system for $USER"
echo
#read install_user

#echo "Setting up system for $install_user"


# SETTING LOCALES
sudo locale-gen en_GB.UTF-8


# SETTING DEFAULT GIT USER
git config --global core.filemode false
git config --global user.name "$USER"
git config --global credential.helper cache



echo
echo
echo "Setting timezone to: Europe/Copenhagen"
echo
sudo timedatectl set-timezone "Europe/Copenhagen"


# INSTALL SECURITY
sudo /srv/tools/_tools/install_security.sh



# MAKE SITES FOLDER
if [ ! -d "/srv/sites" ]; then
	mkdir /srv/sites
fi

# MAKE CONF FOLDER
if [ ! -d "/srv/conf" ]; then
	mkdir /srv/conf
fi


echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
cat /srv/tools/_conf/dot_profile > /home/$USER/.profile



echo
echo
echo "You are done - reboot the server and see you in a bit (sudo reboot)"
echo

