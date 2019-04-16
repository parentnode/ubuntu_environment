#!/bin/bash -e

echo "--------------------------------------------------------------"
echo ""
echo "Installing parentNode in ubuntu"
echo "DO NOT CLOSE UNTIL INSTALL ARE COMPLETE" 
echo "You will see 'Install complete' message once it's done"
echo ""
echo ""


# GET INSTALL USER
install_user=$SUDO_USER
#$(whoami | awk '{print $1}')
export install_user


source /srv/tools/scripts/functions.sh
guiText "Installing system for $install_user" "Comment"
guiText "To speed up the process, please select your install options now:" "Section"

read -p "Install software (Y/n): " install_software
export install_software
echo
read -p "Set up Apache/PHP/MariaDB (Y/n): " install_webserver_conf
export install_webserver_conf
echo
read -p "Install ffmpeg (Y/n): " install_ffmpeg
export install_ffmpeg
echo
read -p "Install wkhtmlto (Y/n): " install_wkhtml
export install_wkhtml

if [ -f "/etc/apache2/sites-enabled/default.conf" ];
then 
	guiText "default.conf" "Exist" "server admin mail"
	install_email=$(grep "ServerAdmin" /etc/apache2/sites-enabled/default.conf | cut -d " " -f2 || echo "")
	#export server_admin_mail
	echo "Mail for apache is: $install_email"
	if [ -z "$install_email" ] || [ "$install_email" = "webmaster@localhost" ];
	then
		guiText "Please enter your email for apache installation" "Comment"
		read -p "Your email address: " install_email
		export install_email
	else 
		guiText "Apache email" "Installed"
		#install_email = "$install_email"
		export install_email
	fi
else
	guiText "Please enter your email for apache installation" "Comment"
	read -p "Your email address: " install_email
	export install_email
fi

echo 

if [ -f "$HOME/.bash_profile" ];
then
	guiText ".bash_profile" "Exist"
	guiText "Pressing n will only add aliases needed for later use, but it might require professional use" "Comment"
	read -p "Do you wan't to add parentnode configuration to your .bash_profile (Y/n): " use_parentnode_dot_bash_profile
	export use_parentnode_dot_bash_profile
else
	guiText "parentnode terminal" "Install"
	sudo cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
	install_bash_profile=$(grep -E ". $HOME/.bash_profile" /$HOME/.bashrc || echo "")
	#install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
	if [ -z "$install_bash_profile" ]; then
		guiText ".bash_profile" "Install" ".bashrc"
		# Add .bash_profile to .bashrc

		echo
		echo "if [ -f \"$HOME/.bash_profile\" ]; then" >> /$HOME/.bashrc
		echo " . $HOME/.bash_profile" >> $HOME/.bashrc
		echo "fi" >> $HOME/.bashrc
	else
		guiText ".bash_profile" "Installed"
	fi
fi

guiText "Setting up your terminal" "Section"

if test "$use_parentnode_dot_bash_profile" = "Y";
then
	guiText "Terminal" "Install"
	. /srv/tools/scripts/install_promt.sh
else 
	guiText "Adding alias" "Comment"
	checkAlias "/home/$install_user/.bash_profile" "/srv/tools/conf-client/dot_bash_profile"
fi

# MYSQL ROOT PASSWORD
if [ -f "/srv/tools/scripts/password.txt" ];then
	echo "Removing temp file"
	sudo rm /srv/tools/scripts/password.txt
fi

root_password_status=$(sudo mysql --user=root -e exit 2>/srv/tools/scripts/password.txt)
test_password=$(grep "using password: NO" /srv/tools/scripts/password.txt || echo "")

echo
#set_password="0"
if test "$install_webserver_conf" = "Y"; then
	#Check if mariadb are installed and running
	if [ -e "/lib/systemd/system/mariadb.service" ]; then
		guiText "MariaDB" "Installed"
		#Checks if root password are set
		if [ -z "$test_password" ]; then
			echo "Root password is not set "
			echo
			set_password="1"
			export set_password
		else 
			echo "Root password is set"
			echo
			set_password="0"
			export set_password
		fi
	else 
		echo "Mariadb not previously installed"
		set_password="1"
		export set_password
		echo ""
	fi
	
fi


if test "$set_password" = "1"; then
	while [ $set_password ]
	do
		guiText "Password's can only start with an letter and contain letters and numbers [0-9]" "Section"
		read -s -p "Enter new root DB password: " db_root_password
		echo
		read -s -p "Verify new root DB password: " db_root_password2    
		if [ $db_root_password != $db_root_password2 ]; then
			guiText "Not a match" "Comment"
		else 
			guiText "Match" "Comment"
			export db_root_password
			break
		fi	
	done
fi
guiText "Cleaning up temporary files" "Comment"
sudo rm /srv/tools/scripts/password.txt

# SETTING DEFAULT GIT USER
guiText "Setting Default GIT USER" "Section"
git config --global core.filemode false
#git config --global user.name "$install_user"
#git config --global user.email "$install_email"

# Checks if git credential are allready set, promts for input if not
gitConfigured "name"
gitConfigured "email"

git config --global credential.helper cache

guiText "Time zone" "Section"

look_for_ex_timezone=$(sudo timedatectl status | grep "Time zone: " | cut -d ':' -f2)
if [ -z "$look_for_ex_timezone" ];
then
	guiText "Setting timezone to: Europe/Copenhagen" "Comment"
	sudo timedatectl set-timezone "Europe/Copenhagen"
else 
	guiText "Allready set" "Comment"
fi

#create_folder_if_no_exist
checkFolderOrCreate "/srv/sites"
checkFolderOrCreate "/srv/sites/apache"
checkFolderOrCreate "/srv/sites/apache/logs"
checkFolderOrCreate "/srv/sites/parentnode"

# Change Folder Rights from root to current user
guiText "Change Folder rights from root to your curent user" "Comment"
chown -R $SUDO_USER:$SUDO_USER /srv/sites

guiText "Software" "Section"

guiText "Software" "Start"
# INSTALL SOFTWARE
. /srv/tools/scripts/install_software.sh
. /srv/tools/scripts/install_webserver_configuration_client.sh




# Change Folder Rights from root to current user
guiText "Changing folder rights from root to current user" "Comment"
chown -R $SUDO_USER:$SUDO_USER /srv/sites



echo ""
echo "parentNode installed in Ubuntu "
echo ""
guiText "ubuntu" "Link" "ubuntu-client"
echo "Install complete"
echo "--------------------------------------------------------------"
echo ""

