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


# echo
# echo "SUDO USER:$SUDO_USER"
# echo
# echo

source /srv/tools/scripts/functions.sh
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
echo "-------------------------------------------------------"
echo "Please enter the information required for your install:"
echo "-------------------------------------------------------"


#read -p "Your email address: " install_email
#export install_email
#echo

#dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)
#mysqlstatus=$(dpkg --get-selections | grep mysql)
#echo $mysqlstatus
# MYSQL ROOT PASSWORD
echo "Supply password"

root_password_status=$(sudo mysql --user=root -e exit 2>/dev/null || echo "")
#set_password="0"
if test "$install_webserver_conf" = "Y"; then
	#Check if mariadb are installed and running
	if [ -e "/lib/systemd/system/mariadb.service" ]; then
		echo "Mariadb installed "
		#Checks if root password are set
		if [ -z "$root_password_status" ]; then
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
		echo "Installer will begin now"
		set_password="1"
		export set_password
		echo ""
	fi
	
fi
if test "$set_password" = "1"; then
	while [ $set_password ]
	do
		echo "Password's can only start with an letter and contain letters and numbers [0-9]"
		echo ""
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
			export db_root_password
			break
		fi	
	done
fi

# SETTING DEFAULT GIT USER
git config --global core.filemode false
#git config --global user.name "$install_user"
#git config --global user.email "$install_email"

# Checks if git credential are allready set, promts for input if not
git_configured "name"
git_configured "email"

git config --global credential.helper cache



echo
echo
echo "Setting timezone to: Europe/Copenhagen"
echo
sudo timedatectl set-timezone "Europe/Copenhagen"


checkPath()
{
	path=$1	
	if [ ! -d "$path" ]; then
		mkdir $path
		echo "Path: $path created"
	else 
		echo "Allready Exist"
	fi
}
#create_folder_if_no_exist
#checkPath "/srv/sites"
#checkPath "/srv/sites/apache"
#checkPath "/srv/sites/apache/logs"
#checkPath "/srv/sites/parentnode"
checkFolderOrCreate "/srv/sites"
checkFolderOrCreate "/srv/sites/apache"
checkFolderOrCreate "/srv/sites/apache/logs"
checkFolderOrCreate "/srv/sites/parentnode"

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites


# INSTALL SOFTWARE
. /srv/tools/scripts/install_software.sh

echo
echo
echo "Copying terminal configuration"
echo
# ADD COMMANDS ALIAS'
#cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile
# Takes a string and removes leading and following tabs and spaces
trimString(){
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
checkFileContent() 
{
	#dot_profile
	file=$1
	#bash_profile.default
	default=$2
	echo "Updating $file"
	# Splits output based on new lines
	IFS=$'\n'
	# Reads all of default int to an variable
	default=$( < "$default" )

	# Every key value pair looks like this (taken from bash_profile.default )
	# "alias mysql_grant" alias mysql_grant="php /srv/tools/scripts/mysql_grant.php"
	# The key komprises of value between the first and second quotation '"'
	default_keys=( $( echo "$default" | grep ^\" |cut -d\" -f2))
	# The value komprises of value between the third, fourth and fifth quotation '"'
	default_values=( $( echo "$default" | grep ^\" |cut -d\" -f3,4,5))
	unset IFS
	
	for line in "${!default_keys[@]}"
	do		
		# do dot_profile contain any of the keys in bash_profile.default
		check_for_key=$(grep -R "${default_keys[line]}" "$file")
		# if there are any default keys in dot_profile
		if [[ -n $check_for_key ]];
		then
			# Update the values connected to the key
			sed -i -e "s,${default_keys[line]}\=.*,$(trimString "${default_values[line]}"),g" "$file"
			
		fi
		
	done
	
}
if [ ! -f "$HOME/.bash_profile" ]; 
then
	cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
fi

checkFileContent "/home/$install_user/.bash_profile" "/srv/tools/conf-client/dot_bash_profile"

install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
if [ -z "$install_bash_profile" ]; then

	# Add .bash_profile to .bashrc
	echo
	echo "if [ -f \"\$HOME/.bash_profile\" ]; then" >> /home/$install_user/.bashrc
	echo " . \"\$HOME/.bash_profile\"" >> /home/$install_user/.bashrc
	echo "fi" >> /home/$install_user/.bashrc
fi

# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites



echo ""
echo "parentNode installed in Ubuntu "
echo ""
echo "Install complete"
echo "--------------------------------------------------------------"
echo ""

