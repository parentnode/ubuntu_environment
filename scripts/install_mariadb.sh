#!/bin/bash -e
echo
echo "Installing mariadb"
echo
sudo -E apt install -q -y mariadb-server
echo 

echo
echo "Configuring mariadb"
echo

# RESTART APACHE
service apache2 restart

# Do we have root password
if [ -n "$db_root_password" ]; then

    # Checking mysql login - trying to log in without password (UBUNTU 16.04)
    dbstatus=$(sudo mysql --user=root -e exit 2>/dev/null || echo 1)

    # Checking mysql login - trying to log in with temp password (UBUNTU 14.04)
    #dbstatus=$(sudo mysql --user=root --password=temp -e exit 2>/dev/null || echo 1)

    # Login was successful - it means that DB was not set up yet
    if [ -z "$dbstatus" ]; then

        # set login mode (mysql_native_password) and password for root account
        #echo "UPDATE mysql.user SET plugin = '', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root -ptemp

        # FOR UBUNTU 16.04/MariaDB 10
        echo "UPDATE mysql.user SET plugin = 'mysql_native_password', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root

        # REPLACE PASSWORD FOR MAINTANENCE ACCOUNT
        sudo sed -i "s/password = .*/password = $db_root_password/;" /etc/mysql/debian.cnf

        echo "DB Root access configured"

    fi

fi

echo
echo "Installing and configuring mariadb done"
echo