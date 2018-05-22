#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               HTACCESS"
echo
echo


if test "$install_htpassword_for_user" = "Y"; then

	echo
	

	if [ ! -e "/srv/auth-file" ]; then

		htpasswd -cmb /srv/auth-file $install_user $install_htaccess_password

	else

		htpasswd -mb /srv/auth-file $install_user $install_htaccess_password

	fi

	echo
	echo

else

	echo
	echo "Skipping HTACCESS"
	echo

fi
