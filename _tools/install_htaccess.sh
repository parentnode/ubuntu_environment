#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "               HTACCESS"
echo
echo


if test "$install_htpassword_for_user" = "Y"; then

	echo
	

	if [ ! -e "/srv/auth-file" ]; then

		htpasswd -cm /srv/auth-file $install_user

	else

		htpasswd -m /srv/auth-file $install_user

	fi

	echo
	echo

else

	echo
	echo "Skipping HTACCESS"
	echo

fi
