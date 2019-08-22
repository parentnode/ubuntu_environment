#!/bin/bash -e

echo "--------------------------------------------------------------"
echo ""
echo "Installing parentNode in ubuntu"
echo "DO NOT CLOSE UNTIL INSTALL ARE COMPLETE" 
echo "You will see 'Install complete' message once it's done"
echo ""
echo ""


source /srv/tools/scripts/functions.sh
enableSuperCow
#outputHandler "section" "outputHandler test"
#outputHandler "comment" "Nothing special to comment on"
#outputHandler "exit" "I'm leaving for ever"
# GET INSTALL USER
install_user="$(getUsername)"
#$(whoami | awk '{print $1}')
export install_user
outputHandler "comment" "Installing system for $install_user"

# Check software prerequisites is met
. /srv/tools/scripts/check_software_prerequisites_is_met.sh

# Checking directories
. /srv/tools/scripts/checking_directories.sh

# INSTALL SOFTWARE
. /srv/tools/scripts/install_software.sh

# Setting up configuration files for the webserver
. /srv/tools/scripts/install_webserver_configuration_client.sh




# Change Folder Rights from root to current user
outputHandler "comment" "Changing folder rights from root to $install_user"
chown -R $install_user:$install_user /srv/sites


echo ""
echo "parentNode installed in Ubuntu "
echo ""
outputHandler "comment" "Link to information regarding this script" "https://parentnode.dk/blog/installing-the-web-stack-on-an-ubuntu-client"
echo "Install complete"
echo "--------------------------------------------------------------"
echo ""

