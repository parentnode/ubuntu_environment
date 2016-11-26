echo "Start server installation"
echo "Install for username:"
read install_user

echo "Setting up system for $install_user"


# SETTING LOCALES
sudo apt install language-pack-UTF-8
sudo locale-gen UTF-8
/usr/sbin/update-locale LANG=en_GB.utf8


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

