#!/bin/bash -e
source /srv/tools/scripts/functions.sh
outputHandler "section" "Setting up another user for parentnode webstack for ubuntu"

outputHandler "comment" "Choose what platform you are setting up a user on"
outputHandler "comment" "1: Server"
outputHandler "comment" "2: client"
chooseplatform_array=("[12]")
chooseplatform=$(ask "Choose an option 1 or 2" "${chooseplatform_array[@]}" "Not a valid option")

install_user="$(getUsername)"
if [ "$chooseplatform" = "2" ]; then
    echo "" >> /home/$install_user/.bashrc
    echo "if [ -f \"/home/$install_user/.bash_profile\" ]; then" >> /home/$install_user/.bashrc
    echo " . /home/$install_user/.bash_profile" >> /home/$install_user/.bashrc
    echo "fi" >> /home/$install_user/.bashrc
    cp /srv/tools/conf-client/dot_profile /home/$install_user/.bash_profile
else
    cp /srv/tools/conf-server/dot_profile /home/$install_user/.bash_profile
fi