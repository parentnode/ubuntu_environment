#!/bin/bash -e

echo "---------------------------------------------"
echo 
echo "        Starting server installation"
echo 
echo


# GET INSTALL USER
install_user=$SUDO_USER
#$(whoami | awk '{print $1}')
export install_user


# echo
# echo "SUDO USER:$SUDO_USER"
# echo
# echo


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



#dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)
#mysqlstatus=$(dpkg --get-selections | grep mysql)
#echo $mysqlstatus
# MYSQL ROOT PASSWORD
echo "Supply password"

root_password_status=$(sudo mysql --user=root -e exit 2>/dev/null || echo "1")
set_password="0"
if [ "$install_webserver_conf" = "Y" ]; then
	#Check if mariadb are installed and running
	if [ -e "/lib/systemd/system/mariadb.service" ]; then
		echo "Mariadb installed "
		#Checks if root password are set
		if [  -z "$root_password_status" ]; then
			echo "Root password is not set "
			echo
			set_password="1"
		else 
			echo "Root password is set"
			echo
			set_password="0"
		fi
	else 
		echo "Mariadb not previously installed"
		echo "Installer will beging now"
		set_password="1"
	fi
	
fi
if [ "$set_password" = "1" ]; then

	while [ $set_password ]
	do
		read -s -p "Enter new root DB password: " db_root_password
		echo ""
		read -s -p "Verify new root DB password: " db_root_password2    
		if [ $db_root_password != $db_root_password2 ]; then
			echo ""
			echo "Not same "
			echo ""
		else 
			echo ""
			echo "Same"
			export $db_root_password
			break
		fi	
	done
fi

# SETTING DEFAULT GIT USER
echo
echo
read -p "Set up new git username and contact email? (Y/n): " set_git_user
if [ "$set_git_user" = "Y" ]; then
  read -p "  Provide git username: " new_git_username
  git config --global user.name "$new_git_username"
  read -p "  Provide contact email for git (This might become public!): " new_git_email
  git config --global user.email "$new_git_email"
fi

read -p "Configure git globally with recommended settings? (Y/n): " set_git_config
if [ "$set_git_config" = "Y" ]; then
  git config --global core.filemode false
  git config --global credential.helper cache
fi


echo
echo
read -p "Set  timezone to Europe/Copenhagen system-wide? (recommended) (Y/n): " set_timezone
if [ "$set_timezone" = "Y" ]; then
  sudo timedatectl set-timezone "Europe/Copenhagen"
fi

echo


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

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites


# INSTALL SOFTWARE
. /srv/tools/scripts/install_software.sh

# INSTALL WEBSERVER CONFIGURATION
. /srv/tools/scripts/install_webserver_configuration-client.sh

# INSTALL FFMPEG
. /srv/tools/scripts/install_ffmpeg.sh

# INSTALL WKHTMLTO
. /srv/tools/scripts/install_wkhtmlto.sh



echo
echo
read -p "Overwrite terminal configuration with recommended settings? (Y/n): " set_terminal_config
if [ "$set_terminal_config" = "Y" ]; then
  echo "Copying terminal configuration"
  echo
  # ADD COMMANDS ALIAS'
  cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile

  install_bash_profile=$(grep -E "HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
  if [ -z "$install_bash_profile" ]; then

    # Add .bash_profile to .bashrc
    echo
    echo "if [ -f \"\$HOME/.bash_profile\" ]; then" >> /home/$install_user/.bashrc
    echo " . \"\$HOME/.bash_profile\"" >> /home/$install_user/.bashrc
    echo "fi" >> /home/$install_user/.bashrc
  fi
fi

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites



echo 
echo
echo "            ------ You are done! ------"
echo

