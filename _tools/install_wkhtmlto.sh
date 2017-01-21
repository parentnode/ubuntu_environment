#!/bin/bash -e

echo "-----------------------------------------"
echo
echo "                 WKHTML"
echo
echo
echo "      http://wkhtmltopdf.org - LGPLv3"
echo


if test "$install_wkhtml" = "Y"; then

	# WKHTML - FORCE PASSWORD RENEWAL
	sudo -k -y apt install wkhtmltopdf
	#cp /srv/tools/_conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
	#cp /srv/tools/_conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf

else
	echo "Skipping WKHTML"
fi

