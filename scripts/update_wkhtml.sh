#!/bin/bash

echo "-----------------------------------------"
echo
echo "            UPDATING WKHTMLTO"
echo
echo
echo "     http://wkhtmltopdf.org - LGPLv3"
echo

# UPDATE WKHTML
sudo cp /srv/tools/_conf/wkhtmltoimage /usr/bin/static_wkhtmltoimage
sudo cp /srv/tools/_conf/wkhtmltopdf /usr/bin/static_wkhtmltopdf
