#!/bin/bash -e
outputHandler "section" "WKHTML"
outputHandler "comment" "http://wkhtmltopdf.org - LGPLv3"

if test "$install_wkhtml" = "Y"; then

	# WKHTML - FORCE PASSWORD RENEWAL
	outputHandler "comment" "Using /srv/tools/bin/wkhtmltopdf"
	#sudo apt install -y wkhtmltopdf
	# installedPackage "wkhtmltopdf"
	# sudo cp /srv/tools/conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
	# sudo cp /srv/tools/conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf
	#wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
	#wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
	wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
	tar -xvf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
	cd wkhtmltox/bin/
	sudo mv wkhtmltopdf  /usr/bin/wkhtmltopdf
	sudo mv wkhtmltoimage  /usr/bin/wkhtmltoimage

else
	outputHandler "section" "skipping WKHTML"
fi

