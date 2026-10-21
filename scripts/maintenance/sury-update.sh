#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow


outputHandler "comment" "Move from ppa:ondrej to Sury.org"


outputHandler "comment" "Remove PPAs"
command "sudo add-apt-repository --remove ppa:ondrej/php -y"
command "sudo add-apt-repository --remove ppa:ondrej/apache -y"


outputHandler "comment" "Update keyring"
command "curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb"
command "sudo dpkg -i /tmp/debsuryorg-archive-keyring.deb"


outputHandler "comment" "Install Sury source"
command "echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(. /etc/os-release && echo "$VERSION_CODENAME") main" | sudo tee /etc/apt/sources.list.d/php.list"


outputHandler "comment" "Update server"
command "update_server"

outputHandler "comment" "Updated PHP version"
command "sudo php -v"
