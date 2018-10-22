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


read -p "Your email address: " install_email
export install_email
echo

#dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)
#mysqlstatus=$(dpkg --get-selections | grep mysql)
#echo $mysqlstatus
# MYSQL ROOT PASSWORD
echo "Supply password"


#Checks if root password are set



dbstatus=$(sudo mysql --user=mysql -e exit 2>/dev/null || echo 1)


#echo "dbstatus: $dbstatus"
#echo "Mysql status: $mysqlstatus"
#echo "Initiate mariadb install"

#new
case "$install_webserver_conf" in
	"Y")
		if [ -d "/var/lib/mysql" ]; then
			echo "Mariadb installed "
			
		else
			echo "mariadb not installed"
			if [ -z "$dbstatus" ]; then
				echo "Root password not set" 
				while [ true ]
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
			else			
				echo "Maybe you allready have set your password"
				 
			fi
		fi ;;
	"n")
		echo "Skipping mysql setup" ;;
esac

#Newer but still old
#if [ "$install_webserver_conf" = "Y" ] && [ -z "$dbstatus" ]; then
#	while [ true ]
#	do
#		read -s -p "Enter new root DB password: " db_root_password
#		echo ""
#		read -s -p "Verify new root DB password: " db_root_password2    
#		if [ $db_root_password != $db_root_password2 ]; then
#			echo ""
#			echo "Not same "
#			echo ""
#		else 
#			echo ""
#			echo "Same"
#			export $db_root_password
#			break
#		fi	
#	done
#fi

#Old
#if [ "$install_webserver_conf" = "Y" ] && [ -z "$dbstatus" ]; then
#
#	read -s -p "Enter new root DB password: " db_root_password
#	export db_root_password
#	echo
#
#fi




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

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites


# INSTALL SOFTWARE
. /srv/tools/scripts/install_software.sh

# INSTALL WEBSERVER CONFIGURATION
#. /srv/tools/scripts/install_webserver_configuration-client.sh

# INSTALL FFMPEG
. /srv/tools/scripts/install_ffmpeg.sh

# INSTALL WKHTMLTO
. /srv/tools/scripts/install_wkhtmlto.sh



echo
echo
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

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites



echo 
echo
echo "            ------ You are done! ------"
echo

