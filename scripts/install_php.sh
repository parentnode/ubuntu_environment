#!/bin/bash -e
# UPDATE PHP CONF
# PHP 5
#cat /srv/tools/conf-client/php-apache2.ini > /etc/php5/apache2/php.ini
#cat /srv/tools/conf-client/php-cli.ini > /etc/php5/cli/php.ini

# PHP 7.1
#cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.1/apache2/php.ini
#cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.1/cli/php.ini

guiText "apache2.ini" "Install"
# PHP 7.2
cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.2/apache2/php.ini
echo

guiText "php-cli.ini" "Install"
cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.2/cli/php.ini
