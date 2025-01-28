#!/bin/bash -e

if test "$install_webserver_conf" = "Y"; then
    guiText "Apache2" "Install"
    bash /srv/tools/scripts/install_apache.sh
    guiText "Apache2" "Done"

    guiText "PHP" "Install"
    bash /srv/tools/scripts/install_php.sh
    guiText "PHP7.2" "Done"	

    
    # MAKE LOGS FOLDER
    if [ ! -e "/srv/sites/apache/apache.conf" ]; then
        # Add Default apache conf
        cat /srv/tools/conf-client/apache.conf > /srv/sites/apache/apache.conf
    fi

    guiText "Restarting Apache" "Comment"
    # RESTARTING APACHE ARE IMPORTANT FOR REST OF THE SCRIPT!!
    service apache2 restart

    guiText "MariaDB" "Install"
    bash /srv/tools/scripts/install_mariadb.sh
    guiText "MariaDB" "Done"
else
    guiText "Webserver" "Skip"
fi
