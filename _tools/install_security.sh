
echo "-----------------------------------------"
echo
echo "               SECURITY"
echo
grep -q -E "^deploy:" /etc/group

read -p "Secure server (Y/n): " install_security
if test "$install_security" = "Y"; then

	echo
	echo "Creating deploy user"

	## CREATE DEPLOY GROUP AND USER
	# CREATE GROUP
	groupadd deploy
	# ADD DEPLOY USER TO GROUP
	useradd -g deploy deploy
	# ADD RELEVANT USERS TO DEPLOY GROUP
	usermod -a -G deploy www-data
	usermod -a -G deploy $install_user


	# SETUP SSH KEY
	mkdir -p /home/$install_user/.ssh

	mv /home/$install_user/.key /home/$install_user/.ssh/authorized_keys

	chown -R $install_user:$install_user /home/$install_user/.ssh
	chmod 700 /home/$install_user/.ssh
	chmod 600 /home/$install_user/.ssh/authorized_keys


	# SSH CONFIG
	sed -i 's/Port\ 22/Port\ 30011/; s/PermitRootLogin\ yes/PermitRootLogin\ no/; s/PasswordAuthentication\ yes/PasswordAuthentication\ no/; s/X11Forwarding yes/X11Forwarding no/; s/UsePAM no/UsePAM yes/;' /etc/ssh/sshd_config
	echo "" >> /etc/ssh/sshd_config
	echo "UseDNS no" >> /etc/ssh/sshd_config
	echo "AllowUsers "$install_user >> /etc/ssh/sshd_config


	echo
	echo "IP TABLES"

	# RESTORE IPTABLES
	iptables-restore < /srv/tools/configuration/iptables.rules

	# SHOW IPTABLES
	iptables -L

	# SAVE NEW IPTABLES
	iptables-save > /etc/iptables.up.rules

	# LOAD ON BOOT
	echo "#!/bin/sh" >> /etc/network/if-pre-up.d/iptables
	echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
	chmod +x /etc/network/if-pre-up.d/iptables


	# RESTART SSH
	service ssh restart

else
	echo "Skipping security"
fi
