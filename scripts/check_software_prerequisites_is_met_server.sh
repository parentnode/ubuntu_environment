#!/bin/bash -e

echo
echo "To speed up the process, please select your install options now:"
echo

install_security_array=("[Yn]")
install_security=$(ask "Secure the server (Y/n)" "${install_security_array[@]}" "input secure the server")
export install_security

install_software_array=("[Yn]")
install_software=$(ask "Install Software (Y/n)" "${install_software_array[@]}" "input software")
export install_software


install_webserver_conf_array=("[Yn]")
install_webserver_conf=$(ask "Set up Apache/PHP/MariaDB for user (Y/n)" "${install_webserver_conf_array[@]}" "input apache/php/mariadb")
export install_webserver_conf

install_htpassword_array=("[Yn]")
install_htpassword_for_user=$(ask "Set up .htaccess for user (Y/n)" "${install_htpassword_array[@]}" "input htaccess")
export install_htpassword_for_user

install_ffmpeg_array=("[Yn]")
install_ffmpeg=$(ask "Install FFMPEG (Y/n)" "${install_ffmpeg_array[@]}" "input ffmpeg")
export install_ffmpeg

#read -p "Install wkhtmlto (Y/n): " install_wkhtml
#export install_wkhtml
install_wkhtml_array=("[Yn]")
install_wkhtml=$(ask "Install WKHTMLTOPDF (Y/n)" "${install_wkhtml_array[@]}" "input wkhtml")
export install_wkhtml
#read -p "Install mail (Y/n): " install_mail
#export install_mail

#read -p "Install Let's encrypt (Y/n): " install_letsencrypt
#export install_letsencrypt

#read -p "Your email address: " install_email
#export install_email

outputHandler "comment" "Apache email configuration"
if [ "$(fileExists "/etc/apache2/sites-available/default.conf")" = "true" ]; then 
	outputHandler "comment" "defaul.conf Exist"
	grep_apache_email=$(trimString "$(grep "ServerAdmin" /etc/apache2/sites-available/default.conf)")
    is_there_apache_email=$(echo "$grep_apache_email" | cut -d' ' -f2)
	
	if [ -z "$is_there_apache_email" ]; then 
		echo "No apache email present"
		install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
		install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
		export install_email
	else
		install_email=$is_there_apache_email
		export install_email
	fi

	if [ "$is_there_apache_email" = "webmaster@localhost" ]; then
		echo "apache email is webmaster@localhost"
		install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
		install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
		export install_email
	fi
else 
	install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
	install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
	export install_email
fi


# HTACCESS PASSWORD
if test "$install_htpassword_for_user" = "Y"; then

	#read -s -p "HTACCESS password for $install_user: " install_htaccess_password
	password_array=("[A-Za-z0-9\!\@\$]{8,30}")
	install_htaccess_password=$( ask "HTACCESS password for $install_user" "${password_array[@]}" "password")
	export install_htaccess_password
fi

# SSH PORT
if test "$install_security" = "Y"; then

	# GET CURRENT PORT NUMBER
	port_number=$(grep -E "^Port\ ([0-9]+)$" /etc/ssh/sshd_config | sed "s/Port //;")

	#read -p "Specify SSH port (leave empty to keep $port_number): " install_port
	install_port=$(ask "Specify SSH port (leave empty to keep $port_number)")
	export install_port
	echo

fi
echo "$install_port"
exit
outputHandler "comment" "Apache email configuration"
if [ "$(fileExists "/etc/apache2/sites-available/default.conf")" = "true" ]; then 
	outputHandler "comment" "defaul.conf Exist"
	grep_apache_email=$(trimString "$(grep "ServerAdmin" /etc/apache2/sites-available/default.conf)")
    is_there_apache_email=$(echo "$grep_apache_email" | cut -d' ' -f2)
	
	if [ -z "$is_there_apache_email" ]; then 
		echo "No apache email present"
		install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
		install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
		export install_email
	else
		install_email=$is_there_apache_email
		export install_email
	fi

	if [ "$is_there_apache_email" = "webmaster@localhost" ]; then
		echo "apache email is webmaster@localhost"
		install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
		install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
		export install_email
	fi
else 
	install_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
	install_email=$(ask "Enter Apache email" "${install_email_array[@]}" "apache email")
	export install_email
fi
createOrModifyBashProfile

# MYSQL ROOT PASSWORD
outputHandler "comment" "MariaDB password"
if test "$install_webserver_conf" = "Y"; then
	
	#Check if mariadb are installed and running
	if [ "$(checkMariadbPassword)" = "false" ]; then
		password_array=("[A-Za-z0-9\!\@\$]{8,30}")
		db_root_password1=$( ask "Enter mariadb password" "${password_array[@]}" "password")
		echo ""
		db_root_password2=$( ask "Enter mariadb password again" "${password_array[@]}" "password")
		echo ""

		# While loop if not a match
		if [  "$db_root_password1" != "$db_root_password2"  ]; then
		    while [ true ]
		    do
		        echo "Password doesn't match"
		        echo
		        #password1=$( ask "Enter mariadb password" "${password_array[@]}" "Password")
		        db_root_password1=$( ask "Enter mariadb password" "${password_array[@]}" "password")
		        echo ""
		        db_root_password2=$( ask "Enter mariadb password again" "${password_array[@]}" "password")
		        echo "" 
		        if [ "$db_root_password1" == "$db_root_password2" ];
		        then
		            echo "Password Match"
		            break
		        fi
		        export db_root_password1
		    done
		else
		    echo "Password Match"
			export db_root_password1
		fi
	else 
		outputHandler "comment" "Mariadb password allready set up"
	fi	
fi


# SETTING DEFAULT GIT USER
outputHandler "comment" "Setting Default GIT User setting"
# SETTING DEFAULT GIT USER

# Checks if git credential are allready set, promts for input if not
if [ -z "$(checkGitCredential "name")" ]; then
	git_username_array=("[A-Za-z0-9[:space:]*]{2,50}")
	git_username=$(ask "Enter git username" "${git_username_array[@]}" "git username")
	export git_username
else
	git_username="$(checkGitCredential "name")"
	export git_username
fi
if [ -z "$(checkGitCredential "email")" ]; then
	git_email_array=("[A-Za-z0-9\.\-]+@[A-Za-z0-9\.\-]+\.[a-z]{2,10}")
	git_email=$(ask "Enter git email" "${git_email_array[@]}" "git email")
	export git_email
else
	git_email="$(checkGitCredential "email")"
	export git_email
fi
git config --global core.filemode false
outputHandler "comment" "git core.filemode: $(git config --global core.filemode)"
git config --global user.name "$git_username"
outputHandler "comment" "git user name: $(git config --global user.name)"
git config --global user.email "$git_email"
outputHandler "comment" "git user email: $(git config --global user.email)"
git config --global credential.helper cache
outputHandler "comment" "git credential.helper: $(git config --global credential.helper)"

outputHandler "comment" "Setting Time zone"

look_for_ex_timezone=$(sudo timedatectl status | grep "Time zone: " | cut -d ':' -f2)
if [ -z "$look_for_ex_timezone" ]; then
	outputHandler "comment" "Setting Time zone to Europe/Copenhagen"
	sudo timedatectl set-timezone "Europe/Copenhagen"
else 
	outputHandler "comment" "Existing time zone values: $look_for_ex_timezone"
fi