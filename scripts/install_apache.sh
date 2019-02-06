#!/bin/bash -e

# INSTALL APACHE
	echo
    echo "Installing apache"
    sudo apt install -y apache2 apache2-utils ssl-cert
    echo

    echo
    echo "Configuring apache"
	echo
    # Check for server name
	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	# If no results
	if [ -z "$install_apache_servername" ]; then
        echo
		echo "Setting servername in apache"
        # SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
        echo
	else
		# Replace existing servername with hostname
        echo 
        echo "Replacing existing servername with hostname"
		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf
        echo
	fi

	
	install_apache_access_for_srv_sites=$(grep -E "^<Directory \"/srv/sites\">" /etc/apache2/apache2.conf || echo "")
	if [ -z "$install_apache_access_for_srv_sites" ]; then
		# Give access to /srv/sites folder from the apache configuration added to bottom of /etc/apache2/apache2.conf
		echo 
		echo "Granting access for e.g. asset builder into /srv/sites"
		echo
		
		echo "" >> /etc/apache2/apache2.conf
		echo "<Directory "/srv/sites">" >> /etc/apache2/apache2.conf
		echo "	Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/apache2.conf
		echo "	AllowOverride All" >> /etc/apache2/apache2.conf
		echo "	Require all granted" >> /etc/apache2/apache2.conf
		echo "</Directory>" >> /etc/apache2/apache2.conf
    	echo "" >> /etc/apache2/apache2.conf
	fi

	# remove path (slashes) from output to avoid problem with testing string
    install_parentnode_includes=$(grep "^IncludeOptional \/srv\/sites\/apache\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/sites\/apache\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then

		# ADD GIT CONF SETUP
        echo
        echo "Add git configuration to apache"
        echo

		echo "IncludeOptional /srv/sites/apache/*.conf" >> /etc/apache2/apache2.conf

	fi


	# ADD DEFAULT APACHE CONF
	cat /srv/tools/conf-client/default.conf > /etc/apache2/sites-available/default.conf
	# REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	

	# ADD APACHE MODULES
    echo
    echo "adding apache modules "
    echo
	a2enmod ssl
	a2enmod rewrite
	a2enmod headers

	# ENABLE DEFAULT SITE
	echo
    echo "Enabling default site"
    echo
    a2ensite default

	# DISABLE ORG DEFAULT SITE
    echo
    echo "Disabling original default site "
	echo
    a2dissite 000-default

    echo
    echo "installing and configuring apache2 done"
    echo
