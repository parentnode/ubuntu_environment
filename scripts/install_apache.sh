#!/bin/bash -e

# INSTALL APACHE
    # Check for server name
	install_apache_servername=$(grep -E "^ServerName" /etc/apache2/apache2.conf || echo "")
	# If no results
	if [ -z "$install_apache_servername" ]; then
		outputHandler "comment" "Setting up ServerName"
        # SET SERVERNAME
		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
        echo
	else
		# Replace existing servername with hostname
        outputHandler "comment" "Replace ServerName with Hostname"
		sed -i "s/^ServerName\ [a-zA-Z0-9\.\_-]\+/ServerName\ $HOSTNAME/;" /etc/apache2/apache2.conf
        echo
	fi

	# remove path (slashes) from output to avoid problem with testing string
    install_parentnode_includes=$(grep "^IncludeOptional \/srv\/sites\/apache\/\*\.conf" /etc/apache2/apache2.conf | sed "s/\/srv\/sites\/apache\/\*\.conf//;" || echo "")
	if test -z "$install_parentnode_includes"; then
		# ADD GIT CONF SETUP
        outputHandler "comment" "Setting up GIT configuration"
		echo "IncludeOptional /srv/sites/apache/*.conf" >> /etc/apache2/apache2.conf
		echo
	fi

	install_apache_access_for_srv_sites=$(grep -E "^<Directory /srv/sites>" /etc/apache2/apache2.conf || echo "")
	if [ -z "$install_apache_access_for_srv_sites" ]; then
		# Give access to /srv/sites folder from the apache configuration added to bottom of /etc/apache2/apache2.conf
		outputHandler "comment" "Setting up access to /srv/sites"
		echo "" >> /etc/apache2/apache2.conf
		echo "<Directory "/srv/sites">" >> /etc/apache2/apache2.conf
		echo "	Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/apache2.conf
		echo "	AllowOverride All" >> /etc/apache2/apache2.conf
		echo "	Require all granted" >> /etc/apache2/apache2.conf
		echo "</Directory>" >> /etc/apache2/apache2.conf
    	echo "" >> /etc/apache2/apache2.conf
		
	else
		outputHandler "comment" "Access to /srv/sites allready granted"
	fi

	# ADD DEFAULT APACHE CONF
	output "comment" "Setting up default parentNode apache conf"
	cat /srv/tools/conf-client/default.conf > /etc/apache2/sites-available/default.conf
	
	outputHandler "Replace default mail with Mail you entered earlier"
	# REPLACE EMAIL WITH PREVIOUSLY STATED EMAIL
	sed -i "s/webmaster@localhost/$install_email/;" /etc/apache2/sites-available/default.conf
	

	# ADD APACHE MODULES
    outputHandler "comment" "enabling apache modules"
	outputHandler "comment" "enable SSL"
	a2enmod ssl
	outputHandler "comment" "enable Rewrite"
	a2enmod rewrite
	outputHandler "comment" "enable Headers"
	a2enmod headers

	# ENABLE DEFAULT SITE
	echo
    outputHandler "comment" "enable default site"
    a2ensite default
	echo
	# DISABLE ORG DEFAULT SITE
    outputHandler "disable original default site"
    a2dissite 000-default

