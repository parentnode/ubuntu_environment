
echo "-----------------------------------------"
echo
echo "               SECURITY"
echo
echo
install_user=$(who am i | awk '{print $1}')


read -p "Secure server (Y/n): " install_security
if test "$install_security" = "Y"; then

	echo

	install_deploy=$(grep -q -E "^deploy:" /etc/group)
	if ! test -z "$install_deploy"; then
		echo "Creating deploy user"

		## CREATE DEPLOY GROUP AND USER
		# CREATE GROUP
		groupadd deploy
		# ADD DEPLOY USER TO GROUP
		useradd -g deploy deploy
		# ADD RELEVANT USERS TO DEPLOY GROUP
		usermod -a -G deploy www-data
		usermod -a -G deploy $install_user
	fi

	if [ ! -d "/home/$install_user/.ssh" ]; then
		# SETUP SSH KEY
		mkdir -p /home/$install_user/.ssh
	fi

	if [ ! -d "/home/$install_user/.key" ]; then
		mv /home/$install_user/.key /home/$install_user/.ssh/authorized_keys
	fi

	# UPDATE PERMISSIONS EVERY TIME
	chown -R $install_user:$install_user /home/$install_user/.ssh
	chmod 700 /home/$install_user/.ssh
	chmod 600 /home/$install_user/.ssh/authorized_keys


	echo
	echo
	read -p "SSH port: " install_port
	if test -z "$install_port"; then

		# SSH CONFIG
		sed -i 's/Port\ \d\+/Port\ "$install_port"/;' /etc/ssh/sshd_config

	fi

	sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/; s/PasswordAuthentication\ yes/PasswordAuthentication\ no/; s/X11Forwarding yes/X11Forwarding no/; s/UsePAM no/UsePAM yes/;' /etc/ssh/sshd_config

	install_ssh_user=$(grep -q -E "\ $install_user" /etc/ssh/sshd_config)
	if test -z "$install_ssh_user"; then
		echo "" >> /etc/ssh/sshd_config
		echo "UseDNS no" >> /etc/ssh/sshd_config
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
