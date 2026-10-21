#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow
install_user="$(whoami)"
export install_user

echo "install_user: $install_user"

outputHandler "comment" "Updating bash conf"


outputHandler "comment" "Update .bash_profile"
cp /srv/tools/conf-server/dot_bash_profile /home/$install_user/.bash_profile
sudo chown kaestel:kaestel /home/$install_user/.bash_profile

outputHandler "comment" "Update .bash_aliases"
cp /srv/tools/conf-server/dot_bash_aliases /home/$install_user/.bash_aliases
sudo chown kaestel:kaestel /home/$install_user/.bash_aliases
