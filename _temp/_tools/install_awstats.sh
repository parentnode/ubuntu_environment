echo
echo "AWStats"

read -p "Install AWStats (Y/n): " install_awstats
if test "$install_awstats" = "Y"; then

	aptitude install awstats 
	#libgeo-ipfree-perl libnet-ip-perl

	# MAKE AWSTATS FOLDERS
	if [ ! -d "/srv/awstats" ]; then
		mkdir /srv/awstats
	fi

	if [ ! -d "/srv/awstats/site" ]; then
		mkdir /srv/awstats/site
	fi

	if [ ! -d "/srv/awstats/conf" ]; then
		mkdir /srv/awstats/conf
	fi

	# COPY HELPER FILES
	cat /srv/tools/configuration/awstats/index.php > /srv/awstats/site/index.php
	#cat /srv/tools/configuration/awstats/new_config.php > /srv/awstats/site/new_config.php
	cat /srv/tools/configuration/awstats.conf > /srv/awstats/conf/awstats.conf

	# ADD TO APACHE CONF
	echo "Include /srv/awstats/conf/awstats.conf" >> /etc/apache2/apache2.conf

	echo "AWStats domain:"
	read awstats_name

	sed -i 's/awstatsdomain/'"$awstats_name"'/;' /srv/awstats/conf/awstats.conf


	echo "Add password for AWStats"
	# INSTALL HTACCESS USER FOR AWSTATS
	if [ ! -e "/srv/auth-file" ]; then
		htpasswd -cm /srv/auth-file awstats
	else
		htpasswd -m /srv/auth-file awstats
	fi


	# UPDATE LOGROTATE PERMISSIONS FOR APACHE LOG
	sed -i 's/create\ 640\ root\ adm/create\ 644\ root\ adm/;' /etc/logrotate.d/apache2

	# UPDATE CURRENT PERMISSIONS
	chmod 755 /var/log/apache2/
	chmod 644 -R /var/log/apache2/*

	# shouldn't have to do this as it should be the default - but keep here for reference
	# chown root:root /etc/awstats
	# chmod 755 /etc/awstats
	# chmod 644 -R /etc/awstats/*


	# ADD CGI MODULE
	a2enmod cgi

	# RESTART APACHE
	service apache2 restart

else
	echo "Skipping AWStats"
fi

