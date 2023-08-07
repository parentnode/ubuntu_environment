#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow


outputHandler "comment" "Upgrade to PHP8.2"


# INSTALL PHP8.2
command "sudo add-apt-repository ppa:ondrej/php -y"
command "sudo apt-get update"

command "sudo apt-get install -y libapache2-mod-php php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-dev php8.2-mbstring php8.2-zip php8.2-mysql php8.2-xmlrpc"

outputHandler "comment" "setting up php.ini"
command "sudo cat /srv/tools/conf-server/php-8.2-apache2.ini > /etc/php/8.2/apache2/php.ini"
command "sudo cat /srv/tools/conf-server/php-8.2-cli.ini > /etc/php/8.2/cli/php.ini"


command "sudo a2dismod php7.4"
command "sudo a2enmod php8.2"

command "sudo php -v"
