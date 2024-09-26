#!/bin/bash -e

outputHandler "comment" "SECURITY"

if [ "$install_security" = "Y" ]; then


	# ## CREATE DEPLOY GROUP AND USER
	install_deploy=$(grep -E "^deploy:" /etc/group || echo "")
	if [ -z "$install_deploy" ]; then

		outputHandler "comment" "Creating deploy user"
		# CREATE GROUP
		groupadd deploy
		# ADD DEPLOY USER TO GROUP
		useradd -g deploy deploy
		# ADD RELEVANT USERS TO DEPLOY GROUP
		usermod -a -G deploy www-data
	fi


	# ADD CURRENT USER TO DEPLOY GROUP
	install_deploy_user=$(grep -E "^deploy:.+$install_user" /etc/group || echo "")
	if [ -z "$install_deploy_user" ]; then
		outputHandler "comment" "Adding $install_user to deploy group"
		usermod -a -G deploy $install_user
	fi


	# SETUP SSH KEY
	if [ ! -d "/home/$install_user/.ssh" ]; then
		mkdir -p /home/$install_user/.ssh
	fi


	# IS TEMP KEY AVAILABLE
	if [ -e "/home/$install_user/.key" ]; then

		outputHandler "comment" "Installing key"
		mv /home/$install_user/.key /home/$install_user/.ssh/authorized_keys
	fi


	# UPDATE PERMISSIONS EVERY TIME
	chown -R $install_user:$install_user /home/$install_user/.ssh
	chmod 700 /home/$install_user/.ssh
	chmod 600 /home/$install_user/.ssh/authorized_keys


	# UPDATE SSH PORT
	if test -n "$install_port"; then

		outputHandler "comment" "Updating port to: $install_port"
		# SSH CONFIG
		sed -i "s/[#]\?Port\ [0-9]\+/Port\ $install_port/;" /etc/ssh/sshd_config

	fi

	# UPDATE ADDITIONAL SETTING
	sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/;' /etc/ssh/sshd_config
	sed -i 's/[#]\?PasswordAuthentication\ yes/PasswordAuthentication\ no/;' /etc/ssh/sshd_config
	sed -i 's/X11Forwarding yes/X11Forwarding no/;' /etc/ssh/sshd_config
	sed -i 's/UsePAM no/UsePAM yes/;' /etc/ssh/sshd_config
	sed -i 's/[#]\?UseDNS no/UseDNS no/;' /etc/ssh/sshd_config
	sed -i 's/[#]\?LoginGraceTime\ 2m/LoginGraceTime\ 30s/;' /etc/ssh/sshd_config



	# ADD ALLOWUSERS STATMENT
	install_ssh_allowed_users=$(grep -E "^AllowUsers" /etc/ssh/sshd_config || echo "")
	if test -z "$install_ssh_allowed_users"; then
		outputHandler "comment" "Adding AllowUsers and $install_user to sshd_config"
		echo "AllowUsers "$install_user >> /etc/ssh/sshd_config

	# USERS ARE ALLOWED
	else

		# IS CURRENT USER ALLOWED
		install_ssh_user=$(grep -E "^AllowUsers.*[\ ]$install_user(\ |$)" /etc/ssh/sshd_config || echo "")
		if test -z "$install_ssh_user"; then
			outputHandler "comment" "Adding $install_user to AllowUsers"
			echo "$install_ssh_allowed_users $install_user" >> /etc/ssh/sshd_config
		fi

	fi



	if [ ! -e "/etc/iptables.up.rules" ]; then

		outputHandler "comment" "Copying default rules for IP TABLES"

		cp /srv/tools/conf/iptables.rules /etc/iptables.up.rules



	fi

	if test -n "$install_port"; then

		outputHandler "comment" "Updating SSH port access"
		sed -i "s/NEW\ -m\ tcp\ --dport\ [0-9]\+/NEW\ -m\ tcp\ --dport\ $install_port/;" /etc/iptables.up.rules

	fi


	outputHandler "comment" "Checking IP TABLES"

	# RESTORE IPTABLES
	iptables-restore < /etc/iptables.up.rules

	# SHOW IPTABLES
	iptables -L

	# SAVE NEW IPTABLES
	iptables-save -c > /etc/iptables/rules.v4

	# iptables-persistant will load iptables on boot from ubuntu 22
	# if [ ! -e "/etc/network/if-pre-up.d/iptables" ]; then
	#
	# 	outputHandler "comment" "Enable IP TABLE on boot"
	#
	# 	# LOAD ON BOOT
	# 	echo "#!/bin/sh" >> /etc/network/if-pre-up.d/iptables
	# 	echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
	# 	chmod +x /etc/network/if-pre-up.d/iptables
	#
	# fi

	outputHandler "comment" "Restarting SSH service"

	#
	# RESTART SSH
	service ssh restart

else
	outputHandler "comment" "Skipping security"

fi
