#!/bin/bash -e

echo 
echo "Configuring php"
echo
# UPDATE PHP CONF
# PHP 5
#cat /srv/tools/conf-client/php-apache2.ini > /etc/php5/apache2/php.ini
#cat /srv/tools/conf-client/php-cli.ini > /etc/php5/cli/php.ini

# PHP 7.1
#cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.1/apache2/php.ini
#cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.1/cli/php.ini

echo
echo "Copying contents from parentnode apache2.ini into /etc/php/7.2/apache2/php.ini"
echo
# PHP 7.2
cat /srv/tools/conf-client/php-apache2.ini > /etc/php/7.2/apache2/php.ini
echo
echo "Copying contents from parentnode php-cli.ini into /etc/php/7.2/cli/php.ini"
echo
cat /srv/tools/conf-client/php-cli.ini > /etc/php/7.2/cli/php.ini
echo

echo
echo "Installing and configuring php done"
echo