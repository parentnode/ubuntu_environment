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
	echo "Using /srv/tools/bin"
	# sudo apt install -y wkhtmltopdf
	# sudo cp /srv/tools/conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
	# sudo cp /srv/tools/conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf

else
	echo "Skipping WKHTML"
fi

echo
echo

