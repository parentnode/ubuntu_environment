#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow


outputHandler "comment" "Move from ppa:ondrej to Sury.org"


outputHandler "comment" "Remove PPAs"
sudo add-apt-repository --remove ppa:ondrej/php -y
sudo add-apt-repository --remove ppa:ondrej/apache2 -y


outputHandler "comment" "Update keyring"
curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
sudo dpkg -i /tmp/debsuryorg-archive-keyring.deb


outputHandler "comment" "Install Sury source"
echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(. /etc/os-release && echo "$VERSION_CODENAME") main" | sudo tee /etc/apt/sources.list.d/php.list


outputHandler "comment" "Update server"
update_server

outputHandler "comment" "Updated PHP version"
sudo php -v
