#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow
install_user="$(getUsername)"
export install_user


outputHandler "comment" "Upgrade to PHP8.2"


# INSTALL PHP8.2
command "sudo apt-get install -y libapache2-mod-php php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-dev php8.2-mbstring php8.2-zip php8.2-mysql php8.2-xmlrpc"

command "sudo a2dismod php7.4"
command "sudo a2enmod php8.2"

command "sudo php -v"
