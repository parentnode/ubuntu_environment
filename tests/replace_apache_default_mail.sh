#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
install_email="jessen-it@outlook.com"
#apache_email=$(grep "ServerAdmin" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail/email_file | cut -d' ' -f10 || echo "")
grep_apache_email=$(trimString "$(grep "ServerAdmin" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail/email_file)")
apache_email=$(echo "$grep_apache_email" | cut -d' ' -f2)
#echo "$apache_email"

if [ -z "$apache_email" ]; then
    echo "trying to set mail"
    sed -i "s/ServerAdmin\ /ServerAdmin $install_email/" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail/email_file
fi
#echo "$apache_email"
if [ "$apache_email" = "webmaster@localhost" ]; then
    sed -i "s/webmaster@localhost/$install_email/" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail/email_file
    #echo "Test $apache_email"
fi
