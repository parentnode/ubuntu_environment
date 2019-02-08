#!/bin/bash -e

guiText "MariaDB" "Install"

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
        guiText "password" "Install"
        echo "UPDATE mysql.user SET plugin = 'mysql_native_password', password = PASSWORD('$db_root_password') WHERE user = 'root'; FLUSH PRIVILEGES;" | sudo mysql -u root
        guiText "maintenance password" "Replace" "new password"
        # REPLACE PASSWORD FOR MAINTANENCE ACCOUNT
        sudo sed -i "s/password = .*/password = $db_root_password/;" /etc/mysql/debian.cnf

        guiText "DB Root access" "Installed"

    fi

fi

guiText "MariaDB" "Done"