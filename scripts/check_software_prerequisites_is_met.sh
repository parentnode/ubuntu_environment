#!/bin/bash -e
outputHandler "section" "To speed up the process, please select your install options now:"
install_software_array=("[Yn]")
install_software=$(ask "Install Software (Y/n)" "${install_software_array[@]}" "install_software")
export install_software

install_webserver_conf_array=("[Yn]")
install_webserver_conf=$(ask "Install Webserver Configuration (Y/n)" "${install_webserver_conf_array[@]}" "install_webserver_conf")
export install_webserver_conf

install_ffmpeg_array=("[Yn]")
install_ffmpeg=$(ask "Install FFMPEG (Y/n)" "${install_webserver_conf_array[@]}" "ffmpeg")
export install_ffmpeg

install_wkhtml_array=("[Yn]")
install_wkhtml=$(ask "Install WKHTMLTOPDF (Y/n)" "${install_webserver_conf_array[@]}" "wkhtml")
export install_wkhtml

# Uncomment when done testing
#outputHandler "section" "Apache email configuration"
#if [ "$(fileExists "/etc/apache2/sites-enabled/default.conf")" = "true" ]; then 
#	outputHandler "comment" "defaul.conf Exist"
#	apache_email=$(grep "ServerAdmin" /etc/apache2/sites-enabled/default.conf | cut -d " " -f2 || echo "")
#	#export server_admin_mail
#	#echo "Mail for apache is: $apache_email"
#	
#	if [ -z "$apache_email" ] || [ "$apache_email" = "webmaster@localhost" ];
#	then
#		apache_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
#		apache_email=$(ask "Enter Apache email" "${apache_email_array[@]}" "apache_email")
#		export apache_email
#	else 
#		outputHandler "comment" "Apache email Installed"
#		#install_email = "$install_email"
#		#echo "Mail for apache is: $apache_email"
#		export apache_email
#	fi
#else
#    apache_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
#	apache_email=$(ask "Enter Apache email" "${apache_email_array[@]}" "apache_email")
#	export apache_email
#fi

createOrModifyBashProfile

outputHandler "section" "MariaDB password"
if test "$install_webserver_conf" = "Y"; then
	
	#Check if mariadb are installed and running
	if [ "$(checkMariadbPassword)" = "false" ]; then
		password_array=("[A-Za-z0-9\!\@\$]{8,30}")
		password1=$( ask "Enter mariadb password" "${password_array[@]}" "password")
		echo ""
		password2=$( ask "Enter mariadb password again" "${password_array[@]}" "password")
		echo ""

		# While loop if not a match
		if [  "$password1" != "$password2"  ]; then
		    while [ true ]
		    do
		        echo "Password doesn't match"
		        echo
		        #password1=$( ask "Enter mariadb password" "${password_array[@]}" "Password")
		        password1=$( ask "Enter mariadb password" "${password_array[@]}" "password")
		        echo ""
		        password2=$( ask "Enter mariadb password again" "${password_array[@]}" "password")
		        echo "" 
		        if [ "$password1" == "$password2" ];
		        then
		            echo "Password Match"
		            break
		        fi
		        export password1
		    done
		else
		    echo "Password Match"
			export password1
		fi
	else 
		outputHandler "comment" "Mariadb password allready set up"
	fi	
fi


outputHandler "section" "Setting Default GIT User setting"
# SETTING DEFAULT GIT USER

# Checks if git credential are allready set, promts for input if not
if [ -z "$(checkGitCredential "name")" ]; then
	git_username_array=("[A-Za-z0-9[:space:]*]{2,50}")
	git_username=$(ask "Enter git username" "${git_username_array[@]}" "gitusername")
	export git_username
else
	git_username="$(checkGitCredential "name")"
	export git_username
fi
if [ -z "$(checkGitCredential "email")" ]; then
	git_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
	git_email=$(ask "Enter git email" "${git_email_array[@]}" "gitemail")
	export git_email
else
	git_email="$(checkGitCredential "email")"
	export git_email
fi

git config --global core.filemode false
outputHandler "comment" "git core.filemode: $(git config --global core.filemode)"
git config --global user.name "$git_username"
outputHandler "comment" "git user.name: $(git config --global user.name)"
git config --global user.email "$git_email"
outputHandler "comment" "git user.email: $(git config --global user.email)"
git config --global credential.helper cache
outputHandler "comment" "git credential.helper: $(git config --global credential.helper)"

outputHandler "section" "Setting Time zone"

look_for_ex_timezone=$(sudo timedatectl status | grep "Time zone: " | cut -d ':' -f2)
if [ -z "$look_for_ex_timezone" ];
then
	outputHandler "comment" "Setting Time zone to Europe/Copenhagen"
	sudo timedatectl set-timezone "Europe/Copenhagen"
else 
	outputHandler "comment" "Existing time zone values: $look_for_ex_timezone"
fi
