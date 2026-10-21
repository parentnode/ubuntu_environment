#!/bin/bash -e


source /srv/tools/scripts/functions.sh
enableSuperCow

install_user="$(getUsername)"
export install_user


outputHandler "comment" "Updating bash conf"


outputHandler "comment" "Update .bash_profile"
cp /srv/tools/conf/dot_bash_profile /home/$install_user/.bash_profile

outputHandler "comment" "Update .bash_profile"
cp /srv/tools/conf/dot_bash_aliases /home/$install_user/.bash_aliases
