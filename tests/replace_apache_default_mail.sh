#!/bin/bash -e
# This is a test for replacing whatever value at the ServerAdmin section in apache.conf with a valid email
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh


install_email="mail@outlook.com"

#Catching the line where keyword is ServerAdmin trimming the string for leading and trailing spaces 
grep_apache_email=$(trimString "$(grep "ServerAdmin" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail_apache/apache_test_file)")
#Seperate the line at the first space in to parts and saving the second part in a variable ($apache_email) here is the mail normally located
apache_email=$(echo "$grep_apache_email" | cut -d' ' -f2)

# If $apache_email is replace the ServerAdmin line with a new one containing the mail in $install_mail
if [ -z "$apache_email" ]; then
    echo "trying to set mail"
    sed -i "s/ServerAdmin\ /ServerAdmin $install_email/" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail_apache/apache_test_file
fi
# After a fresh installation of apache the ServerAdmin gets a placeholder mail to work called webmaster@local,
# here we replace that email with $apache_email
if [ "$apache_email" = "webmaster@localhost" ]; then
    sed -i "s/webmaster@localhost/$install_email/" /srv/sites/parentnode/ubuntu_environment/tests/test_replace_default_mail_apache/apache_test_file
fi
