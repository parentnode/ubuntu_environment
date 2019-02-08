#!/bin/bash -e

# INSTALL APACHE
    # Check for server name
	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	# If no results
	if [ -z "$install_apache_servername" ]; then
		guiText "ServerName" "Install"
        # SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
        echo
	else
		# Replace existing servername with hostname
        guiText "ServerName" "Replace" "Hostname"
		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf
        echo
	fi

	
	install_apache_access_for_srv_sites=$(grep -E "^<Directory /srv/sites>" /etc/apache2/apache2.conf || echo "")
	if [ -z "$install_apache_access_for_srv_sites" ]; then
		# Give access to /srv/sites folder from the apache configuration added to bottom of /etc/apache2/apache2.conf
		guiText "access to /srv/sites" "Install"
		echo "" >> /etc/apache2/apache2.conf
		echo "<Directory "/srv/sites">" >> /etc/apache2/apache2.conf
		echo "	Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/apache2.conf
		echo "	AllowOverride All" >> /etc/apache2/apache2.conf
		echo "	Require all granted" >> /etc/apache2/apache2.conf
		echo "</Directory>" >> /etc/apache2/apache2.conf
    	echo "" >> /etc/apache2/apache2.conf
		
	else
		guiText "access to /srv/sites" "Installed"
	fi

	# remove path (slashes) from output to avoid problem with testing string
    install_parentnode_includes=$(grep "^IncludeOptional \/srv\/sites\/apache\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/sites\/apache\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then
		# ADD GIT CONF SETUP
        guiText "GIT configuration" "Install"
		echo "IncludeOptional /srv/sites/apache/*.conf" >> /etc/apache2/apache2.conf
		echo
	fi


	# ADD DEFAULT APACHE CONF
	guiText "default parentNode apache conf" "Install"
	cat /srv/tools/conf-client/default.conf > /etc/apache2/sites-available/default.conf
	
	guiText "default mail" "Replace" "Mail you entered earlier"
	# REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	

	# ADD APACHE MODULES
    guiText "apache modules" "Enable"
	guiText "SSL" "Enable"
	a2enmod ssl
	guiText "Rewrite" "Enable"
	a2enmod rewrite
	guiText "Headers" "Enable"
	a2enmod headers

	# ENABLE DEFAULT SITE
	echo
    guiText "default site" "Enable"
    a2ensite default
	echo
	# DISABLE ORG DEFAULT SITE
    guiText "original default site" "Disable"
    a2dissite 000-default

