#!/bin/bash -e

outputHandler "section" "HTACCESS"

if test "$install_htpassword_for_user" = "Y"; then

	

	if [ ! -e "/srv/auth-file" ]; then

		htpasswd -cmb /srv/auth-file $install_user $install_htaccess_password

	else

		htpasswd -mb /srv/auth-file $install_user $install_htaccess_password

	fi

else
	outputHandler "section" "Skipping HTACCESS"

fi
