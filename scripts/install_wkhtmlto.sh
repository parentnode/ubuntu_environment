#!/bin/bash -e
outputHandler "section" "WKHTML"
outputHandler "comment" "http://wkhtmltopdf.org - LGPLv3"

if test "$install_wkhtml" = "Y"; then

	# WKHTML - FORCE PASSWORD RENEWAL
	outputHandler "comment" "Using /srv/tools/bin/wkhtmltopdf"
	# sudo apt install -y wkhtmltopdf
	# installedPackage "wkhtmltopdf"
	# sudo cp /srv/tools/conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
	# sudo cp /srv/tools/conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf

else
	outputHandler "section" "skipping WKHTML"
fi

