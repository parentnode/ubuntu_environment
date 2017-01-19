#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               SECURITY"
echo
echo


if [ "$install_security" = "Y" ]; then

	echo "test"


	# ## CREATE DEPLOY GROUP AND USER
#	install_deploy=$(grep -E "^deploy:" /etc/group)
	install_deploy=1
	if [ -z "$install_deploy" ]; then

		echo "Creating deploy user"
		echo
	#
	# 	# CREATE GROUP
	# 	groupadd deploy
	# 	# ADD DEPLOY USER TO GROUP
	# 	useradd -g deploy deploy
	# 	# ADD RELEVANT USERS TO DEPLOY GROUP
	# 	usermod -a -G deploy www-data
	fi
	echo "test2"
	#
	# # ADD CURRENT USER TO DEPLOY GROUP
	# install_deploy_user=$(grep -E "^deploy:.+$install_user" /etc/group)
	# if test -z "$install_deploy_user"; then
	# 	echo "Adding $install_user to deploy group"
	# 	echo
	# 	usermod -a -G deploy $install_user
	# fi
	#
	#
	# # SETUP SSH KEY
	# if [ ! -d "/home/$install_user/.ssh" ]; then
	# 	mkdir -p /home/$install_user/.ssh
	# fi
	#
	#
	# # IS TEMP KEY AVAILABLE
	# if [ -e "/home/$install_user/.key" ]; then
	#
	# 	echo "Installing key"
	# 	echo
	# 	mv /home/$install_user/.key /home/$install_user/.ssh/authorized_keys
	# fi
	#
	#
	# # UPDATE PERMISSIONS EVERY TIME
	# chown -R $install_user:$install_user /home/$install_user/.ssh
	# chmod 700 /home/$install_user/.ssh
	# chmod 600 /home/$install_user/.ssh/authorized_keys
	#
	#
	# # UPDATE SSH PORT
	# if test -n "$install_port"; then
	#
	# 	echo
	# 	echo "Updating port to: $install_port"
	# 	# SSH CONFIG
	# 	sed -i "s/Port\ [0-9]\+/Port\ $install_port/;" /etc/ssh/sshd_config
	#
	# fi
	#
	# # UPDATE ADDITIONAL SETTING
	# sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/;' /etc/ssh/sshd_config
	# sed -i 's/PasswordAuthentication\ yes/PasswordAuthentication\ no/;' /etc/ssh/sshd_config
	# sed -i 's/X11Forwarding yes/X11Forwarding no/;' /etc/ssh/sshd_config
	# sed -i 's/UsePAM no/UsePAM yes/;' /etc/ssh/sshd_config
	#
	#
	# # WAS THE NO DNS STATEMENT ADDED
	# install_no_dns=$(grep -E "^UseDNS no$" /etc/ssh/sshd_config)
	# if [ -z "$install_no_dns" ]; then
	# 	echo "Adding: UseDNS no"
	#
	# 	echo "" >> /etc/ssh/sshd_config
	# 	echo "UseDNS no" >> /etc/ssh/sshd_config
	# fi
	#
	#
	# # ADD ALLOWUSERS STATMENT
	# install_ssh_allowed_users=$(grep -E "^AllowUsers" /etc/ssh/sshd_config)
	# if test -z "$install_ssh_allowed_users"; then
	# 	echo
	# 	echo "Adding AllowUsers and $install_user to sshd_config"
	# 	echo "AllowUsers "$install_user >> /etc/ssh/sshd_config
	#
	# # USERS ARE ALLOWED
	# else
	#
	# 	# IS CURRENT USER ALLOWED
	# 	install_ssh_user=$(grep -E "^AllowUsers.*[\ ]$install_user(\ |$)" /etc/ssh/sshd_config)
	# 	if test -z "$install_ssh_user"; then
	# 		echo
	# 		echo "Adding $install_user to AllowUsers"
	# 		echo "$install_ssh_allowed_users $install_user" >> /etc/ssh/sshd_config
	# 	fi
	#
	# fi
	#
	#
	#
	# if [ ! -e "/etc/iptables.up.rules" ]; then
	#
	#
	# 	echo
	# 	echo "Copying default rules for IP TABLES"
	#
	# 	cp /srv/tools/_conf/iptables.rules /etc/iptables.up.rules
	#
	#
	#
	# fi
	#
	# if test -n "$install_port"; then
	#
	# 	echo
	# 	echo "Updating SSH port access"
	# 	sed -i "s/NEW\ -m\ tcp\ --dport\ [0-9]\+/NEW\ -m\ tcp\ --dport\ $install_port/;" /etc/iptables.up.rules
	#
	# fi
	#
	#
	# echo
	# echo "Checking IP TABLES"
	# echo
	#
	# # RESTORE IPTABLES
	# iptables-restore < /etc/iptables.up.rules
	#
	# # SHOW IPTABLES
	# iptables -L
	#
	# # SAVE NEW IPTABLES
	# iptables-save > /etc/iptables.up.rules
	#
	#
	# if [ ! -e "/etc/network/if-pre-up.d/iptables" ]; then
	#
	# 	echo "Enable IP TABLE on boot"
	# 	echo
	#
	# 	# LOAD ON BOOT
	# 	echo "#!/bin/sh" >> /etc/network/if-pre-up.d/iptables
	# 	echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
	# 	chmod +x /etc/network/if-pre-up.d/iptables
	#
	# fi
	#
	#
	# echo
	# echo "Restarting SSH service"
	# echo
	# echo
	#
	# #
	# # # RESTART SSH
	# service ssh restart

else

	echo
	echo "Skipping security"
	echo
	echo

fi
