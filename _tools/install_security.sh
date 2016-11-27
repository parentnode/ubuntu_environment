
echo "-----------------------------------------"
echo
echo "               SECURITY"
echo
echo
install_user=$(who am i | awk '{print $1}')


read -p "Secure server (Y/n): " install_security
if test "$install_security" = "Y"; then

	echo


	## CREATE DEPLOY GROUP AND USER
	install_deploy=$(grep -E "^deploy:" /etc/group)
	if test -z "$install_deploy"; then

		echo "Creating deploy user"
		echo

		# CREATE GROUP
		groupadd deploy
		# ADD DEPLOY USER TO GROUP
		useradd -g deploy deploy
		# ADD RELEVANT USERS TO DEPLOY GROUP
		usermod -a -G deploy www-data
	fi


	# ADD CURRENT USER TO DEPLOY GROUP
	install_deploy_user=$(grep -E "^deploy:.+$install_user" /etc/group)
	if test -z "$install_deploy_user"; then
		echo "Adding $install_user to deploy group"
		usermod -a -G deploy $install_user
	fi


	# SETUP SSH KEY
	if [ ! -d "/home/$install_user/.ssh" ]; then
		mkdir -p /home/$install_user/.ssh
	fi

	# IS TEMP KEY AVAILABLE
	if [ -b "/home/$install_user/.key" ]; then
		mv /home/$install_user/.key /home/$install_user/.ssh/authorized_keys
	fi

	# UPDATE PERMISSIONS EVERY TIME
	chown -R $install_user:$install_user /home/$install_user/.ssh
	chmod 700 /home/$install_user/.ssh
	chmod 600 /home/$install_user/.ssh/authorized_keys


	# UPDATE SSH PORT
	echo
	echo "Change SSH port (leave empty to leave unchanged)"
	read -p "SSH port: " install_port
	if test -n "$install_port"; then

		echo
		echo "Updating port to: $install_port"
		# SSH CONFIG
#		sed -i 's/Port\ 22/Port\ '+"$install_port"+'/;' /etc/ssh/sshd_config
#		sed -i "s/Port\ \digit\+/Port\ $install_port/;" /etc/ssh/sshd_config
		sed -i "s/Port\ 333/Port\ $install_port/;" /etc/ssh/sshd_config

	fi


	sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/;' /etc/ssh/sshd_config
	sed -i 's/PasswordAuthentication\ yes/PasswordAuthentication\ no/;' /etc/ssh/sshd_config
	sed -i 's/X11Forwarding yes/X11Forwarding no/;' /etc/ssh/sshd_config
	sed -i 's/UsePAM no/UsePAM yes/;' /etc/ssh/sshd_config


	install_no_dns=$(grep -E "^UseDNS no$" /etc/ssh/sshd_config)
	echo "install_no_dns=$install_no_dns"
	if [ -z "$install_no_dns" ]; then
		echo "installing_no_dns=$install_no_dns"

		echo "" >> /etc/ssh/sshd_config
		echo "UseDNS no" >> /etc/ssh/sshd_config
	fi


	install_ssh_allowed_users=$(grep -E "^AllowUsers" /etc/ssh/sshd_config)

	echo "AllUs: $install_ssh_allowed_users"


	install_ssh_user=$(grep -E "\ $install_user" /etc/ssh/sshd_config)
	echo "install_ssh_user=$install_ssh_user"
	# is $install_ssh_user empty, user was not found
	if test -z "$install_ssh_user"; then
		echo "AllowUsers "$install_user >> /etc/ssh/sshd_config
	fi


	# echo
	# echo
	# echo "Setup IP TABLES"
	# echo
	#
	# # RESTORE IPTABLES
	# iptables-restore < /srv/tools/configuration/iptables.rules
	#
	# # SHOW IPTABLES
	# iptables -L
	#
	# # SAVE NEW IPTABLES
	# iptables-save > /etc/iptables.up.rules
	#
	# # LOAD ON BOOT
	# echo "#!/bin/sh" >> /etc/network/if-pre-up.d/iptables
	# echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
	# chmod +x /etc/network/if-pre-up.d/iptables
	#

	# echo
	# echo
	# echo "Restarting service"
	# echo
	#
	# # RESTART SSH
	# service ssh restart

else
	echo "Skipping security"
fi
